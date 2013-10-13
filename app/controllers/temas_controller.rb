class TemasController < ApplicationController
# GET /temas
skip_before_filter :require_log_in,:only=>[:index,:search,:searchByDescription,:show]
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
    /codigo agregado para busqueda por descripcion/
    if params[:descripcion] != "" && params[:descripcion] != nil
      byDescription = searchByDescription(params[:descripcion])
      if params[:titulo] == "" || params[:titulo] == nil
        @temas=byDescription
      else
        @temas = ((@temas&byDescription)+@temas+byDescription).uniq
      end
    end
    render 'index'
  end

  def searchByDescription(keyWords)
    keyWords = keyWords.downcase
      initialResult = Tema.find(:all, :conditions => ['cuerpo LIKE ?', '%'+keyWords+'%'])
      deepResult = deepSearchOfDescription(keyWords)
      finalRes  = (initialResult+deepResult).uniq
      finalRes
  end

  private
  /methods for deepSeach/
    def deepSearchOfDescription(keyWords)
      keyWordArray = keyWords.split
      keyWordArray = deleteIrrelevantWords(keyWordArray)
      keyWordArray.uniq!
      results=[]
      keyWordArray.each do |word|
        results<<Tema.find(:all, :conditions => ['cuerpo LIKE ?', '%'+word+'%'])
      end
      finalResArray = results.flatten.uniq
      finalResArray
    end

    def deleteIrrelevantWords(keyWordArray)
      res = keyWordArray - ["de", "a", "la", "el","los","en","al", "con", "que","por", "si","es","son"]
      i=0
      while(i<res.length)
        if(res[i].length<=3)
          res.delete_at(i)
        end
        i+=1
      end
      res
    end
  public

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

  def show_mine
    todos_temas = Tema.all
    @temas = Array.new
    todos_temas.each do |tema|
      if(tema.usuario_id == current_user.id)
        @temas.push(tema)
      end
    end
    render "index"
  end


  private
    # No permite parametros de internet
    def tema_params
      params.require(:tema).permit(:titulo, :cuerpo)
    end


end
