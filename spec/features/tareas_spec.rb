require 'spec_helper'

feature 'Gestion de tareas' do
  #TODO: Llevar este método a un spec_helper para que sea usado por todos los feature specs
  #TODO: Usar el parametro usuario en este método
  before(:all) do
     @grupo_publico = FactoryGirl.create(:grupo_publico)
  end

  scenario 'Crear una tarea' do
     usuario = FactoryGirl.create(:usuario)
     grupo = FactoryGirl.create(:grupo, usuario_id: usuario.id)
     subscripcion = FactoryGirl.create(:subscripcion, llave: "qwerty", usuario_id: usuario.id, grupo_id: grupo.id)
     ingresar_sistema(usuario)
     visit "/grupos/"+grupo.id.to_s+"/tareas"
     click_link 'Nueva Tarea'
     fill_in 'tarea_titulo', with: 'Titulo tarea de prueba'
     fill_in 'tarea_descripcion', with: 'Descripcion o contenido de tarea de prueba'
     fill_in 'tarea_fecha_entrega', with: '12/12/2013'
     fill_in 'tarea_hora_entrega', with: '05:00 PM'
     click_button 'Crear tarea'
     expect(page).to have_content 'Titulo tarea de prueba'
     expect(page).to have_content 'Descripcion o contenido de tarea de prueba'
   end

   scenario 'Ver detalle de una tarea' do
     usuario = FactoryGirl.create(:usuario)
     grupo = FactoryGirl.create(:grupo, usuario_id: usuario.id)
     subscripcion = FactoryGirl.create(:subscripcion, llave: "qwerty", usuario_id: usuario.id, grupo_id: grupo.id)
     tarea = FactoryGirl.create(:tarea, usuario_id: usuario.id, grupo_id: grupo.id)
     ingresar_sistema(usuario)
     visit "/tareas/"+tarea.id.to_s
     expect(page).to have_content 'pedrito' #deberia tener, el username del que creador de la tarea
     expect(page).to have_content 'Tarea de Prueba' #deberia tener, el titulo de la tarea
     expect(page).to have_content 'Una tarea de prueba no muy larga para que no se resuma' #deberia tener, la descripcion
     expect(page).to have_content '13/Oct/2013' #deberia tener, la fecha de entrega
     expect(page).to have_content '10:00 PM' #deberia tener, la hora de entrega
  end

  scenario 'Eliminar una tarea' do
     usuario = FactoryGirl.create(:usuario)
     grupo = FactoryGirl.create(:grupo, usuario_id: usuario.id)
     subscripcion = FactoryGirl.create(:subscripcion, llave: "qwerty", usuario_id: usuario.id, grupo_id: grupo.id)
     tarea = FactoryGirl.create(:tarea, usuario_id: usuario.id, grupo_id: grupo.id)
     ingresar_sistema(usuario)
     visit "/tareas/"+tarea.id.to_s
     click_link 'Eliminar'
     #click_button 'Aceptar'
     expect(page).to have_content 'Tarea eliminada' #deberia tener, la hora de entrega
   end
 
  # scenario 'Ver index de tareas de un grupo' do
  #   usuario = FactoryGirl.create(:usuario)
  #   publico = FactoryGirl.create(:grupo)
  #   grupo = FactoryGirl.create(:grupo, nombre: 'Prueba', usuario_id: usuario.id)
  #   tarea1 = FactoryGirl.create(:tarea, titulo: 'Tarea 1', grupo_id: "2", fecha_entrega: "2013-10-13", hora_entrega: "00:00 AM")
  #   tarea2 = FactoryGirl.create(:tarea, titulo: 'Tarea 2', grupo_id: "2", fecha_entrega: "2013-10-13", hora_entrega: "00:00 AM")
  #   ingresar_sistema(usuario)
  #   visit "/grupos/2/tareas"
  #   #expect(current_path).to eq "/grupos/2/tareas"  #no muy util aqui, pero sirve para mostrar esta opcion
  #   expect(page).to have_content 'Tarea 1'
  #   expect(page).to have_content 'Tarea 2'
  # end

end