class DepartmentController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @departments = Department.find(:all)
    @department = Department.find(params[:id]) if params[:id]
  end

  def show
    @department = Department.find(params[:id])
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(params[:department])
    @department.leader_id = params[:leader]
    if @department.save
      flash[:notice] = '创建部门成功'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    
    @department = Department.find(params[:id])
  end

  def update
    @department = Department.find(params[:id])
    @department.leader_id = params[:leader]
    if @department.update_attributes(params[:department])
      flash[:notice] = '修改部门成功'
      redirect_to :action => 'list', :id=>@department
    else
      render :action => 'edit'
    end
  end

  def destroy
    Department.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def destroyfromedit
    Department.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def query
    @department = Department.new
  end
  
  def result
    @department = Department.new(params[:department])
    param = @department.attribute_names
    condition = '1=1  '
    for p in param
      if @department.attribute_present?(p)
        if @department[p].type.to_s == 'Fixnum' || @department[p].type.to_s == 'Bignum' || @department[p].type.to_s == 'Float'
          condition += 'and ' + p + ' = ' + @department[p].to_s + ' '
        elsif @department[p].type.to_s == 'String'
          condition += 'and ' + p + ' like \'%' + @department[p].to_s + '%\' '
        elsif @department[p].type.to_s == 'Time'          
          #condition += 'and ' + p + '= \'' + @department[p].strftime("%Y-%m-%d") + '\' '
        end
      end
    end
    
    count = Department.find(:all, :conditions =>condition).size()
    @department_pages = Paginator.new self, count, 10, @params['page']
    @departments = Department.find_by_sql("select * from departments where #{condition} limit 10 OFFSET #{@department_pages.current.to_sql[1]}")
    
    render :action => 'list'
      
  end

  def reorder
    @node = Department.find(params[:id])
  end

  def order
    index = 1
    for node in params[:nodelist]
      child = Department.find(node)
      child.position = index
      child.save
      index += 1
    end
    
    render :text=>'排序成功'
  end

  #组织结构查询
  def select_department_users
    @departments = Department.find(:all, :conditions=>"parent_id is null")
    render :layout=>"notoolbar"
  end
end
