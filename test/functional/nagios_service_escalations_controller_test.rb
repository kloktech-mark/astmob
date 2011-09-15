require File.dirname(__FILE__) + '/../test_helper'

class NagiosServiceEscalationsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:nagios_service_escalations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_nagios_service_escalation
    assert_difference('NagiosServiceEscalation.count') do
      post :create, :nagios_service_escalation => { }
    end

    assert_redirected_to nagios_service_escalation_path(assigns(:nagios_service_escalation))
  end

  def test_should_show_nagios_service_escalation
    get :show, :id => nagios_service_escalations(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => nagios_service_escalations(:one).id
    assert_response :success
  end

  def test_should_update_nagios_service_escalation
    put :update, :id => nagios_service_escalations(:one).id, :nagios_service_escalation => { }
    assert_redirected_to nagios_service_escalation_path(assigns(:nagios_service_escalation))
  end

  def test_should_destroy_nagios_service_escalation
    assert_difference('NagiosServiceEscalation.count', -1) do
      delete :destroy, :id => nagios_service_escalations(:one).id
    end

    assert_redirected_to nagios_service_escalations_path
  end
end
