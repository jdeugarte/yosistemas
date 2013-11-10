require 'spec_helper'

feature 'Comentario' do
  
  scenario 'Comentar tema' do
    #crear usuario que pueda crear una entrada (cuando se tenga usuarios)
    grupo = FactoryGirl.create(:grupo)
    usuario = FactoryGirl.create(:usuario)
    tema=FactoryGirl.create(:tema)
    ingresar_sistema(usuario)
    visit "temas/"+tema.id.to_s #voy al tema (esta parte necesita ser refactorizada)
    expect{
      fill_in 'tema_comentario_cuerpo', with: 'contenido del comentario'
      click_button 'Comentar'
    }.to change(TemaComentario, :count).by(1)
    expect(page).to have_content 'contenido del comentario' 
  end
end