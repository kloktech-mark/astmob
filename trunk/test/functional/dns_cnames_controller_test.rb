require File.dirname(__FILE__) + '/../test_helper'

class DnsCnamesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:dns_cnames)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_dns_cname
    assert_difference('DnsCname.count') do
      post :create, :dns_cname => { }
    end

    assert_redirected_to dns_cname_path(assigns(:dns_cname))
  end

  def test_should_show_dns_cname
    get :show, :id => dns_cnames(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => dns_cnames(:one).id
    assert_response :success
  end

  def test_should_update_dns_cname
    put :update, :id => dns_cnames(:one).id, :dns_cname => { }
    assert_redirected_to dns_cname_path(assigns(:dns_cname))
  end

  def test_should_destroy_dns_cname
    assert_difference('DnsCname.count', -1) do
      delete :destroy, :id => dns_cnames(:one).id
    end

    assert_redirected_to dns_cnames_path
  end
end
