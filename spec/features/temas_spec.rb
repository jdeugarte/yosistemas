require 'spec_helper'

feature 'Gestion de tema' do
  scenario 'Crear un nuevo tema' do
    #crear usuario que pueda crear una entrada (cuando se tenga usuarios)
    #visit_root_path  (ir a la ventana principal para iniciar la interaccion como lo haria el usuario)
    #si es necesario hacer un login, hacerlo (claro que podemos tener esto en un metodo en un helper, para no repetir)
    #por hora iremos directamente al root de temas:
    visit temas_path  # para mas info ver: guides.rubyonrails.org/routing.html
    click_link 'Nuevo Tema'
    expect{
      fill_in 'tema_titulo', with: 'Titulo tema de prueba'
      fill_in 'tema_cuerpo', with: 'Descripcion o contenido del tema de prueba'
      click_button 'Create Tema'
    }.to change(Tema, :count).by(1)
    expect(current_path).to eq temas_path  #no muy util aqui, pero sirve para mostrar esta opcion
    expect(page).to have_content 'Titulo tema de prueba'
    expect(page).to have_content 'Descripcion o contenido del tema de prueba'
    #save_and_open_page #habilitar en cualquier lugar SOLO si se quiere hacer debug de este spec
      
  end
end
