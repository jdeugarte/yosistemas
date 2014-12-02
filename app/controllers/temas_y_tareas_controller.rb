class TemasYTareasController < ApplicationController
  skip_before_filter :require_log_in,:only=>[:index]
  def index
    if( params[:id] != nil && Grupo.find(params[:id]).habilitado)
        @grupo = Grupo.find(params[:id])
        if @grupo.nombre == "Publico"
          redirect_to (:root)
        end
        @temas = @grupo.temas.order("updated_at DESC").page(params[:page]).per(3)
        @tareas = @grupo.tareas.order("updated_at DESC").page(params[:page]).per(3)
        @all = (@temas+@tareas).sort_by(&:created_at).reverse
    else
      redirect_to(:root)
    end
  end

  def ordenar
    lista_unida = Unir_Tareas_y_Temas(params[:id])
    @all = OrdenarLista(params[:opcion],lista_unida)
    render 'index'
  end

  def indexTemas
     
    @search = Array.new 
    @temas = @grupo.temas.order("updated_at DESC").page(params[:page]).per(3)
    #@ides = sacarIds(@grupo.temas)
    @tareas = Tarea.where(:grupo_id => params[:id]).order("updated_at DESC").page(params[:page]).per(3)
    #@idest = sacarIdsTareas(@grupo.tareas)

    @search
    
    @todosgrupos=Grupo.all
  end

  def buscar
    @temas = Array.new
    @tareas= Array.new
    @search = Array.new
    @grupo = Grupo.find(params[:grupo])
    aux = Tema.where(:grupo_id=>params[:grupo])
    if params[:search] != "" && params[:search] != nil
      byAll = Tema.allResultsSearchs(params[:search])
      @temas = byAll     
      @temas.each do |tema|
        res = false
        current_user.suscripcion_temas.each do |sus|
          if tema.id==sus.tema_id
            res = true
          end
        end
        if !res
          @temas.delete(tema)
        end
      end
      @temas.each do |tema|
        if !tema.grupo.habilitado
          @temas.delete(tema)
        end
      end          
      byAllTarea = Tarea.allResultsSearchsTarea(params[:search])
      @tareas = byAllTarea 
      @tareas.each do |tarea|
        res = false
        current_user.subscripcions.each do |sus|
          if tarea.grupo_id == sus.grupo_id
            res = true
          end
        end
        if !res
          @tareas.delete(tarea)
        end
      end
    end
    @idest=sacarIdsTareas(@tareas)
    @ides=sacarIds(@temas)
    @search=(@temas+@tareas).sort_by(&:created_at).reverse
    #@temas= Kaminari.paginate_array(@temas).page(params[:page]).per(5)
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

  private

  def OrdenarLista(opcion,lista_unida)
    case opcion
    when "reciente"
    lista_ordenada = lista_unida.sort_by(&:created_at).reverse
    when "antiguo"
    lista_ordenada = lista_unida.sort_by(&:created_at)
    when "alfabeticamente"
    lista_ordenada= lista_unida.sort! { |a,b| a.titulo.downcase <=> b.titulo.downcase }
   return lista_ordenada
    end
  end

  def Unir_Tareas_y_Temas(id)
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
      @tareas = @grupo.tareas.order("updated_at DESC").page(params[:page]).per(3)
      return @all = (@temas+@tareas).sort_by(&:created_at).reverse
    end
  end
end
