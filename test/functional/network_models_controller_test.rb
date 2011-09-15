require File.dirname(__FILE__) + '/../test_helper'

class NetworkModelsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:network_models)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_network_model
    assert_difference('NetworkModel.count') do
      post :create, :network_model => { }
    end

    assert_redirected_to network_model_path(assigns(:network_model))
  end

  def test_should_show_network_model
    get :show, :id => network_models(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => network_models(:one).id
    assert_response :success
  end

  def test_should_update_network_model
    put :update, :id => network_models(:one).id, :network_model => { }
    assert_redirected_to network_model_path(assigns(:network_model))
  end

  def test_should_destroy_network_model
    assert_difference('NetworkModel.count', -1) do
      delete :destroy, :id => network_models(:one).id
    end

    assert_redirected_to network_models_path
  end
end
