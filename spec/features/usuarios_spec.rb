require 'spec_helper'

feature 'Gestion de usuarios' do
  def ingresar_sistema(usuario)
    visit root_path
    #click_link "Ingresar"  
    fill_in 'correo', with: 'email@email.com'
    fill_in 'contrasenia', with: 'password'
    click_button 'Ingresar'
  end

  scenario 'modificar un usuario' do
    usuario = FactoryGirl.create(:usuario)
    ingresar_sistema(usuario)
    click_link 'Modificar Perfil' # entra al link de modificar perfil
      fill_in 'usuario_nombre', with: 'otro' #el texto se llena con 
      fill_in 'usuario_apellido', with: 'otroapellido'
      click_button 'Guardar'
      Usuario.first.nombre == 'otro'  #no muy util aqui, pero saber si cambio el nombre de usuario
      Usuario.first.apellido == 'otroapellido'
  end
  
  
  
end
