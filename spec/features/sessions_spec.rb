require 'spec_helper'

feature 'Gestion de Sessions' do
  scenario 'Log in de un usuario' do    
    usuario = FactoryGirl.build(:usuario)  
    #visit '/sessions/new'
    visit root_path
    fill_in 'correo', with: 'email@email.com'
    fill_in 'contrasenia', with: 'password'
    click_button 'Ingresar'
    #expect(page).to have_text("Logged in!")
    #expect(current_path).to eq temas_path
  end
end
