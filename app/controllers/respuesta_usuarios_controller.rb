class RespuestaUsuariosController < ApplicationController
	def nuevo
		@cuestionario = Cuestionario.find(params[:id])
		@respuesta = RespuestaUsuario.new
	end
	def crear
		@respuesta = RespuestaUsuario.new
	end
end
