require File.dirname(__FILE__) + '/../test_helper'

class NagiosServiceTemplatesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:nagios_service_templates)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_nagios_service_template
    assert_difference('NagiosServiceTemplate.count') do
      post :create, :nagios_service_template => { }
    end

    assert_redirected_to nagios_service_template_path(assigns(:nagios_service_template))
  end

  def test_should_show_nagios_service_template
    get :show, :id => nagios_service_templates(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => nagios_service_templates(:one).id
    assert_response :success
  end

  def test_should_update_nagios_service_template
    put :update, :id => nagios_service_templates(:one).id, :nagios_service_template => { }
    assert_redirected_to nagios_service_template_path(assigns(:nagios_service_template))
  end

  def test_should_destroy_nagios_service_template
    assert_difference('NagiosServiceTemplate.count', -1) do
      delete :destroy, :id => nagios_service_templates(:one).id
    end

    assert_redirected_to nagios_service_templates_path
  end
end
