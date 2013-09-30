require 'spec_helper'

feature 'Gestion de tema' do
  scenario 'Crear un nuevo tema' do
    #crear usuario que pueda crear una entrada (cuando se tenga usuarios)
    usuario = FactoryGirl.create(:usuario)
    #ir a la ventana principal para iniciar la interaccion como lo haria el usuario)
    visit "/log_in"  
    #si es necesario hacer un login, hacerlo (claro que podemos tener esto en un metodo en un helper, para no repetir en otros specs)
    fill_in 'correo', with: 'email@email.com'
    fill_in 'contrasenia', with: 'password'
    click_button 'Ingresar'
    #ahora si vamos a la seccion de temas
    visit temas_path  # para mas info ver: guides.rubyonrails.org/routing.html
    click_link 'Nuevo Tema'
    expect{
      fill_in 'tema_titulo', with: 'Titulo tema de prueba'
      fill_in 'tema_cuerpo', with: 'Descripcion o contenido del tema de prueba'
      click_button 'Crear tema'
    }.to change(Tema, :count).by(1)
    expect(current_path).to eq temas_path  #no muy util aqui, pero sirve para mostrar esta opcion
    expect(page).to have_content 'Titulo tema de prueba'
    expect(page).to have_content 'Descripcion o contenido del tema de prueba'
    #save_and_open_page #habilitar en cualquier lugar SOLO si se quiere hacer debug de este spec
      
  end
  scenario 'solo usuario que creo el tema puede esconder(eliminar) tema' do
    #crear usuario que pueda crear una entrada (cuando se tenga usuarios)
    usuario = FactoryGirl.create(:usuario)
    #ir a la ventana principal para iniciar la interaccion como lo haria el usuario)
    visit "/log_in"  
    #si es necesario hacer un login, hacerlo (claro que podemos tener esto en un metodo en un helper, para no repetir en otros specs)
    fill_in 'correo', with: 'email@email.com'
    fill_in 'contrasenia', with: 'password'
    click_button 'Ingresar'
    #ahora si vamos a la seccion de temas
    visit temas_path  # para mas info ver: guides.rubyonrails.org/routing.html
    click_link 'Nuevo Tema'
    expect{
      fill_in 'tema_titulo', with: 'Titulo tema de prueba'
      fill_in 'tema_cuerpo', with: 'Descripcion o contenido del tema de prueba'
      click_button 'Crear tema'
    }.to change(Tema, :count).by(1)
    expect(current_path).to eq temas_path  #secion lista de temas
    click_link 'Show' #voy al tema
    click_link 'visible' # ya no quiero ver el tema
    expect(current_path).to eq temas_path #lista de temas
    expect(page).to have_content '' #no tengo contenido en la pagina
    expect(page).to have_content ''
    #save_and_open_page #habilitar en cualquier lugar SOLO si se quiere hacer debug de este spec
      
  end

  scenario 'usuario que no creo el tema no puede esconderlo' do
    #crear usuario que pueda crear una entrada (cuando se tenga usuarios)
    usuario = FactoryGirl.create(:usuario)
    usuario2 = FactoryGirl.create(:usuario,nombre: "Pablo",apellido: "Marmol", contrasenia: "password", contrasenia_de_confirmacion: "password", correo:"email2@email.com" )
    #ir a la ventana principal para iniciar la interaccion como lo haria el usuario)
    visit "/log_in"    
    #si es necesario hacer un login, hacerlo (claro que podemos tener esto en un metodo en un helper, para no repetir en otros specs)
    fill_in 'correo', with: 'email@email.com'
    fill_in 'contrasenia', with: 'password'
    click_button 'Ingresar'
    #ahora si vamos a la seccion de temas
    visit temas_path  # para mas info ver: guides.rubyonrails.org/routing.html
    click_link 'Nuevo Tema'
    expect{
      fill_in 'tema_titulo', with: 'Titulo tema de prueba'
      fill_in 'tema_cuerpo', with: 'Descripcion o contenido del tema de prueba'
      click_button 'Crear tema'
    }.to change(Tema, :count).by(1)
    expect(current_path).to eq temas_path  #secion lista de temas
    click_link 'Show' #voy al tema
    expect(page).to have_content 'visible' #Se puede ver el link visible
    click_link 'Salir' #cierro sesion
    #login con otro usuario registrado
    fill_in 'correo', with: 'email2@email.com'
    fill_in 'contrasenia', with: 'password'
    click_button 'Ingresar'
    click_link 'Show' #voy al tema
    has_no_text?('visible')==true #No Se puede ver el link visible
    #save_and_open_page #habilitar en cualquier lugar SOLO si se quiere hacer debug de este spec
      
  end
end

# feature 'Buscar temas' do
#     scenario 'la busqueda por descripcion deberia mostrar resultados coherentes' do
#         usuario = FactoryGirl.create(:usuario,nombre: "Pedro",apellido: "Suarez", contrasenia: "password", contrasenia_de_confirmacion: "password", correo:"email@email.com" )
#         tema1 = FactoryGirl.create(:tema, titulo: 'Tema 1', cuerpo: 'primera descripcion')
#         tema2 = FactoryGirl.create(:tema, titulo: 'Tema 2', cuerpo: 'descripcion segunda')
#         #ir a la ventana principal para iniciar la interaccion como lo haria el usuario)
#         visit "/log_in"    
#         #si es necesario hacer un login, hacerlo (claro que podemos tener esto en un metodo en un helper, para no repetir en otros specs)
#         fill_in 'correo', with: 'email@email.com'
#         fill_in 'contrasenia', with: 'password'
#         click_button 'Ingresar'
#         fill_in 'descripcion', with: 'primera'
#         click_button 'Buscar Tema'
#         expect(page).to have_content('Tema 1')
#     end
# end