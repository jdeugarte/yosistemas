require 'spec_helper'

feature 'Comentario' do
=begin
  scenario 'Comentar tema' do
    #crear usuario que pueda crear una entrada (cuando se tenga usuarios)
    usuario = FactoryGirl.create(:usuario)
    #ir a la ventana principal para iniciar la interaccion como lo haria el usuario)
    visit root_path  
    #si es necesario hacer un login, hacerlo (claro que podemos tener esto en un metodo en un helper, para no repetir en otros specs)
    fill_in 'correo', with: 'email@email.com'
    fill_in 'contrasenia', with: 'password'
    click_button 'Log in'
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
    expect{
      fill_in 'comment_body', with: 'contenido del comentario'
      click_button 'Submit'
    }.to change(, :count).by(1)
    expect(current_path).to eq Tema #lista de temas
    expect(page).to have_content 'Titulo tema de prueba'
    expect(page).to have_content 'Descripcion o contenido del tema de prueba'
    expect(page).to have_content 'contenido del comentario'
    #save_and_open_page #habilitar en cualquier lugar SOLO si se quiere hacer debug de este spec
  end
=end
end