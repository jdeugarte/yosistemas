require 'spec_helper'

feature 'Gestion de tema' do
  def ingresar_sistema(usuario)
    visit root_path
    #click_link "Ingresar"  
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
    click_link 'Dejar de mostrar tema' # ya no quiero ver el tema
    expect(current_path).to eq temas_path #lista de temas
    expect(page).to have_content '' #no tengo contenido en la pagina
    expect(page).to have_content ''
  end

  scenario 'Ver mis temas' do
    usuario = FactoryGirl.create(:usuario)

    #Tarea para uds. refactorizar esta sección a un método ingresar_sistema(usuario)
    #para no repetir esto en todos los demás feature specs que necesiten autentificarse
    ingresar_sistema(usuario)
    click_link 'Nuevo Tema'
    
    #creamos un tema para el usuario1
    fill_in 'tema_titulo', with: 'Titulo tema de prueba'
    fill_in 'tema_cuerpo', with: 'Descripcion o contenido del tema de prueba'
    click_button 'Crear tema'

    click_link usuario.correo
    click_link 'Salir'

    usuario2 = FactoryGirl.create(:other_user)

    #Ingresamos al sistema con otro usuario
    visit root_path 
    fill_in 'correo', with: 'email2@email.com'
    fill_in 'contrasenia', with: 'password2'
    click_button 'Ingresar'
    
    #al entrar a 'Mis temas' no debería ver los temas creados por el primer usuario
    click_link 'Temas'
    click_link 'Mis Temas'
    
    expect(page).to have_no_content 'Titulo tema de prueba'
    expect(page).to have_no_content 'Descripcion o contenido del tema de prueba'
    
  end
  scenario 'Ver tema' do
    usuario=FactoryGirl.create(:usuario)
    
    ingresar_sistema(usuario)
    click_link 'Nuevo Tema'
    fill_in 'tema_titulo', with: 'Titulo tema de prueba'
    fill_in 'tema_cuerpo', with: 'Descripcion o contenido del tema de prueba'
    click_button 'Crear tema'

    click_link usuario.correo
    click_link 'Salir'

    usuario2=FactoryGirl.create(:usuario)

    visit root_path
    fill_in 'correo', with: 'email2@email.com'
    fill_in 'contrasenia', with: 'password2'
    click_button 'Ingresar'

    click_link 'Temas'
    click_link 'Ver Temas'
    #al ingresar a Ver Temas debe poder ver los temas creados por otros usuarios
    expect(page).to have_content 'Titulo tema de prueba'
    expect(page).to have_content 'Descripcion o contenido del tema de prueba'
  end


end

feature 'Buscar temas' do

  def ingresar_sistema(usuario)
    visit root_path
    #click_link "Ingresar"  
    fill_in 'correo', with: 'email@email.com'
    fill_in 'contrasenia', with: 'password'
    click_button 'Ingresar'
  end

    scenario 'la busqueda por descripcion deberia mostrar resultados coherentes' do
        grupo = FactoryGirl.create(:grupo)
        usuario = FactoryGirl.create(:usuario,nombre: "Pedro",apellido: "Suarez", contrasenia: "password", contrasenia_de_confirmacion: "password", correo:"email@email.com" )
        tema1 = FactoryGirl.create(:tema, titulo: 'Tema 1', cuerpo: 'primera descripcion')
        tema2 = FactoryGirl.create(:tema, titulo: 'Tema 2', cuerpo: 'descripcion segunda')
        ingresar_sistema(usuario)
        fill_in 'descripcion', with: 'primera'
        click_button 'Buscar Tema'
        expect(page).to have_content('Tema 1')
    end
end
