class ContractController < ApplicationController
  def list
    @nodes = Hygh.find(:all, :conditions=>"project_id = #{session[:pid]} and itemtype = 1")
  end
  
  def import_tree
    @nodes = Hygh.find(:all, :conditions=>"project_id = #{session[:pid]}")
  end
  
  def import_initial
    ContractTree.import_initial(session[:pid], params[:checked_values].split(","), params[:t])
    flash[:notice] = "导入结构成功"
    redirect_to :action=>"list", :t=>params[:t]
  end
  
  def contract_of
    if params[:id]
      if params[:t] == "1"  #合同
        @contracts = Contract.find(:all, :conditions=>"project_id =#{session[:pid]} and category_id = #{params[:id]} and iscontract = 1")
      else                  #费用
        @contracts = Contract.find(:all, :conditions=>"project_id =#{session[:pid]} and category_id = #{params[:id]} and iscontract = 0")
      end
    else
      if params[:t] == "1"  #合同
        @contracts = Contract.find(:all, :conditions=>"project_id =#{session[:pid]} and iscontract = 1")
      else                  #费用
        @contracts = Contract.find(:all, :conditions=>"project_id =#{session[:pid]} and iscontract = 0")
      end
    end
    @list_type = params[:t]
    render :layout=>"notoolbar"
  end
  
  def edit
    @contract = Contract.find(params[:id])
  end
  
  def create
    @contract = Contract.new(params[:contract])
    @contract.project_id = session[:pid]
    @contract.category_id = params[:category_id]
    @contract.save
    flash[:notice] = "新建合同成功"
    redirect_to :action=>'list', :t=>params[:t], :category_id=>params[:category_id]
  end
  
  def destroy
    contract    = Contract.find(params[:id])
    category_id = contract.category_id
    contract.destroy
    t = 1
    t = 2 if contract.iscontract==0
    redirect_to :action => 'contract_of', :id=>category_id, :t=>t
  end
  
  def update
    @contract = Contract.find(params[:id])
    @contract.update_attributes(params[:contract])
    flash[:notice] = '修改合同成功'
    redirect_to :action=>'list', :t=>params[:t], :category_id=>@contract.category_id
  end
  
  def show
    @contract = Contract.find(params[:id])
  end
  
  def new_workitem
    @workitem = Workitem.new
    @workitem.finished = 0
    @workitem.scope = "项目参与人"
  end
  
  def edit_workitem
    @workitem = Workitem.find(params[:id])
  end
  
  def create_workitem
    @workitem = Workitem.new(params[:workitem])
    @workitem.user_id = current_user.id
    @workitem.itemtype = params[:itemtype]
    @workitem.contract_id = params[:id]
    @workitem.save
    flash[:notice] = "新建记录成功"
    redirect_to :action=>"show", :id=>params[:id]
  end
  
  def update_workitem
    @workitem = Workitem.find(params[:id])
    @workitem.update_attributes(params[:workitem])
    flash[:notice] = "更新记录成功"
    redirect_to :action=>"show", :id=>@workitem.contract_id
  end
  
  def destroy_workitem
    @workitem = Workitem.find(params[:id])
    @workitem.destroy
    flash[:notice] = "删除记录成功"
    redirect_to :action=>"show", :id=>@workitem.contract_id
  end
  
  def work_item_detail
    @workitem = Workitem.find(params[:id])
    @subitems  = instance_eval("Workitem#{params[:t].capitalize}").find(:all, :conditions=>"workitem_id = #{params[:id]}")
    render :layout=>false
  end
  
  def create_subitem
    subitem = instance_eval("Workitem#{params[:t].capitalize}").new(params[:subitem])
    subitem.workitem_id = params[:id]
    subitem.save
    
    1.upto(100) do |i|
      if params["attach#{i}"] && params["attach#{i}"][:path] && params["attach#{i}"][:path] != ""
        file = ContractFile.new(params["attach#{i}"])
        file.itemtype   = params[:t]
        file.contract_id= subitem.id
        file.save
      else
        break
      end
    end
    
    redirect_to :action=>"work_item_detail", :id=>params[:id], :t=>params[:t]
  end
  
  def edit_subitem
    @subitem = instance_eval("Workitem#{params[:t].capitalize}").find(params[:id])
    @workitem = @subitem.workitem
    
    render :layout=>false
  end
  
  def update_subitem
    @subitem = instance_eval("Workitem#{params[:t].capitalize}").find(params[:id])
    @subitem.update_attributes(params[:subitem])
    
    1.upto(100) do |i|
      if params["attach#{i}"] && params["attach#{i}"][:path] && params["attach#{i}"][:path] != ""
        file = ContractFile.new(params["attach#{i}"])
        file.itemtype   = params[:t]
        file.contract_id= @subitem.id
        file.save
      else
        break
      end
    end
    
    redirect_to :action=>"work_item_detail", :id=>@subitem.workitem_id, :t=>params[:t]
  end
end
