module DepartmentHelper
  def show_departmenttree(linkurl, target=nil)
    result = ''
    departments = Department.find(:all, :conditions=>"parent_id is null or parent_id = -1")
    for d in departments
      result << "var tree#{d.id} = new WebFXTree('#{d.name}');\n"
      result << "tree#{d.id}.icon = '/img/department.gif';\n"
      result << "tree#{d.id}.openIcon = '/img/department.gif';\n"
      result << "tree#{d.id}.target = '#{target}';\n" if target
      result << "tree#{d.id}.action = '#{linkurl}/#{d.id}';\n"
      result << show_subnode(d, linkurl, target)
      result << "document.write(tree#{d.id});tree#{d.id}.expandAll();\n"
    end
    return result
  end


  def show_subnode(map, linkurl, target=nil)
    result = ''
    for child in map.children
      result << "tree#{child.id} = tree#{map.id}.add(new WebFXTreeItem('#{child.name}'));\n"
      result << "tree#{child.id}.openIcon = '/img/department.gif';"
      result << "tree#{child.id}.icon = '/img/department.gif';"
      result << "tree#{child.id}.target = '#{target}';\n" if target
      result << "tree#{child.id}.action = '#{linkurl}/#{child.id}';\n"
      result << show_subnode(child, linkurl, target)
    end

    result
  end
end
