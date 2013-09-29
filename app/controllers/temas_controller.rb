class TemasController < ApplicationController
# GET /temas
  def index
    @temas = Tema.order(params[:sort])
  end
  
  def search
    @temas=Array.new 
    aux = Tema.all
    if params[:titulo] != "" && params[:titulo] != nil
      aux.each do |tema|
        if (tema.correspondeATitulo(params[:titulo]))
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

  def show
     @tema = Tema.find(params[:id])
  end

  # POST /temas
  def create
    @tema = Tema.new(tema_params)
    @tema.usuario_id = current_user.id 
    @tema.save
    redirect_to temas_url 
  end

  def edit
    @tema = Tema.find(params[:id])
  end

  def update
    @tema = Tema.find(params[:id])

    if(@tema.update(params[:tema].permit(:titulo,:cuerpo)))
      redirect_to @tema
    else
      render 'edit'
    end
   
  end

  def editComment
    @comment=Comment.find(params[:idcomment])    
  end

  def visible
    @tema = Tema.find(params[:id])
    if @tema.visible == 1
       @tema.visible = 0
       @tema.save
    else
      @tema.visible = 1
      @tema.save
    end
    redirect_to temas_url
  end

  private

    # No permite parametros de internet
    def tema_params
      params.require(:tema).permit(:titulo, :cuerpo)
    end


end
