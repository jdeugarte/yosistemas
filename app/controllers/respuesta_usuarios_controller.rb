class RespuestaUsuariosController < ApplicationController
	skip_before_filter :verify_authenticity_token
	def nuevo
		@cuestionario = Cuestionario.find(params[:id])
		#@respuesta = RespuestaUsuario.new
		#@contador = 0
		#@cuestionario_id = params[:id]
	end

	def crear 
		
		@respuestas = params[:resp]
		@cuestionario_id = params[:id_cuestionario]
		@usuario_id = params[:id_usuario]
		@preguntas_id = params[:id_pregunta]
		@pregunta_tipo = params[:tipo_pregunta]
		cont = 0
		if(!RespuestaUsuario.ya_respondio_cuestionario(current_user.id,@cuestionario_id))
			@respuestas.each do |r|
				@respuestaUsuario = RespuestaUsuario.new(:respuesta => r, :cuestionario_id => @cuestionario_id , 
					:usuario_id => @usuario_id, :pregunta_id => @preguntas_id[cont], :tipo => @pregunta_tipo[cont])
				res = Respuesta.where(pregunta_id: @preguntas_id[cont])
				res.each do |reee|
					if @preguntas_id[cont]==reee.pregunta_id && r==reee.texto && reee.respuesta_correcta == true
						@respuestaUsuario.calificacion = true
						@respuestaUsuario.save
						break
					else
						@respuestaUsuario.calificacion = false
					end
				end	   
				@respuestaUsuario.save
				
				agregar_archivos_adjuntos(@respuestaUsuario.id)
				cont += 1
			end
		end
	end
=begin
	def crear
		@contador = params[:cont]
		@cuestionario_id = params[:id_cuestionario]
		current_user.respuesta_usuarios.create(respuesta: params[:respuetabool])
		redirect_to "/cuestionarios/nuevo/"+@cuestionario_id.to_s
	end
	def terminado
		current_user.respuesta_usuarios.create(respuesta: params[:respuetabool])
		redirect_to root_path
	end
=end

private
    def agregar_archivos_adjuntos(respuesta_usuario_id)
      if(!params[:respuesta_usuario][:archivo].nil?)
        params[:respuesta_usuario][:archivo].each do |arch|
        @archivo = AdjuntoRespuestaCuestionario.new(:archivo=>arch)
        @archivo.respuesta_usuario_id = respuesta_usuario_id
        @archivo.save
       
        end
      end
    end

    def eliminar_archivos_adjuntos(idsParaBorrar)
        if (!idsParaBorrar.nil?)
          idsParaBorrar.slice!(0)
           idsParaBorrar=idsParaBorrar.split("-")
           idsParaBorrar.each do |id|
               AdjuntoRespuestaCuestionario.destroy(id)
           end
        end
    end

end
