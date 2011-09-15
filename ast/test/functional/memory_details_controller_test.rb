require File.dirname(__FILE__) + '/../test_helper'

class MemoryDetailsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:memory_details)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_memory_details
    assert_difference('MemoryDetails.count') do
      post :create, :memory_details => { }
    end

    assert_redirected_to memory_details_path(assigns(:memory_details))
  end

  def test_should_show_memory_details
    get :show, :id => memory_details(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => memory_details(:one).id
    assert_response :success
  end

  def test_should_update_memory_details
    put :update, :id => memory_details(:one).id, :memory_details => { }
    assert_redirected_to memory_details_path(assigns(:memory_details))
  end

  def test_should_destroy_memory_details
    assert_difference('MemoryDetails.count', -1) do
      delete :destroy, :id => memory_details(:one).id
    end

    assert_redirected_to memory_details_path
  end
end
