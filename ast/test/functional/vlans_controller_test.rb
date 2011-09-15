require File.dirname(__FILE__) + '/../test_helper'

class VlansControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:vlans)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_vlan
    assert_difference('Vlan.count') do
      post :create, :vlan => { }
    end

    assert_redirected_to vlan_path(assigns(:vlan))
  end

  def test_should_show_vlan
    get :show, :id => vlans(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => vlans(:one).id
    assert_response :success
  end

  def test_should_update_vlan
    put :update, :id => vlans(:one).id, :vlan => { }
    assert_redirected_to vlan_path(assigns(:vlan))
  end

  def test_should_destroy_vlan
    assert_difference('Vlan.count', -1) do
      delete :destroy, :id => vlans(:one).id
    end

    assert_redirected_to vlans_path
  end
end
