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
  
  scenario 'modificar un contrasenia' do
    usuario = FactoryGirl.create(:usuario)
    ingresar_sistema(usuario)
    #click_link 'Modificar Contrasea' # entra al link de modificar perfil
    visit update_password_path
      fill_in 'contrasenia', with: 'anterior' #el texto se llena con 
      fill_in 'contrasenia_nueva', with: 'nueva'
      fill_in 'contrasenia_nueva2', with: 'nueva'
      click_button 'Guardar'
      Usuario.first.contrasenia == Digest::MD5.hexdigest('nueva')  
  end
  
end
