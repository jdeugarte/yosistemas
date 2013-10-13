class GruposController < ApplicationController

  def index
    @grupos = Grupo.all
  end

	def new
    @grupo = Grupo.new
  end

  def show
     @grupo = Grupo.find(params[:id])
  end

  # POST /temas
  def create
    @grupo = Grupo.new(grupo_params)
    @grupo.usuario_id = current_user.id
    @grupo.llave = verificar_grupo(@grupo.estado) 
    @grupo.save
    redirect_to temas_url 
  end

  def subscription_group
    @grupo = Grupo.find(params[:id])
  end

  private
    # No permite parametros de internet
    def grupo_params
      params.require(:grupo).permit(:nombre, :descripcion, :estado, :llave)
    end

    #genera un string aleatorio
    def generar_llave
    	cadena = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
		llave = (0...6).map{ cadena[rand(cadena.length)] }.join
		llave
    end

    def verificar_grupo(estado)
    	if estado == true
    		llave = generar_llave
    	else
    		llave = nil
    	end
    	return llave
    end
end
