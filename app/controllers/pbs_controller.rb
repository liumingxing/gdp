require 'rexml/document'

class PbsController < ApplicationController
  def index
    @pbs = Pbs.paginate :page=>params[:page], :per_page=>20, :order=>"pbstype"
  end
  
  def new
    @pbs = Pbs.new
  end

  def create
    @pbs = Pbs.new(params[:pbs])
    if @pbs.save
      flash[:notice] = '添加单项工程成功'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @pbs = Pbs.find(params[:id])
  end

  def update
    @pbs = Pbs.find(params[:id])
    if @pbs.update_attributes(params[:pbs])
      flash[:notice] = '修改单项工程成功'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Pbs.find(params[:id]).destroy
    flash[:notice] = '删除单项工程成功'
    redirect_to :action => 'list'
  end
  
  def set_pbs
    @nodes = PbsNode.find(:all, :conditions=>"pbs_id = #{params[:id]}") 
  end
  
  def update_pbs
    #先清空
    PbsNode.delete_all "pbs_id = #{params[:id]}"
    for id in params[:checked_values].split(",")
      next if id.size == 0
      t = PbsTemplate.find(:first, :conditions=>"id = #{id}")
      next if !t
      
      node = PbsNode.new
      node.pbs_id = params[:id]
      node.template_id = t.id
      node.save
    end
    
    flash[:notice] = "设置成功"
    redirect_to :action=>"set_pbs", :id=>params[:id]
  end
  
  #获取指标数据
  def get_pricedata
    doc = REXML::Document.new("<Grid><Body><B></B></Body></Grid>")
    element = REXML::XPath.first(doc, "/Grid/Body/B")
    
    if params[:id] && params[:id] != ""
      roots = PbsTemplate.roots
      collection = PbsNode.find(:all, :conditions=>"pbs_id=#{params[:id]}").collect{|n| n.template_id}
      for root in roots
        next if !collection.include?(root.id)
        root.insert_price_element(element, params[:id], collection)
      end
    end
    str = ''
    doc.write(str)
    puts str
    render :text=>str
  end
  
  #获取属性数据
  def get_propertydata
    render :text=>PbsProperty.get_data("pbs_id = #{params[:id]}")
  end
  
  #保存指标数据
  def upload_pricedata
    render :text=>PbsNode.upload_data(params[:Data])
  end
  
  #保存属性数据
  def upload_propertydata
    render :text=>PbsProperty.upload_data(params[:Data])
  end
  
  def get_style 
    file = File.open("public/xml/gridstyle_tzgh.xml")
    doc = REXML::Document.new(file.read)
    file.close
    
    elements = REXML::XPath.match(doc, '/Grid/Cols/C')
    elements[1].attributes["Enum"]      = "|安装工程费|建筑工程费|设备购置费|其他费"
    elements[1].attributes["EnumKeys"]  = "|安装工程费|建筑工程费|设备购置费|其他费"
    str = ''
    doc.write(str)
    render :text=>str
  end
  
  #获得pbs全模板树形数据
  def get_template_data
    render :text=>PbsTemplate.get_data("parent_id is null")
  end
  
  #保存树形
  def upload_data
    render :text=>PbsTemplate.upload_data(params[:Data])
  end
  
  #导出xml模板
  def export_xml
    doc = REXML::Document.new("<root><template></template><singles></singles></root>")
    #全模板PbsTemplate
    element = doc.root.elements[1]
    for pbs in PbsTemplate.find(:all)
      e = element.add_element "pbs"
      pbs.attributes.each{|key, value|
        e.attributes[key]     = value
      }
    end
    
    element = doc.root.elements[2]
    #单项工程Pbs
    for single in Pbs.find(:all)
      single_e = element.add_element "single"
      single.attributes.each{|key, value|
        single_e.attributes[key]     = value
      }
      
      #单项工程属性PbsSingle
      propertys_e = single_e.add_element "propertys"
      for property in single.propertys
        e = propertys_e.add_element "property"
        property.attributes.each{|key, value|
          e.attributes[key]   = value
        }
      end
    
      #单项工程节点PbsNode
      nodes_e = single_e.add_element "nodes"
      for node in single.nodes
        e = nodes_e.add_element "node"
        node.attributes.each{|key, value|
          e.attributes[key]   = value
        }
      end
    end
    
    #导出投资规划模板
    element = doc.root.add_element "tztemplates"
    for template in Tztemplate.find(:all)
      element1 = element.add_element "tztemplate"
      template.attributes.each{|key, value|
          element1.attributes[key]     = value
      }
      
      for node in template.nodes
        element2 = element1.add_element "node"
        node.attributes.each{|key, value|
          element2.attributes[key]     = value
        }
      end
    end
    
    #导出投资规划模板
    element = doc.root.add_element "contract_templates"
    for template in ContractTemplate.find(:all)
      element1 = element.add_element "contract_template"
      template.attributes.each{|key, value|
          element1.attributes[key]     = value
      }
      
      for node in template.nodes
        element2 = element1.add_element "node"
        node.attributes.each{|key, value|
          element2.attributes[key]     = value
        }
      end
    end

    str = ''
    doc.write(str, 2)
    send_data(str, :filename=>"template.xml")
  end
  
  #导入xml模板
  def import_xml
    doc = REXML::Document.new(params[:template].read)
    if !doc.root
      render :text=>"文件内容为空或者格式不符，请检查!"
      return
    end
    
    PbsTemplate.delete_all
    Pbs.delete_all
    PbsNode.delete_all
    PbsProperty.delete_all
    Tztemplate.delete_all
    TztemplateNode.delete_all
    ContractTemplate.delete_all
    ContractTemplateNode.delete_all
    
    #导入全模板表
    for element in REXML::XPath.match(doc, "/root/template/pbs")
      pbs = PbsTemplate.new
      pbs.attributes.each{|key, value|
        pbs.id   = element.attributes["id"]
        pbs[key] = element.attributes[key] if element.attributes[key] 
      }
      pbs.save
    end
    #导入各个单项表
    for element in REXML::XPath.match(doc, "/root/singles/single")
      single      = Pbs.new
      single.id   = element.attributes["id"]
      single.attributes.each{|key, value|
        single[key] = element.attributes[key] if element.attributes[key] 
      }
      single.save
    end
    
    for e in REXML::XPath.match(element, "/root/singles/single/propertys/property")
      property      = PbsProperty.new
      property.id   = e.attributes["id"]
      property.attributes.each{|key, value|
        property[key] = e.attributes[key] if e.attributes[key] 
      }
      property.save
    end
      
    for e in REXML::XPath.match(element, "/root/singles/single/nodes/node")
      node      = PbsNode.new
      node.id   = e.attributes["id"]
      node.attributes.each{|key, value|
        node[key] = e.attributes[key] if e.attributes[key] 
      }
      node.save
    end
    
    #投资规划模板
    for e in REXML::XPath.match(element, "/root/tztemplates/tztemplate")
      node      = Tztemplate.new
      node.id   = e.attributes["id"]
      node.attributes.each{|key, value|
        node[key] = e.attributes[key] if e.attributes[key] 
      }
      node.save
    end
    
    #投资规划模板
    for e in REXML::XPath.match(element, "/root/tztemplates/tztemplate/node")
      node      = TztemplateNode.new
      node.id   = e.attributes["id"]
      node.attributes.each{|key, value|
        node[key] = e.attributes[key] if e.attributes[key] 
      }
      node.save
    end
    
    #合约规划模板
    for e in REXML::XPath.match(element, "/root/contract_templates/contract_template")
      node      = ContractTemplate.new
      node.id   = e.attributes["id"]
      node.attributes.each{|key, value|
        node[key] = e.attributes[key] if e.attributes[key] 
      }
      node.save
    end
    
    #合约规划模板
    for e in REXML::XPath.match(element, "/root/contract_templates/contract_template/node")
      node      = ContractTemplateNode.new
      node.id   = e.attributes["id"]
      node.attributes.each{|key, value|
        node[key] = e.attributes[key] if e.attributes[key] 
      }
      node.save
    end
    
    flash[:notice] = "导入模板成功"
    redirect_to :action=>"template"
  end
  
  
private
  #xml转为数据库
  def xml_to_record(element, parent)
    pbs = PbsTemplate.new
    pbs.id        = element.attributes["id"]
    pbs.name      = element.attributes["name"]
    pbs.feetype   = element.attributes["feetype"]
    pbs.feescope  = element.attributes["feescope"]
    pbs.position  = element.attributes["position"]
    pbs.parent_id = parent.id if parent
    pbs.save
    
    for e1 in element.elements
      xml_to_record(e1, pbs)
    end
  end
  
  #数据库转为xml
  def record_to_xml(element, pbs)
    e = element.add_element "pbs"
    e.attributes["id"]    = pbs.id
    e.attributes["name"]    = pbs.name
    e.attributes["feetype"] = pbs.feetype
    e.attributes["feescope"]= pbs.feescope
    e.attributes["position"]= pbs.position
    for child in pbs.children
      record_to_xml(e, child)
    end
  end

  def copy_element_to_record(e, budget)
    budget.name       = e.attributes["name"]     if e.attributes["name"]
    budget.feetype    = e.attributes["feetype"]  if e.attributes["feetype"]
    budget.feescope   = e.attributes["feescope"] if e.attributes["feescope"]
  end
end
