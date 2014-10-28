require 'spec_helper'

describe "notifications/new" do
  before(:each) do
    assign(:notification, stub_model(Notification,
      :title => "MyString",
      :description => "MyString",
      :tipo => 1,
      :seen => false,
      :de_usuario_id => 1,
      :para_usuario_id => 1
    ).as_new_record)
  end

  it "renders new notification form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", notifications_path, "post" do
      assert_select "input#notification_title[name=?]", "notification[title]"
      assert_select "input#notification_description[name=?]", "notification[description]"
      assert_select "input#notification_tipo[name=?]", "notification[tipo]"
      assert_select "input#notification_seen[name=?]", "notification[seen]"
      assert_select "input#notification_de_usuario_id[name=?]", "notification[de_usuario_id]"
      assert_select "input#notification_para_usuario_id[name=?]", "notification[para_usuario_id]"
    end
  end
end
