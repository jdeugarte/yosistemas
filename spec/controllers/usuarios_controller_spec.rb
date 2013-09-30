require 'spec_helper'

describe UsuariosController do
  before(:each) do
    #controller.class.skip_before_filter :require_log_in #para evitar este filtro de application_controller
  end
  
 describe "GET edit" do
    before :each do
      @usuario = FactoryGirl.create(:usuario, Nombre)
    end

    context "atributos validos" do
      it "asignar los valores encontrados a @tema" do
        get :edit, id: @usuario, tema:FactoryGirl.attributes_for(:tema)
        assigns(:usuario).should eq(@tema)
      end

      it "cambiar atributos de @tema" do
        put :update, id:@tema, tema: FactoryGirl.attributes_for(:tema, titulo:'Titulo nuevo', cuerpo:'Cuerpo nuevo')
        @tema.reload
        @tema.titulo.should eq('Titulo nuevo')
        @tema.cuerpo.should eq('Cuerpo nuevo')
      end
      
      it "redireccionar al tema actualizado" do
        put :update, id:@tema, tema: FactoryGirl.attributes_for(:tema)
        response.should redirect_to @tema
      end
    end
end 