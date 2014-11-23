class GruposController < ApplicationController
  attr_accessor :estado, :nombre
  before_filter :grupos
  
  def index
    @grupos = Grupo.all_habilitados.page(params[:page]).per(5)
  end

  def deshabilitar_grupo
    grupo = Grupo.find(params[:id])
    if current_user == grupo.usuario
      grupo.deshabilitar_grupo
    end
    redirect_to (:back)
  end

  def habilitar_grupo
    grupo = Grupo.find(params[:id])
    if current_user == grupo.usuario
      grupo.habilitar_grupo
    end
    redirect_to (:back)
  end
  
  def buscar
    @grupos = Grupo.where("nombre LIKE ?", "%#{params[:nombre]}%").page(params[:page]).per(5)
    render 'index'
  end

  def buscar_por_llave
    @grupos = Grupo.where("llave = ? AND estado = ?", "#{params[:llave]}", true)
    @grupo = @grupos.first
    if !@grupo.nil?
      suscripcion = Subscripcion.new
      suscripcion.grupo_id = @grupo.id
      suscripcion.usuario_id = current_user.id
      suscripcion.save
      redirect_to '/grupos/'+@grupo.id.to_s+'/temas-y-tareas/', :flash => { :info => "Se ha suscrito al grupo: "+"' "+ @grupo.nombre+" '"+" exitosamente" }     
    else
      redirect_to root_path, :flash => { :info => "La llave que proporciono no pertenece a ningun grupo" }
    end 
  end

  def new
    if (current_user == nil || current_user.rol == "Estudiante")
      redirect_to root_path, :flash => { :info => "No tiene privilegios requeridos para crear un grupo" }
    else
      @grupo = Grupo.new
    end
  end

  def show
     @grupo = Grupo.find(params[:id])
  end

  def edit
    @grupo = Grupo.find(params[:id])
  end

  def update
    @grupo = Grupo.find(params[:id])
    if(@grupo.update(grupo_params))               
      redirect_to @grupo, :flash => { :alert => "Los datos del grupo han sido actualizados exitosamente." }
    else
      render 'edit'
    end
  end

  def create
    @grupo = Grupo.new(grupo_params)
    @grupo.usuario_id = current_user.id
    #la funcion de abajo verifica si se creo un grupo publico, o uno privado para generar la clave
    @grupo.verificar_grupo
      if @grupo.save
        subs = Subscripcion.new
        subs.grupo = @grupo
        subs.usuario = current_user
        subs.save
        redirect_to @grupo, :flash => { :alert => 'Grupo ha sido creado.' } 
      else
        render 'new', :flash => { :alert => "Error al crear un grupo" }
      end
  end

  def subscripcion_grupo
    @grupo = Grupo.find(params[:id])
  end

  def suscriptores
    @grupo = Grupo.find(params[:id])
    @suscriptores = @grupo.subscripcions
  end

  def detalle_usuario
    @usuario = Usuario.find(params[:id])
  end

  def invitacion_grupo
    @grupo = Grupo.find(params[:id])
  end

  def enviar_invitaciones
    @grupo = Grupo.find(params[:id])
    correos = (params[:correos]).split(",")
    correos.each do |correo|
      SendMail.enviar_invitaciones(current_user, correo, @grupo).deliver
    end
    redirect_to '/grupos/invitacion_grupo/'+params[:id].to_s, :flash => { :info => "Sus invitaciones fueron enviadas."}
  end

  private
    def grupo_params
      params.require(:grupo).permit(:nombre, :descripcion, :estado, :llave)
    end

    def grupos
      if(params[:id] != nil && Grupo.find(params[:id]).habilitado)
        @grupo = Grupo.find(params[:id])
      else
        @grupo = Grupo.find(1)
      end
    end

    def redirigir_a(grupo)
      if grupo.estado==true
         redirect_to grupo, :flash => { :info => "Grupo creado exitosamente" }
      else
        redirect_to root_path, :flash => { :info => "Grupo creado exitosamente" }
      end
    end    
end
