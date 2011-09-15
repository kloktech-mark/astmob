require File.dirname(__FILE__) + '/../test_helper'

class ColosControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:colos)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_colo
    assert_difference('Colo.count') do
      post :create, :colo => { }
    end

    assert_redirected_to colo_path(assigns(:colo))
  end

  def test_should_show_colo
    get :show, :id => colos(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => colos(:one).id
    assert_response :success
  end

  def test_should_update_colo
    put :update, :id => colos(:one).id, :colo => { }
    assert_redirected_to colo_path(assigns(:colo))
  end

  def test_should_destroy_colo
    assert_difference('Colo.count', -1) do
      delete :destroy, :id => colos(:one).id
    end

    assert_redirected_to colos_path
  end
end
