require 'spec_helper'

describe CommentsController do
  before(:each) do
    controller.class.skip_before_filter :require_log_in #para evitar este filtro de application_controller
  end

  describe 'Crear Comentario' do
      it "guarda en la base de datos el nuevo comentario" do
        expect{
          tema1 = FactoryGirl.create(:tema, titulo: 'Tema Comentado')
		  comment = FactoryGirl.create(:comment, body: "probando", tema_id: tema1.id)
          #post :create, comment: FactoryGirl.attributes_for(:comment, tema_id: tema1.id)
        }.to change(Comment, :count).by(1)
      end
  end
end