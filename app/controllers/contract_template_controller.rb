require 'rexml/document'

class ContractTemplateController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @contract_templates = ContractTemplate.paginate :page=>params[:page], :per_page => 10, :order=>"id desc"
  end

  def show
    @contract_template = ContractTemplate.find(params[:id])
  end

  def new
    @contract_template = ContractTemplate.new
  end

  def create
    @contract_template = ContractTemplate.new(params[:contract_template])
    if @contract_template.save
      flash[:notice] = 'ContractTemplate was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @contract_template = ContractTemplate.find(params[:id])
  end

  def update
    @contract_template = ContractTemplate.find(params[:id])
    if @contract_template.update_attributes(params[:contract_template])
      flash[:notice] = 'ContractTemplate was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    ContractTemplate.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def get_data
    render :text=>ContractTemplateNode.get_data("template_id = #{params[:id]} and (parent_id is null or parent_id = 0)")
  end
  
  #保存合约规划树形结构
  def upload_data
    render :text=>ContractTemplateNode.upload_data(params[:Data], :template_id=>params[:id])
  end
end
