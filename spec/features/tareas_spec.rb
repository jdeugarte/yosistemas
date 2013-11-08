require 'spec_helper'

feature 'Gestion de tareas' do
  #TODO: Llevar este método a un spec_helper para que sea usado por todos los feature specs
  #TODO: Usar el parametro usuario en este método
  # def ingresar_sistema(usuario)
  #   visit root_path
  #   #click_link "Ingresar"
  #   fill_in 'correo', with: 'email@email.com'
  #   fill_in 'contrasenia', with: 'password'
  #   click_button 'Ingresar'
  # end
 
  # scenario 'Ver index de tareas de un grupo' do
  #   usuario = FactoryGirl.create(:usuario)
  #   publico = FactoryGirl.create(:grupo)
  #   grupo = FactoryGirl.build(:grupo, nombre: 'Prueba', usuario_id: usuario.id)
  #   tarea1 = FactoryGirl.create(:tarea, titulo: 'Tarea 1', grupo_id: "2", fecha_entrega: "2013-10-13", hora_entrega: "00:00 AM")
  #   tarea2 = FactoryGirl.create(:tarea, titulo: 'Tarea 2', grupo_id: "2", fecha_entrega: "2013-10-13", hora_entrega: "00:00 AM")
  #   ingresar_sistema(usuario)
  #   visit "/grupos/2/tareas"
  #   #expect(current_path).to eq "/grupos/2/tareas"  #no muy util aqui, pero sirve para mostrar esta opcion
  #   expect(page).to have_content 'Tarea 1'
  #   expect(page).to have_content 'Tarea 2'
  # end

end