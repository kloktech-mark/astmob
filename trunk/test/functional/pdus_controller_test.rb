require File.dirname(__FILE__) + '/../test_helper'

class PdusControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:pdus)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_pdu
    assert_difference('Pdu.count') do
      post :create, :pdu => { }
    end

    assert_redirected_to pdu_path(assigns(:pdu))
  end

  def test_should_show_pdu
    get :show, :id => pdus(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => pdus(:one).id
    assert_response :success
  end

  def test_should_update_pdu
    put :update, :id => pdus(:one).id, :pdu => { }
    assert_redirected_to pdu_path(assigns(:pdu))
  end

  def test_should_destroy_pdu
    assert_difference('Pdu.count', -1) do
      delete :destroy, :id => pdus(:one).id
    end

    assert_redirected_to pdus_path
  end
end
