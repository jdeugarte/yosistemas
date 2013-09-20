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

    # Never trust parameters from the scary internet, only allow the white list through.
    def tema_params
      params.require(:tema).permit(:titulo, :cuerpo)
    end
end
