require File.dirname(__FILE__) + '/../test_helper'

class NagiosServicesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:nagios_services)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_nagios_service
    assert_difference('NagiosService.count') do
      post :create, :nagios_service => { }
    end

    assert_redirected_to nagios_service_path(assigns(:nagios_service))
  end

  def test_should_show_nagios_service
    get :show, :id => nagios_services(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => nagios_services(:one).id
    assert_response :success
  end

  def test_should_update_nagios_service
    put :update, :id => nagios_services(:one).id, :nagios_service => { }
    assert_redirected_to nagios_service_path(assigns(:nagios_service))
  end

  def test_should_destroy_nagios_service
    assert_difference('NagiosService.count', -1) do
      delete :destroy, :id => nagios_services(:one).id
    end

    assert_redirected_to nagios_services_path
  end
end
