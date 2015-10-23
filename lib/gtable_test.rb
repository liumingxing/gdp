require 'gtable'
require 'test/unit'
require 'benchmark'


class MyFriend < Test::Unit::TestCase
  def setup
    @table1 = GTable.new("aa", "bb", 4, 4)
    file = File.new('d:\zcfz.xml', 'r')
    xml = file.read
    @table2 =  GTable.new(xml)
  end

  def teardown
    file = File.new('d:\test1.html', 'w')
    file << @table1.to_s(:style) << @table1.to_s(:design)
    file.close
  end

  def test_table
    assert_equal(@table1.code, "aa")
    assert_equal(@table1.name, "bb")
    assert_equal(@table2.code, "zcfz")
    assert_equal(@table2.name, "资产负债表")
    
    assert_instance_of(GTable, @table1, "Class not valid")
    
    assert_equal(@table1.rows_count, 4)
    assert_equal(@table1.cols_count, 4)
    @table1.set_row_height(1, "120px")
    assert_equal(@table1.row_height(1), "120px")
    assert_equal(@table1.row_height(2), "30px")
    @table1.set_col_width(1, "120px")
    assert_equal(@table1.col_width(1), "120px")
    assert_equal(@table1.col_width(3), "100px")
    
    @table1.code = 'code1'
    assert_equal(@table1.code, "code1")
    
    @table1.name = 'name1'
    assert_equal(@table1.name, "name1")
    
    @table1.insert_row(2)
    assert_equal(@table1.rows_count, 5)
    @table1.insert_col(2)
    assert_equal(@table1.cols_count, 5)
    
    @table1.delete_row(3)
    assert_equal(@table1.rows_count, 4)
    @table1.delete_col(3)
    assert_equal(@table1.cols_count, 4)
  end
  
  def test_script
    @table1.set_script(:common, "common\n")
    @table1.set_script(:calc, "\ncalc \nabcdefg abcdefg abcdefg \ncalc\n")
    @table1.set_script(:audit, "\naudit ")
    assert_equal(@table1.get_script(:common), "common")
    assert_equal(@table1.get_script(:calc), "calc \nabcdefg abcdefg abcdefg \ncalc")
    assert_equal(@table1.get_script(:audit), "audit")
    
   

    file = File.new('d:\test2_edit1.html', 'w')
    file << @table2.to_s(:style) << @table2.to_s(:edit)
    file.close
    
    file = File.new('d:\test2.xml', 'w')
    file << @table2.to_s(:xml)
    file.close
  end
  
  def test_cell
    assert_equal(@table1.get_cell_attribute(1, 1, 'text'), '');
    
    @table2.set_cell_attribute(2, 2, 5, 3, "text", "hello")
    assert_equal(@table2.get_cell_attribute(3, 3, 'text'), 'hello');
    assert_equal(@table2.get_cell_attribute(5, 3, 'text'), 'hello');
    
    @table2.merge(6, 2, 8, 2)
    assert_equal(@table2.get_cell_attribute(7, 2, 'style'), 'display:none')
    @table2.split(6, 2)
    assert_equal(@table2.get_cell_attribute(7, 2, 'style').to_s, '')
    @table2.merge(14, 2, 18, 2)
    
    @table2.set_cell_attribute(9, 2, 11, 2, "background-color", "red")
    assert_equal(@table2.get_cell_attribute(10, 2, 'background-color'), 'red')
    
    file = File.new('d:\test2.html', 'w')
    file << @table2.to_s(:style) << @table2.to_s(:design)
    file.close
    
    file = File.new('d:\test2_edit.html', 'w')
    file << @table2.to_s(:style) << @table2.to_s(:edit)
    file.close
  end
end