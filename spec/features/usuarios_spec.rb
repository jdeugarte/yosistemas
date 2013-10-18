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
      fill_in 'contrasenia', with: 'password' #el texto se llena con 
      fill_in 'contrasenia_nueva', with: 'nueva'
      fill_in 'contrasenia_nueva2', with: 'nueva'
      click_button 'Guardar'
      Usuario.first.contrasenia == Digest::MD5.hexdigest('nueva')  
  end

  scenario 'recuperar mi contrasenia' do
    usuario = FactoryGirl.create(:usuario)
    request=FactoryGirl.create(:passwords_request)
    usuario.passwords_request_id=request.id
    request.usuario=usuario
    usuario.save
    request.save
    visit recover_path(request.id)
      fill_in 'contrasenia_nueva', with: 'nuevoPass'
      fill_in 'contrasenia_nueva2', with: 'nuevoPass'
      click_button 'Confirmar'
     expect(current_path).to eq root_path
  end

  scenario 'recuperar mi contrasenia, solicitud expiro' do
    usuario = FactoryGirl.create(:usuario)
    request=FactoryGirl.create(:passwords_request)
    request2=FactoryGirl.create(:passwords_request)
    usuario.passwords_request_id=request2.id
    request.usuario=usuario
    request2.usuario=usuario
    usuario.save
    request.save
    visit recover_path(request.id)
    expect(page).to have_content 'esta solicitud expiro, por favor solicite otra'
  end

  scenario 'recuperar mi contrasenia, imposible procesar solicitud' do
     usuario = FactoryGirl.create(:usuario)
    request=FactoryGirl.create(:passwords_request)
    usuario.passwords_request_id=request.id
    request.usuario=usuario
    usuario.save
    request.save
    visit recover_path("imposible")
    expect(page).to have_content 'no podemos procesar esta solicitud, por favor solicite otra'
  end

  
end
