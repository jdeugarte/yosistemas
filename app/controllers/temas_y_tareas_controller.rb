class TemasYTareasController < ApplicationController
  skip_before_filter :require_log_in,:only=>[:index]
  def index
    
    if( params[:id] != nil && Grupo.find(params[:id]).habilitado )
       @grupo = Grupo.find(params[:id])
     else
       @grupo = Grupo.find(1)
       redirect_to temas_path
    end
   if(params[:id]=="1")
    redirect_to temas_path
   else
    @temas_y_tareas = @grupo.temas.where("visible = ?", 1) + @grupo.tareas
    @temas_y_tareas.sort!{|x,y|  y.created_at <=> x.created_at}
   end
  end

end
