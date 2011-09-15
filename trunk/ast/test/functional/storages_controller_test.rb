require File.dirname(__FILE__) + '/../test_helper'

class StoragesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:storages)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_storage
    assert_difference('Storage.count') do
      post :create, :storage => { }
    end

    assert_redirected_to storage_path(assigns(:storage))
  end

  def test_should_show_storage
    get :show, :id => storages(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => storages(:one).id
    assert_response :success
  end

  def test_should_update_storage
    put :update, :id => storages(:one).id, :storage => { }
    assert_redirected_to storage_path(assigns(:storage))
  end

  def test_should_destroy_storage
    assert_difference('Storage.count', -1) do
      delete :destroy, :id => storages(:one).id
    end

    assert_redirected_to storages_path
  end
end
