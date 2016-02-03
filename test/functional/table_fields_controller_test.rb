require 'test_helper'

class TableFieldsControllerTest < ActionController::TestCase
  setup do
    @table_field = table_fields(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:table_fields)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create table_field" do
    assert_difference('TableField.count') do
      post :create, table_field: {  }
    end

    assert_redirected_to table_field_path(assigns(:table_field))
  end

  test "should show table_field" do
    get :show, id: @table_field
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @table_field
    assert_response :success
  end

  test "should update table_field" do
    put :update, id: @table_field, table_field: {  }
    assert_redirected_to table_field_path(assigns(:table_field))
  end

  test "should destroy table_field" do
    assert_difference('TableField.count', -1) do
      delete :destroy, id: @table_field
    end

    assert_redirected_to table_fields_path
  end
end
