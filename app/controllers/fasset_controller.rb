require 'gtable'
class FassetController < ApplicationController
  before_filter :get_lmx_form
  before_filter :get_table_width, :only=>%w(new edit)
  
  def get_lmx_form
    @form_type = params[:form]
    @lmx_form = LmxForm.find_by_code(params[:form])
    @table = GTable.new(@lmx_form.text)
    Anon.set_table_name("lmx_#{params[:form]}")
    Anon.reset_column_information
    
    @order = params[:order] || "id desc" 
    
    1.upto(@table.rows_count) do |row|
      if @table.float_row?(row)
        @float_index = row 
        AnonDetail.set_table_name("lmx_#{params[:form]}_#{row}")
        AnonDetail.reset_column_information
        break
      end
    end 
  end
  
  def get_table_width
    @width = 0
    1.upto(@table.cols_count) do |col|
      @width += @table.col_width(col).to_i
    end
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
    @items = AnonDetail.find(:all, :conditions=>"parent_id = #{params[:id]}")
  end
  
  def print
    @asset = Anon.find(params[:id])
    @items = AnonDetail.find(:all, :conditions=>"parent_id = #{params[:id]}")
    render :action=>"show", :layout=>"popup"
  end

  def new
    @asset = Anon.new
    init_script = @table.get_script(:init)
    @form = @asset
    @items = []
    instance_eval(init_script)      #执行初始化脚本
  end

  def create
    @asset = Anon.new(params[@form_type])
    if @asset.save    #保存主表
      1.upto(params[:sub_count].to_i) do |i|
        next if !params["float#{@float_index}_item#{i}"]
        detail = AnonDetail.new(params["float#{@float_index}_item#{i}"])
        detail.parent_id = @asset.id
        detail.save
      end
      flash[:notice] = '添加记录成功.'
      redirect_to :action => 'list', :form=>params[:form], :order=>params[:order]
    else
      render :action => 'new', :form=>params[:form], :order=>params[:order]
    end
  end

  def edit
    @asset = Anon.find(params[:id])
    @items = AnonDetail.find(:all, :conditions=>"parent_id = #{params[:id]}")
  end

  def update
    @asset = Anon.find(params[:id])
    if @asset.update_attributes(params[@form_type])
      AnonDetail.delete_all "parent_id = #{@asset.id}"
      1.upto(params[:sub_count].to_i) do |i|
        next if !params["float#{@float_index}_item#{i}"]
        detail = AnonDetail.new(params["float#{@float_index}_item#{i}"])
        detail.parent_id = @asset.id
        detail.save
      end
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
  
  #添加明细
  def add_item
    @index = params[:item_index]
    #instance_eval("@item#{@index} = AnonDetail.new")
    render :text => @table.float_row_to_s(@float_index, @index.to_i, :edit, AnonDetail.new)
    #render :partial=>"item"
  end
end
