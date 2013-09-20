class TemasController < ApplicationController
# GET /temas
  def index
    @temas = Tema.all
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

  private

    # No permite parametros de internet
    def tema_params
      params.require(:tema).permit(:titulo, :cuerpo)
    end
end
