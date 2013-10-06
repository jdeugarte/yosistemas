require 'spec_helper'

feature 'Gestion de tema' do
  def ingresar_sistema(usuario)
    visit root_path
    click_link "Ingresar"  
    fill_in 'correo', with: 'email@email.com'
    fill_in 'contrasenia', with: 'password'
    click_button 'Ingresar'
  end

  scenario 'Crear un nuevo tema' do
    usuario = FactoryGirl.create(:usuario)

    #Tarea para uds. refactorizar esta sección a un método ingresar_sistema(usuario)
    #para no repetir esto en todos los demás feature specs que necesiten autentificarse
    ingresar_sistema(usuario)
    click_link 'Nuevo Tema'
    
    expect{
      fill_in 'tema_titulo', with: 'Titulo tema de prueba'
      fill_in 'tema_cuerpo', with: 'Descripcion o contenido del tema de prueba'
      click_button 'Crear tema'
    }.to change(Tema, :count).by(1)
    expect(current_path).to eq temas_path  #no muy util aqui, pero sirve para mostrar esta opcion
    expect(page).to have_content 'Titulo tema de prueba'
    expect(page).to have_content 'Descripcion o contenido del tema de prueba'
  end

   scenario 'Eliminar(dejar de mostrar) un tema' do
    usuario = FactoryGirl.create(:usuario)

    #Tarea para uds. refactorizar esta sección a un método ingresar_sistema(usuario)
    #para no repetir esto en todos los demás feature specs que necesiten autentificarse
    ingresar_sistema(usuario)
    click_link 'Nuevo Tema'
    
    expect{
      fill_in 'tema_titulo', with: 'Titulo tema de prueba'
      fill_in 'tema_cuerpo', with: 'Descripcion o contenido del tema de prueba'
      click_button 'Crear tema'
    }.to change(Tema, :count).by(1)
    expect(current_path).to eq temas_path  #no muy util aqui, pero sirve para mostrar esta opcion
    expect(page).to have_content 'Titulo tema de prueba'
    expect(page).to have_content 'Descripcion o contenido del tema de prueba'
    visit "temas/"+Tema.first.id.to_s
    click_link 'visible' # ya no quiero ver el tema
    expect(current_path).to eq temas_path #lista de temas
    expect(page).to have_content '' #no tengo contenido en la pagina
    expect(page).to have_content ''
  end


end
