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
    	tema = FactoryGirl.create(:tema)
    	suscribirse = FactoryGirl.create(:suscripcion_tema)
    	ingresar_sistema(usuario)
    	visit "temas/1"  #usar el id, titulo del tema con creado con factory girl
    	#save_and_open_page
    	#Capybara::Screenshot.screenshot_and_open_image
	    expect(page).to have_content 'Ya no me Interesa'
  	end

  	scenario 'quitar suscripcion a un tema' do
  		grupo = FactoryGirl.create(:grupo)
	    usuario = FactoryGirl.create(:usuario)
	    ingresar_sistema(usuario)
	    tema=FactoryGirl.create(:tema)
	    #suscripcion=FactoryGirl.create(:suscripcion_otro_tema)
	    #visit "temas/"+tema.id.to_s
	    #expect(page).to have_content 'Ya no me Interesa'
	    #click_link 'Ya no me Interesa'
	    #expect(page).to have_content 'Me Interesa'
  	end
end
