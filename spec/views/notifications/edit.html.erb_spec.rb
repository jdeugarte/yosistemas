require 'spec_helper'

describe "notifications/edit" do
  before(:each) do
    @notification = assign(:notification, stub_model(Notification,
      :title => "MyString",
      :description => "MyString",
      :tipo => 1,
      :seen => false,
      :de_usuario_id => 1,
      :para_usuario_id => 1
    ))
  end

  it "renders the edit notification form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", notification_path(@notification), "post" do
      assert_select "input#notification_title[name=?]", "notification[title]"
      assert_select "input#notification_description[name=?]", "notification[description]"
      assert_select "input#notification_tipo[name=?]", "notification[tipo]"
      assert_select "input#notification_seen[name=?]", "notification[seen]"
      assert_select "input#notification_de_usuario_id[name=?]", "notification[de_usuario_id]"
      assert_select "input#notification_para_usuario_id[name=?]", "notification[para_usuario_id]"
    end
  end
end
