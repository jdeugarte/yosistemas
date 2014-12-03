require 'pusher'
class TareasController < ApplicationController
	#GET tareas
	def index
		if( params[:grupo] != nil && Grupo.find(params[:grupo]).habilitado)
       	@grupo = Grupo.find(params[:grupo])
    	else
       	@grupo = Grupo.find(1)
       	redirect_to temas_path
    	end
    	if(params[:grupo]=="1")
      		redirect_to temas_path
    	else
      		@tareas = @grupo.tareas.order("updated_at DESC").page(params[:page]).per(5)
    	end
	end
	#GET tareas/new
	def responder_tarea
		@responder_tarea = ResponderTarea.new
		@tarea = Tarea.buscar_tarea(params[:id])
		if(!@tarea.nil?)
		#@grupo = @tarea.grupo
		#@id=@grupo.id
		#@suscrito = Subscripcion.where(:grupo_id => @grupo.id, :usuario_id => current_user.id)
		#if((@tarea.usuario_id!=current_user.id) && !@suscrito.first.nil? && !ResponderTarea.ya_envio_tarea(current_user.id,@tarea.id) )
		if((@tarea.usuario_id!=current_user.id) && !ResponderTarea.ya_envio_tarea(current_user.id,@tarea.id) )
		@grupos = Array.new
		if(current_user!=nil)
		current_user.subscripcions.each do |subs|
		@grupos.push(subs.grupo)
		end
		end
		else
		redirect_to root_path
		end
		else
		redirect_to root_path
		end
	end
	def mostrar_respuesta_tarea
		@respuesta_tarea=ResponderTarea.find(params[:id])
	end
	def responder_tarea_crear
		@responder_tarea = ResponderTarea.new(tarea_respuesta_params)
		@tarea = Tarea.find(params[:id])
		@responder_tarea.tarea_id = @tarea.id
		@responder_tarea.usuario_id = current_user.id
		if(@responder_tarea.save)
		add_attached_files_respuesta(@responder_tarea.id)
		flash[:alert] = 'Tarea enviada Exitosamente!'
		redirect_to '/tareas/'+@tarea.id.to_s
		else
		@grupos = Array.new
		if(current_user!=nil)
		current_user.subscripcions.each do |subs|
		@grupos.push(subs.grupo)
		end
		@grupo = Grupo.find(@tarea.grupo.id.to_s)
		@id = @tarea.grupo.id.to_s
		end
		render :responder_tarea;
		end
	end
	def new
		if(params[:id]!="1" && Grupo.find(params[:id]).usuario==current_user)
			@tarea = Tarea.new
			@grupos = Array.new
			if(current_user!=nil)
				current_user.subscripcions.each do |subs|
					@grupos.push(subs.grupo)
				end
				@grupo = Grupo.find(params[:id])
				@id = params[:id]
			end
		else
			redirect_to tareas_path
		end
	end
	def guardar_tarea_a_partir_de_otra
		@tarea = Tarea.new(tarea_params)
		@tarea.grupo_id=params[:tarea][:grupo_id]
		@tarea.usuario_id = current_user.id
		@tarea.tarea_base=params[:id_tarea_antigua]
		if(@tarea.save)
		add_attached_files(@tarea.id)
		flash[:alert] = 'Tarea creada Exitosamente!'
		notificar_por_email(@tarea.grupo_id, @tarea)
		redirect_to '/grupos/'+params[:tarea][:grupo_id]+'/tareas'
		end
	end
	def cargar_datos_tarea
		@tarea_antigua = Tarea.find(params[:id_tarea])
		@tarea = Tarea.new
		@tarea.titulo = @tarea_antigua.titulo
		@tarea.descripcion = @tarea_antigua.descripcion
		@tarea.fecha_entrega = @tarea_antigua.fecha_entrega
		@tarea.hora_entrega = @tarea_antigua.hora_entrega
		@tarea.grupo_id = @tarea_antigua.grupo_id
		@tarea.usuario_id = @tarea_antigua.usuario_id
		@tarea.tarea_base = @tarea_antigua.id
		@grupos = Array.new
		if(current_user != nil)
		current_user.subscripcions.each do |subs|
		@grupos.push(subs.grupo)
		end
		@grupo = Grupo.find(params[:id])
		@id = @tarea.grupo_id
		end
	end
	def eliminar
		@tarea = Tarea.find(params[:id])
		@tarea.grupos.each do |grupo|
	      if current_user.esta_subscrito?(grupo.id)
	       		@grupo = grupo
	        break
	      end
	    end
		if(@tarea.usuario_id == current_user.id)
		@tarea.destroy
		flash[:alert] = 'Tarea eliminada'
		end
		redirect_to '/grupos/'+@grupo.id.to_s + '/temas-y-tareas'
	end
	
	def show
		control = false
		if !Tarea.where(:id => params[:id]).empty?
		@tarea = Tarea.find(params[:id])	
		
		@tarea.grupos.each do |grupo|
			if current_user.esta_subscrito?(grupo.id) && !control
				@grupo = grupo
				control = true
			end
		end
		if(@tarea.tarea_base!=nil)
			@tarea_base = Tarea.find(@tarea.tarea_base)
		end
		@todos_los_comentarios = @tarea.tarea_comentarios.reverse
		if(current_user == @tarea.usuario)
			@tareas_enviadas = ResponderTarea.where(:tarea_id => @tarea.id)
		end
		else
			flash
			redirect_to '/no_existe'
		end

	end
	def edit #id tarea
		if(Tarea.find(params[:id]).usuario==current_user)
		@tarea = Tarea.find(params[:id])
		if(@tarea.tarea_base!=nil)
		@tarea_base=Tarea.find(@tarea.tarea_base)
		end
		@grupos = Array.new
		if(current_user!=nil)
		current_user.subscripcions.each do |subs|
		@grupos.push(subs.grupo)
		end
		@tarea.grupos.each do |grupo|
	      if current_user.esta_subscrito?(grupo.id)
	       		@grupo = grupo
	        break
	      end
	    end
		@id = params[:id]
		end
		else
		flash[:alert] = 'La tarea fue eliminada'
		redirect_to temas_path
		end
	end
	def ver_tareas
		@tareas = Tarea.where(:usuario_id => current_user.id).order("updated_at DESC")
	end
	def update
		@tarea = Tarea.find(params[:id])
		if(@tarea.update(params[:tarea].permit(:titulo,:descripcion,:fecha_entrega,:grupo_id,:hora_entrega)))
		eliminar_archivos_adjuntos(params[:elemsParaElim])
		add_attached_files(@tarea.id)
		redirect_to @tarea
		else
		render 'edit'
		end
	end
	def eliminar_archivos_adjuntos(idsParaBorrar)
		if (!idsParaBorrar.nil?)
		idsParaBorrar.slice!(0)
		idsParaBorrar=idsParaBorrar.split("-")
		idsParaBorrar.each do |id|
		ArchivoAdjunto.destroy(id)
		end
		end
	end
	#POST tareas/create
	def create
		@tarea = Tarea.new(tarea_params)
		@tarea.usuario_id = current_user.id

		if current_user.rol == "Docente"
			@tarea.admitido = true
		else
			@tarea.admitido = false
		end

		if params[:grupos] != nil &&  @tarea.save 
			params[:grupos].each do |grupo|
				Grupo.find(grupo).tareas << @tarea
			end
			@tarea.save
			add_attached_files(@tarea.id)
			if @tarea.admitido = true
          		@tarea.grupos.each do |grupo|
					notificar_por_email(grupo.id, @tarea)
					notificacion_push(grupo.id, @tarea)
				end
        	end

        	if current_user.rol == "Estudiante"            
        		@tarea.grupos.each do |grupo|
					notificar_creacion(grupo.id, @tarea)
				end
        	end		

			flash[:alert] = 'Tarea creada Exitosamente!'
		
          
        		
			redirect_to '/tareas/'+@tarea.id.to_s
		else
			flash[:notice] = "La tarea no pudo ser guardada"
			redirect_to(:back)
		end
	end

	def aprove
    	@tarea = Tarea.find(params[:id])
    	@tarea.admitido = true
    	@tarea.save
    	@tarea.grupos.each do |grupo|
			notificar_por_email(grupo.id, @tarea)
			notificacion_push(grupo.id, @tarea)
    	end
    	redirect_to :back
  	end


	def editar_comentario
		@comentario = TareaComentario.find(params[:id_comentario])
		  @comentario.tarea.grupos.each do |grupo|
	      if current_user.esta_subscrito?(grupo.id)
	        @grupo = grupo
	        break
	      end
	    end
	end
	private
	# No permite parametros de internet
	def tarea_params
		params.require(:tarea).permit(:titulo, :descripcion, :fecha_entrega, :hora_entrega, :admitido)
	end
	def add_attached_files(tarea_id)
		if(!params[:tarea][:archivo].nil?)
		params[:tarea][:archivo].each do |arch|
		@archivo = ArchivoAdjunto.new(:archivo=>arch)
		@archivo.tarea_id = tarea_id
		@archivo.save
		end
		end
	end
	def tarea_respuesta_params
		params.require(:responder_tarea).permit(:descripcion)
	end
	def add_attached_files_respuesta(responder_tarea_id)
		if(!params[:responder_tarea][:archivo].nil?)
		params[:responder_tarea][:archivo].each do |arch|
		@archivo = ArchivoAdjuntoRespuesta.new(:archivo=>arch)
		@archivo.responder_tarea_id = responder_tarea_id
		@archivo.save
		end
		end
	end

	def notificacion_push(id_grupo,tarea)
		suscripciones = Subscripcion.all
		suscripciones.each do |suscrito|
			if suscrito.grupo_id == id_grupo
				if suscrito.usuario_id != current_user.id
					@usuario = suscrito.usuario
					if @usuario.push_task == true
						if @usuario != nil
							@grupo = Grupo.find(id_grupo)
							notificacion = Notification.create('title'=>tarea.titulo, 'description'=>tarea.descripcion, 'reference_date'=> tarea.fecha_entrega,
							'tipo'=>0, 'de_usuario_id'=>current_user.id, 'para_usuario_id'=> @usuario.id, 'seen'=>false, 'id_item'=> tarea.id)
							Pusher.url = "http://673a73008280ca569283:555e099ce1a2bfc840b9@api.pusherapp.com/apps/60344"
							Pusher['notifications_channel'].trigger('notification_event', {
							para_usuario: notificacion.para_usuario_id
							})
						end
					end
				end
			end
		end
	end

	def notificar_por_email(id_grupo,tarea)
		suscripciones = Subscripcion.all
		suscripciones.each do |suscrito|
			if suscrito.grupo_id == id_grupo
				if suscrito.usuario_id != current_user.id
					@usuario = suscrito.usuario
					if @usuario.mailer_task == true
						if @usuario != nil
							@grupo = Grupo.find(id_grupo)
							SendMail.notify_users_task_create(@usuario, tarea, @grupo).deliver
						end
					end
				end
			end
		end
	end

	def notificar_creacion(id_grupo,tarea)
		suscripciones = Subscripcion.all
		suscripciones.each do |suscrito|
			if suscrito.grupo_id == id_grupo
				if suscrito.usuario_id != current_user.id
					@usuario = suscrito.usuario
					if @usuario.mailer_task == true
						if @usuario != nil
							@grupo = Grupo.find(id_grupo)
							SendMail.notify_task_creation(@usuario, tarea, @grupo).deliver
						end
					end
				end
			end
		end
	end

end