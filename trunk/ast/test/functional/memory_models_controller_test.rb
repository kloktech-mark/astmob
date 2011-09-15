require File.dirname(__FILE__) + '/../test_helper'

class MemoryModelsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:memory_models)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_memory_models
    assert_difference('MemoryModels.count') do
      post :create, :memory_models => { }
    end

    assert_redirected_to memory_models_path(assigns(:memory_models))
  end

  def test_should_show_memory_models
    get :show, :id => memory_models(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => memory_models(:one).id
    assert_response :success
  end

  def test_should_update_memory_models
    put :update, :id => memory_models(:one).id, :memory_models => { }
    assert_redirected_to memory_models_path(assigns(:memory_models))
  end

  def test_should_destroy_memory_models
    assert_difference('MemoryModels.count', -1) do
      delete :destroy, :id => memory_models(:one).id
    end

    assert_redirected_to memory_models_path
  end
end
