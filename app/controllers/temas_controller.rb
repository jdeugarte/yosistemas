require 'pusher'
class TemasController < ApplicationController
skip_before_filter :require_log_in,:only=>[:index,:search,:searchByDescription,:show,:searchtitulo]
before_filter :grupos
  def index
     @temas = Array.new 
   if params[:id] != nil && Grupo.find(params[:id]).habilitado
        @grupo = Grupo.find(params[:id])       
      else
        @grupo = Grupo.find(1)
      end
       @grupo.temas.each do |tema|
          if tema.aprobado?(@grupo.id) || @grupo.llave == "publico"
            @temas << tema
          end
        end
        @ides=sacarIds(@temas)
  end


  def buscar
    @temas = Array.new
    @grupo = Grupo.find(params[:grupo])
    aux = Tema.where(:grupo_id=>params[:grupo])
    if params[:search] != "" && params[:search] != nil
      byAll = Tema.allResultsSearchs(params[:search])
      @temas = byAll        
      @temas.each do |tema|
        if !tema.grupo.habilitado
          @temas.delete(tema)
        end
      end          
    end
    @ides=sacarIds(@temas)
    @temas= Kaminari.paginate_array(@temas).page(params[:page]).per(5)
    render 'index'
  end



  def ordertable
    @temas = Array.new
    if(params[:id] != nil)
      @grupo = Grupo.find(params[:id])
    else
      @grupo = Grupo.find(1)
    end
    if params[:themes] != nil && params[:themes] != ""
      @ids = params[:themes]
      @ids.slice!(0)
      @ids=@ids.split("-")
      @ids.each do |id|
        if id != "" && id != nil
          @temas.push(Tema.find(id))
        end
      end
      if params[:var] == "titulo"
        @temas.sort! { |a,b| a.titulo.downcase <=> b.titulo.downcase }
      else
        #@temas.sort! { |a,b| a.cuerpo.downcase <=> b.cuerpo.downcase }
        @temas.sort! { |a,b| a.created_at <=> b.created_at }
      end
    end
    @ides=sacarIds(@temas)
    @temas= Kaminari.paginate_array(@temas).page(params[:page]).per(5)
    render 'index'
  end

  def ordertablemine
    @temas = Array.new
    if params[:themes] != nil && params[:themes] != ""
      @ids = params[:themes]
      @ids.slice!(0)
      @ids=@ids.split("-")
      @ids.each do |id|
        if id != "" && id != nil
          @temas.push(Tema.find(id))
        end
      end
      if params[:var] == "titulo"
        @temas.sort! { |a,b| a.titulo.downcase <=> b.titulo.downcase }
      else
        if params[:var] == "fecha"
          #@temas.sort! { |a,b| a.cuerpo.downcase <=> b.cuerpo.downcase }
          @temas.sort! { |a,b| a.created_at <=> b.created_at }
        #else
         # @temas.sort! { |a,b| a.grupo.nombre.downcase <=> b.grupo.nombre.downcase }
        end
      end
    end
    render "show_mine"
  end

  public
  # GET /temas/new
  def new
    @tema = Tema.new
    @grupos = Array.new
    if(current_user!=nil)
      current_user.subscripcions.each do |subs|
        @grupos.push(subs.grupo)
      end
      @grupo = Grupo.find(params[:id])
      @GrupoDefecto = @grupo
      @id = params[:id]
    end
  end

  def show
    if Tema.exists?(:id => params[:id])
    @tema = Tema.find(params[:id])
    @tema.grupos.each do |grupo|
      if current_user.esta_subscrito?(grupo.id)
        @grupo = grupo
        break
      end
    end
     #notificaciones.each do |notificacion|
      #if ( TemaComentario.find(notificacion.tema_comentario_id).tema_id == @tema.id )
       # notificacion.notificado = true
        #notificacion.save
      #end
    #end
      @comentarios= Kaminari.paginate_array(@tema.tema_comentarios).page(params[:page]).per(10)
    else
      @temas = @grupo.temas.order("updated_at DESC").page(params[:page]).per(5)
      
      if Tema.where(:id => params[:id])
        flash[:alert] = 'El Tema fue eliminado'
        redirect_to '/no_existe'
      else
        redirect_to :back
      end
    end 
  end

  # POST /temas
  def create
    @tema = Tema.new(tema_params)
    @tema.usuario_id = current_user.id

    if params[:grupos] != nil && @tema.save
      params[:grupos].each do |grupo|
        grupi = Grupo.find(grupo)
        grupi.temas << @tema
        @tema.grupos_pertenece << grupo
        grupi.save
        if current_user.rol == "Docente" 
          @tema.grupos_dirigidos << grupo
        end
      end

      @tema.save
      add_attached_files(@tema.id)
      
      @suscripcion=SuscripcionTema.new
      @suscripcion.usuario_id=current_user.id
      @suscripcion.tema_id=@tema.id
      @suscripcion.save
      
      if current_user.rol == "Docente"        
        notificacion_push(params[:grupos], @tema)
        notificar_por_email(params[:grupos], @tema)
      end

      if current_user.rol == "Estudiante"           
        notificar_creacion(params[:grupos], @tema)
      end

      flash[:alert] = 'Tema creado Exitosamente!'
      redirect_to '/temas/'+@tema.id.to_s
    else
      flash[:alert] = 'El tema no pudo ser creado!'
      redirect_to(:back)
    end
  end

  private
    def add_attached_files(tema_id)
      if(!params[:tema][:archivo].nil?)
        params[:tema][:archivo].each do |arch|
        @archivo = ArchivoAdjuntoTema.new(:archivo=>arch)
        @archivo.tema_id = tema_id
        @archivo.save
        end
      end
    end

  public

  def edit
    @tema = Tema.find(params[:id])
  end

  def update
    @tema = Tema.find(params[:id])
    if(@tema.update(params[:tema].permit(:titulo,:cuerpo)))
      eliminar_archivos_adjuntos(params[:elemsParaElim])
      add_attached_files(@tema.id)
      redirect_to @tema
    else
      render 'edit'
    end
  end

  def eliminar_archivos_adjuntos(idsParaBorrar)
    if (!idsParaBorrar.nil?)
      idsParaBorrar.slice!(0)
       idsParaBorrar=idsParaBorrar.split("-")
       idsParaBorrar.each do |id|
           ArchivoAdjuntoTema.destroy(id)
       end
    end
  end

  def editar_comentario
    @comentario = TemaComentario.find(params[:id_comentario])
    @comentario.tema.grupos.each do |grupo|
      if current_user.esta_subscrito?(grupo.id)
        @grupo = grupo
        break
      end
    end
  end

  def visible
    @tema = Tema.find(params[:id])
    grupo = params[:id_grupo]
    if(@tema.usuario_id == current_user.id)
      @tema.destroy
    end
    redirect_to "/grupos/"+grupo+"/temas"
  end

  def show_mine
    todos_temas = Tema.all
    @temas = Array.new
    todos_temas.each do |tema|
      if(tema.usuario_id == current_user.id)
        @temas.push(tema)
      end
    end
    @ides=sacarIds(@temas)
    render "show_mine"
  end

  def searchmine
    @temas = Array.new
    aux = Tema.all
    if params[:titulo] != "" && params[:titulo] != nil
      aux.each do |tema|
        if (tema.correspondeATitulo(params[:titulo]))
          @temas.push(tema)
        end
      end
    else
      @temas = aux
    end
    /codigo agregado para busqueda por descripcion/
    if params[:descripcion] != "" && params[:descripcion] != nil
      byDescription = Tema.searchByDescription(params[:descripcion])
      if params[:titulo] == "" || params[:titulo] == nil
        @temas=byDescription
      else
        @temas = ((@temas&byDescription)+@temas+byDescription).uniq
      end
    end
    render "show_mine"
  end

  def search_main
    @temas=Array.new
    aux= Tema.all
    if params[:search] != "" && params[:search] != nil
      byAll = Tema.allResultsSearchs(params[:search])
      @temas = byAll
    end
    render "show_mine"
  end

   def aprove
    @tema = Tema.find(params[:id])
    params[:grupos].each do |grupo|
     @tema.grupos_dirigidos << grupo
    end

    @tema.save
    notificacion_push(@tema.grupos_pertenece, @tema)
    notificar_por_email(@tema.grupos_pertenece, @tema)
    redirect_to :back
  end

  private
    # No permite parametros de internet
    def tema_params
      params.require(:tema).permit(:titulo, :cuerpo, :grupo_id, :admitido)
    end
    
    def grupos
        @grupo = Grupo.find(1)
    end

    def notificacion_push(id_grupos, tema)
      notificado = Hash.new
      notificado[current_user.id] = true
      suscripciones = Subscripcion.all
      id_grupos.each do |grupo|
      id_grupo = grupo.to_i
        suscripciones.each do |suscrito|
          if suscrito.grupo_id == id_grupo
            if notificado[suscrito.usuario_id] == nil
               notificado[suscrito.usuario_id] = true
              @usuario = suscrito.usuario
              if @usuario.push_theme == true
                if @usuario != nil
                  @grupo = Grupo.find(id_grupo)
                  @notificacion = Notification.new
                  @notificacion.title = tema.titulo
                  @notificacion.description = tema.cuerpo
                  @notificacion.reference_date = nil
                  @notificacion.tipo = 1
                  @notificacion.de_usuario_id = current_user.id
                  @notificacion.para_usuario_id = @usuario.id
                  @notificacion.seen = false
                  @notificacion.id_item = tema.id
                  @notificacion.save
                  Pusher.url = "http://673a73008280ca569283:555e099ce1a2bfc840b9@api.pusherapp.com/apps/60344"
                  Pusher['notifications_channel'].trigger('notification_event', {
                    para_usuario: @notificacion.para_usuario_id
                  })
                end
              end
            end
          end
        end
      end
    end

def notificar_creacion(id_grupos, tema)
notificado = Hash.new  
id_grupos.each do |grupo|
id_grupo = grupo.to_i
@grupo = Grupo.find(grupo)
if Grupo.find(id_grupo).llave != "publico"
  @usuario = Usuario.find(@grupo.usuario_id)
  if notificado[@usuario.id] == nil
  notificado[@usuario.id] = true
  @notificacion = Notification.new
  @notificacion.title = tema.titulo
  @notificacion.description = tema.cuerpo
  @notificacion.reference_date = nil
  @notificacion.tipo = 5
  @notificacion.de_usuario_id = current_user.id
  @notificacion.para_usuario_id = @usuario.id
  @notificacion.seen = false
  @notificacion.id_item = tema.id
  @notificacion.save
  Pusher.url = "http://673a73008280ca569283:555e099ce1a2bfc840b9@api.pusherapp.com/apps/60344"
  Pusher['notifications_channel'].trigger('notification_event', {
  para_usuario: @notificacion.para_usuario_id
  })
  SendMail.notify_theme_creation(@usuario, tema, @grupo).deliver
end
end 
end
end

    def notificar_por_email(id_grupos, tema)
      notificado = Hash.new
      notificado[current_user.id] = true
      suscripciones = Subscripcion.all
      id_grupos.each do |grupo|
        id_grupo = grupo.to_i
          suscripciones.each do |suscrito|
            if suscrito.grupo_id == id_grupo
              if notificado[suscrito.usuario_id] == nil
                 notificado[suscrito.usuario_id] = true
                  @usuario = suscrito.usuario
                  if @usuario.mailer_theme == true
                    if @usuario != nil
                      @grupo = Grupo.find(id_grupo)
                      SendMail.notify_users_tema(@usuario, tema, @grupo).deliver
                    end
                  end
              end
            end
          end
      end
    end

    def sacarIds(temas)
      concatenacion=""
      temas.each do |tema|
        concatenacion=concatenacion+"-"+tema.id.to_s
      end
      return concatenacion
    end
end