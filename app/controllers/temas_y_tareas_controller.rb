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
      @all = @temas+@tareas.order("updated_at DESC").page(params[:page]).per(6)
    end
  end

  def buscar
    @temas = Array.new
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
    end
    @ides=sacarIds(@temas)
    @temas= Kaminari.paginate_array(@temas).page(params[:page]).per(5)
    render 'index'
  end

  def sacarIds(temas)
    concatenacion=""
    temas.each do |tema|
      concatenacion=concatenacion+"-"+tema.id.to_s
    end
    return concatenacion
  end


end
