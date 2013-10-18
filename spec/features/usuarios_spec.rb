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
<<<<<<< HEAD

=======
>>>>>>> 90e93bee687aea736b3baddde7b8631a8d8cfae3
  scenario 'Ver perfil de usuario' do
    usuario=FactoryGirl.create(:usuario)
    ingresar_sistema(usuario)
    click_link 'Ver Perfil'
    expect(current_path).to eq ("/usuarios/"+usuario.id.to_s)
    expect(page).to have_field("usuario_nombre", :with=>"Pedro", :disabled => true) 
    expect(page).to have_field("usuario_apellido", :with=>"Pedregal", :disabled => true)
    expect(page).to have_field("usuario_correo", :with=>"email2@email.com", :disabled => true)
  end
<<<<<<< HEAD

  scenario 'recuperar mi contrasenia, no puede recuperar si esta loggeado' do
     usuario = FactoryGirl.create(:usuario)
    request=FactoryGirl.create(:passwords_request)
    usuario.passwords_request_id=request.id
    request.usuario=usuario
    usuario.save
    request.save
    ingresar_sistema(usuario)
    visit recover_path(request.id)
    expect(page).to have_content 'no puede recuperar su password si esta loggeado'
  end
  scenario 'Activar cuenta' do
     usuario = FactoryGirl.create(:other_diferent_user)
    visit confirm_path(usuario.id)
    expect(page).to have_content 'Su cuenta fue activada exitosamente! ya puede hacer uso de nuestro contenido'
  end

  scenario 'Activar cuenta, no puede activar si esta loggeado' do
    usuario = FactoryGirl.create(:usuario)
    ingresar_sistema(usuario)
    visit confirm_path(usuario.id)
    expect(page).to have_content "No puede activar su cuenta si esta loggeado"
    end


  scenario 'Activar cuenta, usuario incorrecto' do
    visit confirm_path("imposible")
    expect(page).to have_content 'Error, datos invalidos'
    end
    scenario 'No deberia poder acceder a forgot password loggeado' do
     usuario = FactoryGirl.create(:usuario)
     ingresar_sistema(usuario)
     visit forgot_password_path
     expect(current_path).to eq root_path

    end
=======
>>>>>>> 90e93bee687aea736b3baddde7b8631a8d8cfae3
  
end
