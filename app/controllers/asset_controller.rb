require 'gtable'
class AssetController < ApplicationController
  before_filter :get_lmx_form
  
  def get_lmx_form
    @form_type = params[:form]
    @lmx_form = LmxForm.find_by_code(params[:form])
    @table = GTable.new(@lmx_form.text)
    Anon.set_table_name("lmx_#{params[:form]}")
    Anon.reset_column_information
    @order = params[:order] || "id desc" 
  end
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @assets = Anon.paginate :page=>params[:page], :per_page => 20, :order=>"id desc" 
    @fields = []
    index = 1
    @table.input_cells { |cell, row, col|
      break if index >8
      next if cell.attributes["title"].to_s.size == 0
      @fields << [@table.db_name(cell, row, col), @table.get_cell_attribute(row, col, 'type'), row, col]
      index += 1
    }
  end

  def show
    @asset = Anon.find(params[:id])
  end
  
  def print
    @asset = Anon.find(params[:id])
    render :action=>"show", :layout=>"popup"
  end

  def new
    @asset = Anon.new
    init_script = @table.get_script(:init)
    @form = @asset
    instance_eval(init_script)      #执行初始化脚本
  end

  def create
    @asset = Anon.new(params[@form_type])
    if @asset.save
      flash[:notice] = '添加记录成功.'
      redirect_to :action => 'list', :form=>params[:form], :order=>params[:order]
    else
      render :action => 'new', :form=>params[:form], :order=>params[:order]
    end
  end

  def edit
    @asset = Anon.find(params[:id])
  end

  def update
    @asset = Anon.find(params[:id])
    if @asset.update_attributes(params[@form_type])
      flash[:notice] = '修改记录成功.'
      redirect_to :action => 'list', :form=>params[:form], :order=>params[:order]
    else
      render :action => 'edit'
    end
  end

  def destroy
    Anon.find(params[:id]).destroy
    redirect_to :action => 'list', :form=>params[:form], :order=>params[:order]
  end
end
