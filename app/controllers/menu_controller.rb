class MenuController < ApplicationController
  def index
    @menu = Menu.new
    @roots = Menu.find(:all, :order=>"position", :conditions=>"parent_id is null or parent_id=''")
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def show
    @menu = Menu.find(params[:id])
  end

  def new
    @menu = Menu.new
    @menu.parent_id = params[:parent]
    render :layout=>false
  end

  def create
    @menu = Menu.new(params[:menu])
    if @menu.save
      flash[:notice] = '新建节点成功'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @menu = Menu.find(params[:id])
    render :action => "edit", :layout =>false
  end

  def update
    @menu = Menu.find(params[:id])
    if @menu.update_attributes(params[:menu])
      #flash[:notice] = '修改节点信息成功'
      #redirect_to :action => 'index'
      render :text=>"修改节点信息成功"
    else
      render :action => 'edit'
    end
  end

  def destroy
    Menu.find(params[:id]).destroy
    render :text=>"删除节点成功"
    #redirect_to :action => 'index'
  end
  
  def getchildnode    
    doc = "<?xml version='1.0' encoding='UTF-8'?><treeRoot>"
    parent = Menu.find(params[:id])
    for child in parent.children
      src = "/menu/getchildnode/#{child.id}"
      src = "" if child.children.size == 0
      img = "/img/icon_9.png"
      img = "/img/icon_0.png" if child.children.size == 0
      doc += "<tree text='#{child.text}' 
              src='#{src}' 
              icon='#{img}' 
              openIcon='#{img}' 
              clickFunc=\" $('#editdiv').load('/menu/edit/#{child.id}'); return false; \"
              >"
      doc += "</tree>"
    end
    
    doc += '</treeRoot>'
    #doc = EncodeUtil.change('GB2312', 'UTF-8', doc)
    send_data doc, :type =>"text/xml"
  end
  
  def getchildnode_action
    doc = "<?xml version='1.0' encoding='UTF-8'?><treeRoot>"

   begin
    parent = Menu.find(:first, :conditions=>"id=#{params[:id]}")
   rescue Exception => e
      p e
    end
    for child in parent.children
      next if child.hide == 1
      next if child.list_right && !checkright_by_id(child.list_right)

      src = "/menu/getchildnode_action/#{child.id}"
      src = "" if child.children.size == 0
      #action = child.url
      img = "/img/icon_9.png"
      img = "/img/icon_0.png" if child.children.size == 0
      content = "content"
      content = "_blank" if child.blank == 1
      
      text = child.text
      text = instance_eval(child.text) if child.text.index('"')  || child.text.index("'")
      url = child.url
      url =  instance_eval(url) if url && (url.index('"') || url.index("'"))
      doc += "<tree text='#{text}' 
              src='#{src}' 
              icon='#{img}' 
              openIcon='#{img}' 
              action='#{url}'
              target='#{content}'
              >"
      doc += "</tree>"
    end
    
    doc += '</treeRoot>'
    send_data doc, :type =>"text/xml"
  end
  
  def reorder
    @node = Menu.find(params[:id])
  end
  
  def order
    index = 1
    for node in params[:nodelist]
      child = Menu.find(node)
      child.position = index
      child.save
      index += 1
    end
    
    render :text=>'排序成功'
  end
end
