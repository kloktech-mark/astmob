require File.dirname(__FILE__) + '/../test_helper'

class VipsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:vips)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_vip
    assert_difference('Vip.count') do
      post :create, :vip => { }
    end

    assert_redirected_to vip_path(assigns(:vip))
  end

  def test_should_show_vip
    get :show, :id => vips(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => vips(:one).id
    assert_response :success
  end

  def test_should_update_vip
    put :update, :id => vips(:one).id, :vip => { }
    assert_redirected_to vip_path(assigns(:vip))
  end

  def test_should_destroy_vip
    assert_difference('Vip.count', -1) do
      delete :destroy, :id => vips(:one).id
    end

    assert_redirected_to vips_path
  end
end
