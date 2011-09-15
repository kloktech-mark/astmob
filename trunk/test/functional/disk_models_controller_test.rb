require File.dirname(__FILE__) + '/../test_helper'

class DiskModelsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:disk_models)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_disk_model
    assert_difference('DiskModel.count') do
      post :create, :disk_model => { }
    end

    assert_redirected_to disk_model_path(assigns(:disk_model))
  end

  def test_should_show_disk_model
    get :show, :id => disk_models(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => disk_models(:one).id
    assert_response :success
  end

  def test_should_update_disk_model
    put :update, :id => disk_models(:one).id, :disk_model => { }
    assert_redirected_to disk_model_path(assigns(:disk_model))
  end

  def test_should_destroy_disk_model
    assert_difference('DiskModel.count', -1) do
      delete :destroy, :id => disk_models(:one).id
    end

    assert_redirected_to disk_models_path
  end
end
