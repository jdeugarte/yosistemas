class TemasController < ApplicationController
# GET /temas
  def index
    @temas = Tema.all
  end
  
  def search
    @temas=Array.new 
    aux = Tema.all
    if params[:titulo] != ""
      aux.each do |tema|
        if tema.titulo.downcase.include?(params[:titulo].downcase)
          @temas.push(tema)
        end
      end
    else
      @temas = aux
    end
    render 'index'
  end

  # GET /temas/new
  def new
    @tema = Tema.new
  end

  # POST /temas
  def create
    @tema = Tema.new(tema_params)
    @tema.save
    redirect_to temas_url 
  end

  def edit
    @tema = Tema.find(params[:id])
  end

  def update
    @tema = Tema.find(params[:id])

    if(@tema.update(params[:tema].permit(:titulo,:cuerpo)))
      redirect_to temas_url
    else
      render 'edit'
    end

  end
  private

    # No permite parametros de internet
    def tema_params
      params.require(:tema).permit(:titulo, :cuerpo)
    end


end
