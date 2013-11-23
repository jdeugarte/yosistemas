class CuestionariosController < ApplicationController

	def nuevo_cuestionario
		@cuestionario = Cuestionario.new
		@grupo = Grupo.find(params[:id])
	end

	def create
		@cuestionario = Cuestionario.new(cuestionario_params)
		@cuestionario.estado = true
		@cuestionario.save
		redirect_to mis_grupos_path
	end

  private
    def cuestionario_params
      params.require(:cuestionario).permit(:titulo, :descripcion, :fecha_limite, :estado, :grupo_id, :usuario_id)
    end
end