require 'spec_helper'

feature 'Gestion de SuscripcionTemas' do

	def ingresar_sistema(usuario)
	    visit root_path
	    fill_in 'correo', with: 'email@email.com'
	    fill_in 'contrasenia', with: 'password'
	    click_button 'Ingresar'
 	end

	scenario 'suscribirse a un tema al crearlo' do
		grupo = FactoryGirl.create(:grupo)
	    usuario = FactoryGirl.create(:usuario)
	    ingresar_sistema(usuario)
	    click_link 'Nuevo Tema'
	    expect{
	      fill_in 'tema_titulo', with: 'Titulo tema de prueba'
	      fill_in 'tema_cuerpo', with: 'Descripcion o contenido del tema de prueba'
	      click_button 'Crear tema'
	    }.to change(Tema, :count).by(1)
	    visit "temas/"+Tema.first.id.to_s
	    expect(page).to have_content 'Ya no me Interesa'
  	end

  	scenario 'quitar suscripcion a un tema' do
  		grupo = FactoryGirl.create(:grupo)
	    usuario = FactoryGirl.create(:usuario)
	    ingresar_sistema(usuario)
	    click_link 'Nuevo Tema'
	    expect{
	      fill_in 'tema_titulo', with: 'Titulo tema de prueba'
	      fill_in 'tema_cuerpo', with: 'Descripcion o contenido del tema de prueba'
	      click_button 'Crear tema'
	    }.to change(Tema, :count).by(1)
	    visit "temas/"+Tema.first.id.to_s
	    expect(page).to have_content 'Ya no me Interesa'
	    click_link 'Ya no me Interesa'
	    expect(page).to have_content 'Me Interesa'
  	end
end
