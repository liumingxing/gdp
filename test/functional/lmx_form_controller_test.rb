require File.dirname(__FILE__) + '/../test_helper'
require 'lmx_form_controller'

# Re-raise errors caught by the controller.
class LmxFormController; def rescue_action(e) raise e end; end

class LmxFormControllerTest < Test::Unit::TestCase
  fixtures :lmx_form

  def setup
    @controller = LmxFormController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = lmx_forms(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:lmx_forms)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:lmx_form)
    assert assigns(:lmx_form).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:lmx_form)
  end

  def test_create
    num_lmx_forms = LmxForm.count

    post :create, :lmx_form => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_lmx_forms + 1, LmxForm.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:lmx_form)
    assert assigns(:lmx_form).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      LmxForm.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      LmxForm.find(@first_id)
    }
  end
end
