class CuestionariosController < ApplicationController

	def ver_cuestionarios_usuarios
  	@cuestionario=Cuestionario.find(params[:id_cuestionario])
  	@suscritos= Subscripcion.where(grupo_id: @cuestionario.grupo_id)
  	@usuarios=Array.new
    @respuestas=Array.new
    @preguntas=Array.new
    @preguntas=Pregunta.where(cuestionario_id: @cuestionario.id)
  	@suscritos.each do |suscrito|
  		if (suscrito.usuario_id!=current_user.id)
  			@usuario=Usuario.find(suscrito.usuario_id)
        @respuestas_usuario=RespuestaUsuario.where(usuario_id: suscrito.usuario_id)
        if(@respuestas_usuario.count >0)
          @usuarios.push(@usuario)
        end
  		end  		
  	end
  end

  def ver_resultados_usuarios #sssss 
      @cuestionario=Cuestionario.find(params[:id_cuestionario])
      @suscritos= Subscripcion.where(grupo_id: @cuestionario.grupo_id)
      @usuarios=Array.new
      @respuestas=Array.new
      @preguntas=Array.new
      @preguntas=Pregunta.where(cuestionario_id: @cuestionario.id)
      @suscritos.each do |suscrito|
        if (suscrito.usuario_id!=current_user.id)
          @usuario=Usuario.find(suscrito.usuario_id)
          @usuarios.push(@usuario)
          @respuestas_usuario=RespuestaUsuario.where(usuario_id: suscrito.usuario_id,cuestionario_id: @cuestionario.id)
          @respuestas_usuario.each do |respuesta|
            @respuestas.push(respuesta)
          end
        end
  		end
  end

  def cargar_respuestas
    @cuestionario=Cuestionario.find(params[:id_cuestionario])
    @respuestas=RespuestaUsuario.where(:usuario_id=>params[:id_usuario], :cuestionario_id=> params[:id_cuestionario])
  end

	def cuestionarios_de_grupo_index
		@grupo = Grupo.find(params[:id])
		@cuestionarios = Cuestionario.buscar_cuestionarios(@grupo).page(params[:page]).per(2)
    @cuestionarios.each do |cuestion|
     @res_enviado=!RespuestaUsuario.where(usuario_id:current_user.id,cuestionario_id:cuestion.id).first.nil?
    end
	end

	def nuevo_cuestionario
		@cuestionario = Cuestionario.new
		@grupo = Grupo.find(params[:id])
		@cuestionarios = Cuestionario.buscar_cuestionarios(@grupo)
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
=begin
    @respuesta=RespuestaUsuario.find(params[:id_resp])
    @respuesta.comentario=params[:comentario]
    @respuesta.calificacion=params[:calificacion]
    @respuesta.save
    redirect_to "cargar_respuestas/"+ params[:id_usuario].to_s + "/" + params[:id_cuestionario].to_s
=end
  end

	def edit
		@cuestionario = Cuestionario.find(params[:id])
		@grupo = Grupo.find(@cuestionario.grupo_id)
		@cuestionarios = Cuestionario.buscar_cuestionarios(@grupo)
	end

  def create
		@cuestionario = Cuestionario.new(cuestionario_params)
		@cuestionario.save
		#definir_tipo_de_pregunta(@cuestionario)
		redirect_to mis_grupos_path
	end

	def update
		@cuestionario = Cuestionario.find(params[:id])
      	@cuestionario.update(cuestionario_params)
      	redirect_to mis_grupos_path
	end

  def editar_cuestionario
    @cuestionario = Cuestionario.find(params[:id])
    @grupo = Grupo.find(@cuestionario.grupo_id)
    @cuestionarios = Cuestionario.buscar_cuestionarios(@grupo)
  end

	def delete
		@cuestionario = Cuestionario.find(params[:id])
    	@cuestionario.destroy
    	redirect_to mis_grupos_path
  	end

  	def usar_plantilla
  		@cuestionario_plantilla = Cuestionario.find(params[:id])
  		@cuestionario=@cuestionario_plantilla.clone
  		@grupo = Grupo.find(@cuestionario_plantilla.grupo_id)
  		redirect_to '/cuestionarios/'+@cuestionario.id.to_s+'/edit'
  	end

  	

  private
    def cuestionario_params
      params.permit!
      params.require(:cuestionario).permit(:titulo, :descripcion, :fecha_limite, :estado, :grupo_id, :usuario_id, preguntas_attributes: [:id, :texto, :tipo, :_destroy, respuestas_attributes: [:id, :texto, :respuesta_correcta, :_destroy]])
    end
end