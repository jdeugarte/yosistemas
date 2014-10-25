class TemasYTareasController < ApplicationController
  skip_before_filter :require_log_in,:only=>[:index]
  def index
    
    if( params[:id] != nil && Grupo.find(params[:id]).habilitado)
       @grupo = Grupo.find(params[:id])
    else
       @grupo = Grupo.find(1)
       redirect_to temas_path
    end
    if(params[:id]=="1")
      redirect_to temas_path
    else
      @temas = @grupo.temas.order("updated_at DESC").page(params[:page]).per(3)
      @tareas = Tarea.where(:grupo_id => params[:id]).order("updated_at DESC").page(params[:page]).per(3)
      @all = (@temas+@tareas).sort_by(&:created_at).reverse

    end
  end

  def indexTemas
    @temas = @grupo.temas.order("updated_at DESC").page(params[:page]).per(5)
    @ides = sacarIds(@grupo.temas)
    @tareas = Tarea.where(:grupo_id => params[:id]).order("updated_at DESC").page(params[:page]).per(3)
    @idest = sacarIdsTareas(@grupo.tareas)
    
    
    @todosgrupos=Grupo.all
  end

  def buscar
    @temas = Array.new
    @tareas = Array.new
    @grupo = Grupo.find(params[:grupo])
    aux = Tema.where(:grupo_id=>params[:grupo])
    if params[:search] != "" && params[:search] != nil
      byAll = Tema.allResultsSearchs(params[:search])
      @temas = byAll        
      @temas.each do |tema|
        if !tema.grupo.habilitado
          @temas.delete(tema)
        end
      end          

      byAllTarea = Tarea.allResultsSearchsTarea(params[:search])
      @tareas = byAllTarea        
      
    end
    @idest=sacarIdsTareas(@tareas)
    @ides=sacarIds(@temas)
    @temas= Kaminari.paginate_array(@temas).page(params[:page]).per(5)
    render 'indexSearch'
  end

  def sacarIds(temas)
    concatenacion=""
    temas.each do |tema|
      concatenacion=concatenacion+"-"+tema.id.to_s
    end
    return concatenacion
  end

  def sacarIdsTareas(tareas)
    concatenacion=""
    tareas.each do |tarea|
      concatenacion=concatenacion+"-"+tarea.id.to_s
    end
    return concatenacion
  end
end
