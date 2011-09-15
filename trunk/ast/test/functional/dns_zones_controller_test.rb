require File.dirname(__FILE__) + '/../test_helper'

class DnsZonesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:dns_zones)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_dns_zone
    assert_difference('DnsZone.count') do
      post :create, :dns_zone => { }
    end

    assert_redirected_to dns_zone_path(assigns(:dns_zone))
  end

  def test_should_show_dns_zone
    get :show, :id => dns_zones(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => dns_zones(:one).id
    assert_response :success
  end

  def test_should_update_dns_zone
    put :update, :id => dns_zones(:one).id, :dns_zone => { }
    assert_redirected_to dns_zone_path(assigns(:dns_zone))
  end

  def test_should_destroy_dns_zone
    assert_difference('DnsZone.count', -1) do
      delete :destroy, :id => dns_zones(:one).id
    end

    assert_redirected_to dns_zones_path
  end
end
