require File.dirname(__FILE__) + '/../test_helper'

class VlanDetailsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:vlan_details)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_vlan_detail
    assert_difference('VlanDetail.count') do
      post :create, :vlan_detail => { }
    end

    assert_redirected_to vlan_detail_path(assigns(:vlan_detail))
  end

  def test_should_show_vlan_detail
    get :show, :id => vlan_details(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => vlan_details(:one).id
    assert_response :success
  end

  def test_should_update_vlan_detail
    put :update, :id => vlan_details(:one).id, :vlan_detail => { }
    assert_redirected_to vlan_detail_path(assigns(:vlan_detail))
  end

  def test_should_destroy_vlan_detail
    assert_difference('VlanDetail.count', -1) do
      delete :destroy, :id => vlan_details(:one).id
    end

    assert_redirected_to vlan_details_path
  end
end
