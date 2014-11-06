require 'test_helper'

class HashTagsControllerTest < ActionController::TestCase
  setup do
    @hash_tag = hash_tags(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hash_tags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hash_tag" do
    assert_difference('HashTag.count') do
      post :create, hash_tag: {  }
    end

    assert_redirected_to hash_tag_path(assigns(:hash_tag))
  end

  test "should show hash_tag" do
    get :show, id: @hash_tag
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hash_tag
    assert_response :success
  end

  test "should update hash_tag" do
    patch :update, id: @hash_tag, hash_tag: {  }
    assert_redirected_to hash_tag_path(assigns(:hash_tag))
  end

  test "should destroy hash_tag" do
    assert_difference('HashTag.count', -1) do
      delete :destroy, id: @hash_tag
    end

    assert_redirected_to hash_tags_path
  end
end
