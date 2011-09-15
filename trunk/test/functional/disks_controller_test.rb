require File.dirname(__FILE__) + '/../test_helper'

class DisksControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:disks)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_disks
    assert_difference('Disks.count') do
      post :create, :disks => { }
    end

    assert_redirected_to disks_path(assigns(:disks))
  end

  def test_should_show_disks
    get :show, :id => disks(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => disks(:one).id
    assert_response :success
  end

  def test_should_update_disks
    put :update, :id => disks(:one).id, :disks => { }
    assert_redirected_to disks_path(assigns(:disks))
  end

  def test_should_destroy_disks
    assert_difference('Disks.count', -1) do
      delete :destroy, :id => disks(:one).id
    end

    assert_redirected_to disks_path
  end
end
