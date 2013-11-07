class TemasYTareasController < ApplicationController
  skip_before_filter :require_log_in,:only=>[:index]
  def index
    if(params[:id] != nil)
       @grupo = Grupo.find(params[:id])
     else
       @grupo = Grupo.find(1)
       redirect_to temas_path
    end
   if(params[:id]==1)
    redirect_to temas_path
   else
    @temas_y_tareas = @grupo.temas.where("visible = ?", 1) + @grupo.tareas
    @temas_y_tareas.sort{|x,y| x.created_at <=> y.created_at}
   end
  end
end
