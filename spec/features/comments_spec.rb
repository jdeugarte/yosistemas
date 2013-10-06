require 'spec_helper'

feature 'Comentario' do
  def ingresar_sistema(usuario)
    visit root_path
    click_link "Ingresar"  
    fill_in 'correo', with: 'email@email.com'
    fill_in 'contrasenia', with: 'password'
    click_button 'Ingresar'
  end
  scenario 'Comentar tema' do
    #crear usuario que pueda crear una entrada (cuando se tenga usuarios)
    usuario = FactoryGirl.create(:usuario)
    ingresar_sistema(usuario)
    click_link 'Nuevo Tema'
    expect{
      fill_in 'tema_titulo', with: 'Titulo tema de prueba'
      fill_in 'tema_cuerpo', with: 'Descripcion o contenido del tema de prueba'
      click_button 'Crear tema'
    }.to change(Tema, :count).by(1)
    expect(current_path).to eq temas_path  #secion lista de temas
    visit "temas/"+Tema.first.id.to_s #voy al tema (esta parte necesita ser refactorizada)
    expect{
      fill_in 'comment_body', with: 'contenido del comentario'
      click_button 'Comentar'
    }.to change(Comment, :count).by(1)
    expect(page).to have_content 'contenido del comentario' 
  end
end