class GruposController < ApplicationController

  def index
    @grupos = Grupo.all
  end

  def search
    @grupos=Array.new 
    aux = Grupo.all
    nombre = params[:nombre]
    if nombre != "" && nombre != nil
      aux.each do |grupo|
        if (grupo.correspondeAGrupo(nombre))
          @grupos.push(grupo)
        end
      end
    else
      @grupos = aux
    end
    render 'index'
  end

	def new

    if (current_user!=nil && current_user.rol=="Estudiante")
      redirect_to root_path
    else
      @grupo = Grupo.new
    end
  end

  def show
     @grupo = Grupo.find(params[:id])
  end

  def create

    @grupo = Grupo.new(grupo_params)

    @grupo.usuario_id = current_user.id
    @grupo.llave = verificar_grupo(@grupo.estado) 
    subs = Subscription.new
    subs.grupo = @grupo
    subs.usuario = current_user
    subs.save
    if @grupo.save
      redirect_to '/grupos', :flash => { :info => "Grupo creado exitosamente" }
    else
      redirect_to "/grupos/new", :flash => { :error => "Error al crear un grupo" }
    end 
  end

  def subscription_group
    @grupo = Grupo.find(params[:id])
  end

  private
  
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
    		llave = "publico"
    	end
    	return llave
    end
end
