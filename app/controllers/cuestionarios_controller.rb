class CuestionariosController < ApplicationController

	def cuestionarios_de_grupo_index
		@grupo = Grupo.find(params[:id])
		@cuestionarios = Cuestionario.buscar_cuestionarios(@grupo)
	end

	def nuevo_cuestionario
		@cuestionario = Cuestionario.new
		@grupo = Grupo.find(params[:id])
	end

	def edit
		@cuestionario = Cuestionario.find(params[:id])
	end

	def create
		@cuestionario = Cuestionario.new(cuestionario_params)
		@cuestionario.estado = true
		@cuestionario.save
		redirect_to mis_grupos_path
	end

	def update
		@cuestionario = Cuestionario.find(params[:id])
      	@cuestionario.update(cuestionario_params)
      	redirect_to mis_grupos_path
	end

	def delete
		@cuestionario = Cuestionario.find(params[:id])
    	@cuestionario.destroy
    	redirect_to mis_grupos_path
  	end

  private
    def cuestionario_params
      params.permit!
      params.require(:cuestionario).permit(:titulo, :descripcion, :fecha_limite, :estado, :grupo_id, :usuario_id)
    end
end