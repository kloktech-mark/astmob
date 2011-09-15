require File.dirname(__FILE__) + '/../test_helper'

class NagiosContactGroupServiceEscalationDetailsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:nagios_contact_group_service_escalation_details)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_nagios_contact_group_service_escalation_detail
    assert_difference('NagiosContactGroupServiceEscalationDetail.count') do
      post :create, :nagios_contact_group_service_escalation_detail => { }
    end

    assert_redirected_to nagios_contact_group_service_escalation_detail_path(assigns(:nagios_contact_group_service_escalation_detail))
  end

  def test_should_show_nagios_contact_group_service_escalation_detail
    get :show, :id => nagios_contact_group_service_escalation_details(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => nagios_contact_group_service_escalation_details(:one).id
    assert_response :success
  end

  def test_should_update_nagios_contact_group_service_escalation_detail
    put :update, :id => nagios_contact_group_service_escalation_details(:one).id, :nagios_contact_group_service_escalation_detail => { }
    assert_redirected_to nagios_contact_group_service_escalation_detail_path(assigns(:nagios_contact_group_service_escalation_detail))
  end

  def test_should_destroy_nagios_contact_group_service_escalation_detail
    assert_difference('NagiosContactGroupServiceEscalationDetail.count', -1) do
      delete :destroy, :id => nagios_contact_group_service_escalation_details(:one).id
    end

    assert_redirected_to nagios_contact_group_service_escalation_details_path
  end
end
