class CuestionariosController < ApplicationController
	def ver_cuestionarios_usuarios
    @cuestionario = Cuestionario.find(params[:id_cuestionario])
    control = false
  	@suscritos = Array.new
    @mapi = Hash.new
    @cuestionario.grupos.each do |grupo|
      if current_user.esta_subscrito?(grupo.id) and !control
          @grupo = grupo
          control = true
      end
      Subscripcion.where(grupo_id: grupo.id).each do |sub|
        if @mapi[sub.usuario_id] != true 
          @suscritos << sub
          @mapi[sub.usuario_id] = true
        end
      end
    end
  	@usuarios = Array.new
    @respuestas = Array.new
    @preguntas = Array.new
    @preguntas = Pregunta.where(cuestionario_id: @cuestionario.id)
  	@suscritos.each do |suscrito|
  		if (suscrito.usuario_id != current_user.id)
  			@usuario = Usuario.find(suscrito.usuario_id)
        @respuestas_usuario = RespuestaUsuario.where(usuario_id: suscrito.usuario_id)
        if(@respuestas_usuario.count > 0)
          @usuarios.push(@usuario)
        end
  		end  		
  	end
  end


  def ver_resultado
      @cuestionario = Cuestionario.find(params[:id_cuestionario])
      control = false
      @cuestionario.grupos.each do |grupo|
        if current_user.esta_subscrito?(grupo.id) and !control
          @grupo = grupo
          control = true
        end
      end
      @usuario = current_user
      @respuestas = Array.new
      @preguntas = Array.new
      @preguntas = Pregunta.where(cuestionario_id: @cuestionario.id)
      @respuestas_usuario = RespuestaUsuario.where(usuario_id: @usuario.id,cuestionario_id: @cuestionario.id)
      @respuestas_usuario.each do |respuesta|
        @respuestas.push(respuesta)
      end
  end

  def ver_resultados_usuarios #sssss 
    control = false
      @cuestionario = Cuestionario.find(params[:id_cuestionario])
      @mapi = Hash.new
      @suscritos = Array.new
       @cuestionario.grupos.each do |grupo|
        if current_user.esta_subscrito?(grupo.id) and !control
          @grupo = grupo
          control = true
      end
      Subscripcion.where(grupo_id: grupo.id).each do |sub|
        if @mapi[sub.usuario_id] != true 
          @suscritos << sub
          @mapi[sub.usuario_id] = true
        end
      end
    end
      @usuarios = Array.new
      @respuestas = Array.new
      @preguntas = Array.new
      @preguntas = Pregunta.where(cuestionario_id: @cuestionario.id)
      @suscritos.each do |suscrito|
        if (suscrito.usuario_id != current_user.id)
          @usuario = Usuario.find(suscrito.usuario_id)
          @usuarios.push(@usuario)
          @respuestas_usuario = RespuestaUsuario.where(usuario_id: suscrito.usuario_id,cuestionario_id: @cuestionario.id)
          @respuestas_usuario.each do |respuesta|
            @respuestas.push(respuesta)
          end
        end
  		end
  end

  def ver_resumen
    control = false
    @cuestionario = Cuestionario.find(params[:id_cuestionario])
    @preguntas = Pregunta.where(cuestionario_id: @cuestionario.id)  
    @respuestas_correctas = Array.new
    @respuestas_incorrectas = Array.new
    @cuestionario.grupos.each do |grupo|
    if current_user.esta_subscrito?(grupo.id) and !control
          @grupo = grupo
          control = true
      end
    end
    @preguntas.each do |pregunta|
      respuestas_usuarios_true = RespuestaUsuario.where(pregunta_id: pregunta.id,calificacion: true)
      respuestas_usuarios_false = RespuestaUsuario.where(pregunta_id: pregunta.id,calificacion: false)
      @respuestas_correctas.push(respuestas_usuarios_true.size)
      @respuestas_incorrectas.push(respuestas_usuarios_false.size)
    end
  end

  def cargar_respuestas
    control = false
    @cuestionario = Cuestionario.find(params[:id_cuestionario])
    @cuestionario.grupos.each do |grupo|
      if current_user.esta_subscrito?(grupo.id) and !control
          @grupo = grupo
          control = true
      end
    end
    @respuestas = RespuestaUsuario.where(:usuario_id=>params[:id_usuario], :cuestionario_id=> params[:id_cuestionario])
  end

	def cuestionarios_de_grupo_index
		@grupo = Grupo.find(params[:id])
    if !@grupo.habilitado
      redirect_to temas_path
    end
    @cuestionarios = Array.new
    @grupo.cuestionarios.each do |cuestio|
      @cuestionarios << cuestio
    end
	end

	def nuevo_cuestionario
		@cuestionario = Cuestionario.new
		@grupo = Grupo.find(params[:id])
		@cuestionarios = Array.new
    current_user.grupos.each do |grupo|
      grupo.cuestionarios.each do |cuestio|
         @cuestionarios << cuestio 
      end
    end
    @cuestionarios = @cuestionarios.uniq
    
    @grupos = Grupo.where("usuario_id = ?", current_user.id)
	end

  def calificar
    control = false
    res = RespuestaUsuario.find(params[:id_respuestas].first)
    cuestionario = Cuestionario.find(res.cuestionario_id)
    cuestionario.grupos.each do |grupo|
      if current_user.esta_subscrito?(grupo.id) and !control
          @grupo = grupo
          control = true
      end
    end
    if params[:comentarios] == nil && params[:calificacion] == nil
      redirect_to (:back)
    end
    @comentarios = params[:comentarios]
    @calificacion = params[:calificacion]
    @id_respuestas = params[:id_respuestas]
    cont = 0
    @id_respuestas.each do |id|
      @respuesta = RespuestaUsuario.find(id)
      @respuesta.comentario = @comentarios[cont]
      @respuesta.calificacion = @calificacion[cont]
      @respuesta.save
      cont += 1
    end
  end

	def edit
    control = false
		@cuestionario = Cuestionario.find(params[:id])
    @cuestionario.grupos.each do |grupo|
      if current_user.esta_subscrito?(grupo.id) and !control
        @grupo = grupo
        control = true
      end
    end
		
    @cuestionarios = Array.new
    current_user.grupos.each do |grupo|
      grupo.cuestionarios.each do |cuestio|
         @cuestionarios << cuestio 
      end
    end
    @cuestionarios = @cuestionarios.uniq 

    @grupos = Grupo.where("usuario_id = ?", current_user.id)
	end  

  def create
		@cuestionario = Cuestionario.new(cuestionario_params)
    @cuestionario.grupos_pertenecen = params[:grupos_pertenecen]
    if params[:grupos] != nil && @cuestionario.save
      params[:grupos].each do |grupo|
          grupi = Grupo.find(grupo)
          grupi.cuestionarios << @cuestionario
          grupi.save
        end
      flash[:notice] = "Cuestionario creado Exitosamente!"
      redirect_to "/cuestionarios/cuestionarios_de_grupo_index/"+params[:grupos][0]
    else
      flash[:notice] = "El cuestionario no pudo ser creado!"
      redirect_to(:back)
    end

		
	end

	def update
		@cuestionario = Cuestionario.find(params[:id])
    Grupo.all.each do |grupo|
      grupo.cuestionarios.each do |cuestio|
        if cuestio.titulo == @cuestionario.titulo
          @grupo = grupo
          break
        end
      end
    end   
    @cuestionario.update(cuestionario_params)
    @cuestionario.save
    redirect_to "/cuestionarios/cuestionarios_de_grupo_index/"+@grupo.id.to_s
	end

  def editar_cuestionario
    control = false
    @cuestionario = Cuestionario.find(params[:id])
    @cuestionario.grupos.each do |grupo|
      if current_user.administra(grupo.id) and !control
        @grupo = grupo
        control = true
      end
    end
     @cuestionarios = Array.new
    @grupo.cuestionarios.each do |cuestio|
      @cuestionarios << cuestio
    end

    if @cuestionario.admitido == false
      @cuestionario.grupos.each do |grupo|
        notificar_por_email(grupo.id, @cuestionario)
        notificacion_push(grupo.id, @cuestionario)
      end
    end
    
  end

	def delete
		@cuestionario = Cuestionario.find(params[:id]) 
  	@cuestionario.destroy
  	redirect_to :back
  	end

  	def usar_plantilla
  		@cuestionario_plantilla = Cuestionario.find(params[:id])
  		@cuestionario=@cuestionario_plantilla.dup
      @cuestionario.preguntas=@cuestionario_plantilla.preguntas
      @cuestionario.save

      @cuestionario_plantilla.grupos.each do |grupo|
      if current_user.administra(grupo.id)
        @grupo = grupo
        break
      end
    end

  		redirect_to '/cuestionarios/'+@cuestionario.id.to_s+'/edit'
  	end

    def publicarlo
      cuestionario = Cuestionario.find(params[:id])
      cuestionario.estado = true
      cuestionario.save
      redirect_to '/'
    end

    def notificacion_push(id_grupo,cuestionario)
    suscripciones = Subscripcion.all
    suscripciones.each do |suscrito|
      if suscrito.grupo_id == id_grupo
        if suscrito.usuario_id != current_user.id
          @usuario = suscrito.usuario
          if @usuario.push_quest == true
            if @usuario != nil
              @grupo = Grupo.find(id_grupo)
              notificacion = Notification.create('title'=>cuestionario.titulo, 'description'=>cuestionario.descripcion, 'reference_date'=> cuestionario.fecha_limite,
              'tipo'=>3, 'de_usuario_id'=>current_user.id, 'para_usuario_id'=> @usuario.id, 'seen'=>false, 'id_item'=> cuestionario.id)
              Pusher.url = "http://673a73008280ca569283:555e099ce1a2bfc840b9@api.pusherapp.com/apps/60344"
              Pusher['notifications_channel'].trigger('notification_event', {
              para_usuario: notificacion.para_usuario_id
              })
            end
          end
        end
      end
    end
  end

  def notificar_por_email(id_grupo,cuestionario)
    suscripciones = Subscripcion.all
    suscripciones.each do |suscrito|
      if suscrito.grupo_id == id_grupo
        if suscrito.usuario_id != current_user.id
          @usuario = suscrito.usuario
          if @usuario.mailer_quest == true
            if @usuario != nil
              @grupo = Grupo.find(id_grupo)
              SendMail.notify_users_quest_update(@usuario, cuestionario, @grupo).deliver
            end
          end
        end
      end
    end
  end

  private
    def cuestionario_params
      params.permit!
      params.require(:cuestionario).permit(:titulo, :descripcion, :fecha_limite, :hora_limite, :estado, :grupo_id, :usuario_id, :grupos_pertenecen, preguntas_attributes: [:id, :texto, :tipo, :_destroy, respuestas_attributes: [:id, :texto, :respuesta_correcta, :_destroy]])
    end
end