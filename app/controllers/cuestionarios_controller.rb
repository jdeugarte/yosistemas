class CuestionariosController < ApplicationController
	def ver_cuestionarios_usuarios
  	@cuestionario = Cuestionario.find(params[:id_cuestionario])
  	@suscritos =  Subscripcion.where(grupo_id: @cuestionario.grupo_id)
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
      @cuestionario = Cuestionario.find(params[:id_cuestionario])
      @suscritos =  Subscripcion.where(grupo_id: @cuestionario.grupo_id)
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
    @cuestionario = Cuestionario.find(params[:id_cuestionario])
    @preguntas = Pregunta.where(cuestionario_id: @cuestionario.id)  
    @respuestas_correctas = Array.new
    @respuestas_incorrectas = Array.new
    @preguntas.each do |pregunta|
      respuestas_usuarios_true = RespuestaUsuario.where(pregunta_id: pregunta.id,calificacion: true)
      respuestas_usuarios_false = RespuestaUsuario.where(pregunta_id: pregunta.id,calificacion: false)
      @respuestas_correctas.push(respuestas_usuarios_true.size)
      @respuestas_incorrectas.push(respuestas_usuarios_false.size)
    end
  end

  def cargar_respuestas
    @cuestionario = Cuestionario.find(params[:id_cuestionario])
    @respuestas = RespuestaUsuario.where(:usuario_id=>params[:id_usuario], :cuestionario_id=> params[:id_cuestionario])
  end

	def cuestionarios_de_grupo_index
		@grupo = Grupo.find(params[:id])
    if !@grupo.habilitado
      redirect_to temas_path
    end
		@cuestionarios = Cuestionario.buscar_cuestionarios(@grupo).page(params[:page]).per(2)
	end

	def nuevo_cuestionario
		@cuestionario = Cuestionario.new
		@grupo = Grupo.find(params[:id])
		@cuestionarios = Cuestionario.buscar_cuestionarios(@grupo)
    @grupos = Grupo.where("usuario_id = ?", current_user.id)
	end

  def calificar
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
		@cuestionario = Cuestionario.find(params[:id])
		@grupo = Grupo.find(@cuestionario.grupo_id)
		@cuestionarios = Cuestionario.buscar_cuestionarios(@grupo)
    @grupos = Grupo.where("usuario_id = ?", current_user.id)
	end

  def create
		@cuestionario = Cuestionario.new(cuestionario_params)
    @cuestionario.save
    flash[:alert] = "Cuestionario Creado con exito!";
		redirect_to "/cuestionarios/cuestionarios_de_grupo_index/"+params[:cuestionario][:grupo_id]
	end

	def update
		@cuestionario = Cuestionario.find(params[:id])
    @cuestionario.update(cuestionario_params)
    @cuestionario.save
    redirect_to "/cuestionarios/cuestionarios_de_grupo_index/"+params[:grupo_id]
	end

  def editar_cuestionario
    @cuestionario = Cuestionario.find(params[:id])
    @grupo = Grupo.find(@cuestionario.grupo_id)
    @cuestionarios = Cuestionario.buscar_cuestionarios(@grupo)
    @grupos = Grupo.where("usuario_id = ?", current_user.id)
  end

	def delete
		@cuestionario = Cuestionario.find(params[:id])
    	@cuestionario.destroy
    	redirect_to '/'
  	end

  	def usar_plantilla
  		@cuestionario_plantilla = Cuestionario.find(params[:id])
  		@cuestionario=@cuestionario_plantilla.dup
      @cuestionario.preguntas=@cuestionario_plantilla.preguntas
      @cuestionario.save
  		@grupo = Grupo.find(@cuestionario_plantilla.grupo_id)
  		redirect_to '/cuestionarios/'+@cuestionario.id.to_s+'/edit'
  	end

    def publicarlo
      cuestionario = Cuestionario.find(params[:id])
      cuestionario.estado = true
      cuestionario.save
      redirect_to '/'
    end

  	

  private
    def cuestionario_params
      params.permit!
      params.require(:cuestionario).permit(:titulo, :descripcion, :fecha_limite, :hora_limite, :estado, :grupo_id, :usuario_id, preguntas_attributes: [:id, :texto, :tipo, :_destroy, respuestas_attributes: [:id, :texto, :respuesta_correcta, :_destroy]])
    end
end