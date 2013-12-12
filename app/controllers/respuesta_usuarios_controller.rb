class RespuestaUsuariosController < ApplicationController
	def nuevo
		@cuestionario = Cuestionario.find(params[:id])
		@respuesta = RespuestaUsuario.new
		@contador = 0
		@cuestionario_id = params[:id]
	end
	def crear
		@contador = params[:cont]
		@cuestionario_id = params[:id_cuestionario]
		current_user.respuesta_usuarios.create(respuesta: params[:respuetabool])
		redirect_to "/cuestionarios/nuevo/"+params[:id_cuestionario].to_s
	end
	def terminado
		current_user.respuesta_usuarios.create(respuesta: params[:respuetabool])
		redirect_to root_path
	end
end
