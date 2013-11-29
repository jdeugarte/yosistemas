class CuestionariosController < ApplicationController

	def cuestionarios_de_grupo_index
		@grupo = Grupo.find(params[:id])
		@cuestionarios = Cuestionario.buscar_cuestionarios(@grupo)
	end

	def nuevo_cuestionario
		@cuestionario = Cuestionario.new
		@grupo = Grupo.find(params[:id])
		@cuestionarios = Cuestionario.buscar_cuestionarios(@grupo)
	end

	def edit
		@cuestionario = Cuestionario.find(params[:id])
		@grupo = Grupo.find(params[:id])
		@cuestionarios = Cuestionario.buscar_cuestionarios(@grupo)
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

  	def usar_plantilla
  		@cuestionario_plantilla = Cuestionario.find(params[:id])
  		@cuestionario=@cuestionario_plantilla.clone
  		@grupo = Grupo.find(@cuestionario_plantilla.grupo_id)
  		redirect_to '/cuestionarios/'+@cuestionario.id.to_s+'/edit'
  	end

  private
    def cuestionario_params
      params.permit!
      params.require(:cuestionario).permit(:titulo, :descripcion, :fecha_limite, :estado, :grupo_id, :usuario_id, preguntas_attributes: [:id, :texto, :_destroy, respuestas_attributes: [:id, :texto, :_destroy]])
    end
end