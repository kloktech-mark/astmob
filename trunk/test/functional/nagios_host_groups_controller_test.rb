require File.dirname(__FILE__) + '/../test_helper'

class NagiosHostGroupsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:nagios_host_groups)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_nagios_host_group
    assert_difference('NagiosHostGroup.count') do
      post :create, :nagios_host_group => { }
    end

    assert_redirected_to nagios_host_group_path(assigns(:nagios_host_group))
  end

  def test_should_show_nagios_host_group
    get :show, :id => nagios_host_groups(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => nagios_host_groups(:one).id
    assert_response :success
  end

  def test_should_update_nagios_host_group
    put :update, :id => nagios_host_groups(:one).id, :nagios_host_group => { }
    assert_redirected_to nagios_host_group_path(assigns(:nagios_host_group))
  end

  def test_should_destroy_nagios_host_group
    assert_difference('NagiosHostGroup.count', -1) do
      delete :destroy, :id => nagios_host_groups(:one).id
    end

    assert_redirected_to nagios_host_groups_path
  end
end
