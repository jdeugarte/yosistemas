class RespuestaUsuariosController < ApplicationController
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
		cont = 0
		@respuestas.each do |r|
			@respuestaUsuario = RespuestaUsuario.new(:respuesta => r, :cuestionario_id => @cuestionario_id , 
				:usuario_id => @usuario_id, :pregunta_id => @preguntas_id[cont])
			@respuestaUsuario.save
			cont += 1
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
end