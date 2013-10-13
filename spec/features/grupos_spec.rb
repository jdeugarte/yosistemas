require 'spec_helper'

feature 'Gestion de Grupo' do
  def ingresar_sistema(usuario)
    visit root_path
    #click_link "Ingresar"  
    fill_in 'correo', with: 'email@email.com'
    fill_in 'contrasenia', with: 'password'
    click_button 'Ingresar'
  end

  scenario 'Crear un nuevo grupo privado' do
    usuario = FactoryGirl.create(:usuario)

    ingresar_sistema(usuario)
    click_link 'Crear Grupo'  #lleva al formulario para crear un grupo
    
    expect{
      fill_in 'grupo_nombre', with: 'Titulo tema de prueba'
      fill_in 'grupo_descripcion', with: 'Descripcion o contenido del tema de prueba'
      page.select("Privado", :from => "grupo_estado")
      click_button 'Crear grupo'
    }.to change(Grupo, :count).by(1)
    expect(current_path).to eq "/grupos/1"  #no muy util aqui, pero sirve para mostrar esta opcion
    
  end

  scenario 'Crear un nuevo grupo publico' do
    usuario = FactoryGirl.create(:usuario)

    ingresar_sistema(usuario)
    click_link 'Crear Grupo'  #lleva al formulario para crear un grupo
    
    expect{
      fill_in 'grupo_nombre', with: 'Titulo tema de prueba'
      fill_in 'grupo_descripcion', with: 'Descripcion o contenido del tema de prueba'
      page.select("Publico", :from => "grupo_estado")
      click_button 'Crear grupo'
    }.to change(Grupo, :count).by(1)
    expect(current_path).to eq "/grupos/1"  #no muy util aqui, pero sirve para mostrar esta opcion
    
  end

end
