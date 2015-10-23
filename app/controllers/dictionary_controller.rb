class DictionaryController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @dictionaries = Dictionary.paginate :page=>params[:page], :per_page => 30, :order=>"id"
  end

  def show
    @dictionary = Dictionary.find(params[:id])
  end

  def new
    @dictionary = Dictionary.new
  end

  def create
    @dictionary = Dictionary.new(params[:dictionary])
    if @dictionary.save
      flash[:notice] = '添加代码字典成功.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @dictionary = Dictionary.find(params[:id])
  end

  def update
    @dictionary = Dictionary.find(params[:id])
    if @dictionary.update_attributes(params[:dictionary])
      flash[:notice] = '修改代码字典成功.'
      redirect_to :action => 'show', :id => @dictionary
    else
      render :action => 'edit'
    end
  end

  def destroy
    Dictionary.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def items
    @items = Dictionary.find(params[:id]).items
  end
  
  def new_item
    @item = DictionaryItem.new
    @item.dictionary_id = params[:id]
  end
  
  def create_item
    @item = DictionaryItem.new(params[:item])
    @item.save
    flash[:notice] = "添加字典条目成功"
    redirect_to :action=>"items", :id=>params[:id]
  end
  
  def edit_item
    @item = DictionaryItem.find(params[:id])
  end
  
  def update_item
    @item = DictionaryItem.find(params[:id])
    @item.update_attributes(params[:item])
    flash[:notice] = "修改代码字典条目成功"
    redirect_to :action=>"items", :id=>@item.dictionary_id
  end
  
  def destroy_item
    @item = DictionaryItem.find(params[:id])
    @item.destroy
    flash[:notice] = "删除代码字典条目成功"
    redirect_to :action=>"items", :id=>@item.dictionary_id
  end
end
