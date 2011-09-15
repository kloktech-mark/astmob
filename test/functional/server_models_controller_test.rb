require File.dirname(__FILE__) + '/../test_helper'

class ServerModelsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:server_models)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_server_model
    assert_difference('ServerModel.count') do
      post :create, :server_model => { }
    end

    assert_redirected_to server_model_path(assigns(:server_model))
  end

  def test_should_show_server_model
    get :show, :id => server_models(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => server_models(:one).id
    assert_response :success
  end

  def test_should_update_server_model
    put :update, :id => server_models(:one).id, :server_model => { }
    assert_redirected_to server_model_path(assigns(:server_model))
  end

  def test_should_destroy_server_model
    assert_difference('ServerModel.count', -1) do
      delete :destroy, :id => server_models(:one).id
    end

    assert_redirected_to server_models_path
  end
end
