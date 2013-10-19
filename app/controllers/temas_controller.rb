class TemasController < ApplicationController
# GET /temas


skip_before_filter :require_log_in,:only=>[:index,:search,:searchByDescription,:show,:searchtitulo]
  def index
    if(params[:id] != nil)
       @grupo = Grupo.find(params[:id])
     else
       @grupo = Grupo.find(1)
    end
   
    #@temas = Tema.order(params[:sort)]
    @temas = @grupo.temas.order(params[:sort])#.sort(params[:sort])

  end
  
  def search
    @temas=Array.new
    @grupo=Grupo.find(params[:grupo])
    aux = Tema.where(:grupo_id=>params[:grupo])
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
  def searchtitulo
    @temas = Array.new
      if(params[:id] != nil)
       @grupo = Grupo.find(params[:id])
     else
       @grupo = Grupo.find(1)
    end
    if params[:themes] != nil && params[:themes] != "" 
      @ids = params[:themes]
      @ids.slice!(0)
      @ids=@ids.split("-")
    
      @ids.each do |id|
          @temas.push(Tema.find(id))
      end
      @temas.sort! { |a,b| a.titulo.downcase <=> b.titulo.downcase }
     end
    render 'index'
  end
  def searchdetalle
    @temas = Array.new
      if(params[:id] != nil)
       @grupo = Grupo.find(params[:id])
     else
       @grupo = Grupo.find(1)
    end
    if params[:themes] != nil && params[:themes] != "" 
      @ids = params[:themes]
      @ids.slice!(0)
      @ids=@ids.split("-")
    
      @ids.each do |id|
          @temas.push(Tema.find(id))
      end
      @temas.sort! { |a,b| a.cuerpo.downcase <=> b.cuerpo.downcase }
     end
    render 'index'
  end
  def searchByDescription(keyWords)
    keyWords = keyWords.downcase
      initialResult = Tema.where('cuerpo LIKE ?', '%'+keyWords+'%')
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
        results<<Tema.where('cuerpo LIKE ?', '%'+word+'%')
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
    @grupos = Array.new
    if(current_user!=nil)
      current_user.subscriptions.each do |subs|
        @grupos.push(subs.grupo)
      end
      @grupo = Grupo.find(params[:id])
    end
  end

  def show
     @tema = Tema.find(params[:id])
  end

  # POST /temas
  def create
    @tema = Tema.new(tema_params)
    @tema.grupo_id=params[:tema][:grupo_id]
    @tema.usuario_id = current_user.id 
    @tema.save
    @suscripcion=SuscripcionTema.new
    @suscripcion.usuario_id=current_user.id
    @suscripcion.tema_id=@tema.id
    @suscripcion.save
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
    render "show_mine"
  end


  private
    # No permite parametros de internet
    def tema_params
      params.require(:tema).permit(:titulo, :cuerpo)
    end


end
