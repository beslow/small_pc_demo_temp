module AutomationsHelper

  # root_id可以是EP或者是CP的ID, generate_tree_html方法配合下面的generate_tree_children_html方法，来生成html文本字符串
  # 如果root_id是EP1的id时，生成如下html文本
  # <ul style='padding: 0px'><li><span><a class='ep_select' data-toggle='tab' href='#EP1'>EP1</a></span></li></ul>
  # 如果root_id是CPA时(CPA由EP1和EP2组成)，生成如下html文本
  # <ul style='padding: 0px'><li><span>CPA</span><ul><li><span><a class='ep_select' data-toggle='tab' href='#EP1'>
  # EP1</a></span></li><li><span><a class='ep_select' data-toggle='tab' href='#EP2'>EP2</a></span></li></ul></li></ul>
  def generate_tree_html root_id
    string_tree_html = "<ul style='padding: 0px'><li>" + (generate_tree_children_html root_id, "0", "")  + "</li></ul>"
  end

  def generate_tree_children_html root_id, parent_path, path
    string_html = ""
    path = "" if path.blank?
    parent_path = "" if parent_path.blank?
    begin
      root_part = Part.find(root_id)
    rescue
      return string_html
    end
    if root_part.partclass.name.eql? "CP"  #还没考虑partclass为nil的情况
      string_html += "<span>#{root_part.name}</span>"
      string_html += "<ul>"
      root_part.combos.each do |combo|
        string_html += "<li>" + (generate_tree_children_html combo.sub_part_id, parent_path+path, "_#{combo.id.to_s}") + "</li>"
      end
      string_html += "</ul>"
    else
      string_html += "<span><a class='ep_select' data-toggle='tab' href='##{parent_path+path}'>#{root_part.name}</a></span>"
    end
  end

  # generate_array_ep_path配合generate_array_ep,用来产生id为root_id的part下所有EP以及相应的路径 组成的数组
  # 例：CP1由EP1和EP2构成，EP1在前，root_id设置为CP1的id，parent_path设置为"0"，path为"",
  # array_ep最终的结果是 [ [#<EP1>, "0_1"], [ #<EP2>, "0_2"] ]
  # 其中 #<EP1> 代表Part.find(root_id)的值，0 表示从根开始，1 表示CP1到EP1这个combo(关系)的id
  def generate_array_ep_path root_id, parent_path, path
    arr = Array.new
    generate_array root_id, arr, parent_path, path
    arr
  end

  def generate_array root_id, array_ep, parent_path, path
    begin
      root_part = Part.find(root_id)
    rescue
      return array_ep
    end
    if root_part.partclass.name.eql? "CP"  #还没考虑partclass为nil的情况
      root_part.combos.order(sort: :asc).each do |combo|
        temp_path = (parent_path+path).blank? ? "#{combo.id}" : "_#{combo.id}"
        generate_array combo.sub_part_id, array_ep, parent_path+path, temp_path
      end
    else
      array_ep << [root_part, parent_path+path]
    end
  end

  def init_and_memory_automation_new
    @export_types = ExportType.all                                        # 出力类型
    @checked = ExportType.find_by_name("EXCEL").id                        # 默认选中EXCEL作为出力项
    @properties = Property.all                                            # 属性选项
    @property_default_id = 18                                             # 默认选中【その他】
    @parts = Part.all                                                     # 弹出选择窗时，默认列出所有 part
    @automation_part_id = params[:automation_part_id]                     # 保存选中的part的ID
    begin                                                                # 预防RecordNotFound错误
      part = Part.find(params[:automation_part_id])                       # 用选中的part的ID查找part，利用其值来给@part_name和@part_property赋值
      @part_name = part.name
      @part_property = part.property.name
    rescue
      #done nothing
    end
    @tree_html = generate_tree_html params[:automation_part_id]           # 保存パラメータ設置左边树形结构的html文本字符串
    @eps = generate_array_ep_path params[:automation_part_id], "0", ""    # @eps保存パーツ下属结构的末梢子パーツ以及对应的路径
  end

  #根据part的id 按先后顺序获得该part下所有末梢EP的内容，并依序相加起来
  def get_all_sources_by_part_id id
    @sources = ""
    all_sources id
    @sources
  end

  def all_sources root_id
    begin
      root_part = Part.find(root_id)
    rescue
      return @sources
    end
    if root_part.partclass.name.eql? "CP"
      root_part.combos.order(sort: :asc).each do |combo|
        all_sources combo.sub_part_id
      end
    else
      @sources +=  root_part.content
    end
  end

  def generate_final_text automation_id
    text = ""
    begin
      part_id = Automation.find(automation_id).part_id
    rescue
      return @text
    end
    ep_paths = generate_array_ep_path part_id, "", ""
    ep_paths.each do |ep_path|
      parameters = {}
      AutoParameter.where("automation_id = ? and path = ?", automation_id, ep_path.last).each do |ap|
        parameters[Parameter.find(ap.parameter_id).name] = ap.value
      end
      text += analyze(ep_path.first.content, parameters)
    end
    text
  end

  def analyze content, parameters = {}
    parameters.each do |parameter|
      puts parameter.first
      puts parameter.last
      pattern = /&&&#{parameter.first}&&&/
      content.gsub!(pattern, parameter.last)
    end
    content += "\r\n"
  end
  def to_xls file_name, text
      Spreadsheet.client_encoding = "UTF-8"
      book = Spreadsheet::Workbook.new
      sheet1 = book.create_worksheet :name => "Test Excel"
      default_format = Spreadsheet::Format.new(:weight => :bold, :size => 14,
                                               :align => :merge, :color=>"red", :border=> 'thin',
                                               :border_color=>"black", :pattern => 1 ,
                                               :pattern_fg_color => "yellow" )
      text.split("\r\n").each_with_index do |text,index|
        sheet1[index,0] = text unless text.strip.eql? "***NEWLINE***"
      end
      #data = "测试标题"
      #test_row = sheet1.row(0)
      #5.times do |i|
      #test_row.set_format(i, default_format)
      #end
      #test_row[0] = data
      book.write file_name
      temp_file = File.new(file_name, "rb")
      data = temp_file.read
      temp_file.close
      send_data(data,
                :type => "text/excel;charset=utf-8; header=present",
                :filename => file_name)
      File.delete(file_name)
    end
end
