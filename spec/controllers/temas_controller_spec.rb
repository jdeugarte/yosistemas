require 'spec_helper'

describe TemasController do
  before(:each) do
    controller.class.skip_before_filter :require_log_in #para evitar este filtro de application_controller
  end

  #ATENCION: El uso de factory girl ayuda a hacer los specs m'as simples. Sin embargo, tambi'en m'as lentos ya 
  # que acceden a la BD en lugar de mocks o stubs
  describe 'GET #index' do
    it "obtiene todos los temas en un arreglo" do  
      tema1 = FactoryGirl.create(:tema, titulo: 'Tema 1')
      tema2 = FactoryGirl.create(:tema, titulo: 'Tema 2')
      
      get :index
      
      expect(assigns(:temas)).to match_array([tema1, tema2])
    end

    it "muestra la vista index" do
      get :index
      
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    it "asigna un nuevo tema a @tema" do
      get :new

      expect(assigns(:tema)).to be_a_new(Tema)
    end

    it "muestra la vista new" do
      get :new

      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'con atributos validos' do
      it "guarda en la bd el nuevo tema" do
        expect{ 
          post :create, tema: FactoryGirl.attributes_for(:tema)
        }.to change(Tema, :count).by(1)
      end

      it "redirecciona a vista index" do
        post :create, tema: FactoryGirl.attributes_for(:tema)   
        expect(response).to redirect_to temas_path  
      end
    end
  end
end
