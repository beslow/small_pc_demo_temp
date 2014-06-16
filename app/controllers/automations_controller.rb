require 'spreadsheet'
require 'fileutils'

class AutomationsController < ApplicationController

  include AutomationsHelper

  def index
    @automations = Automation.all
  end

  def new
    # 界面初始化
    @export_types = ExportType.all
    @checked = ExportType.find_by_name("EXCEL").id
    @properties = Property.all
    @property_default_id = 18
    @parts = Part.all
  end

  # 若パラメータ設置 下的参数值如下表示
  # "automation_parameters"=>
  #{"EP1,0_3_1,1"=>"a",
  # "EP1,0_3_1,2"=>"b",
  # "EP2,0_3_2,3"=>"c",
  # "EP2,0_3_2,4"=>"d",
  # "EP1,0_4_1,1"=>"e",
  # "EP1,0_4_1,2"=>"f",
  # "EP2,0_4_2,3"=>"g",
  # "EP2,0_4_2,4"=>"h"},
  # auto_parameters表字段是  id    automation_id   parameter_id    path    value   ...
  # 假设automation_id为1，上述数据应类似保存为
  # id    automation_id   parameter_id    path    value
  # 1         1                 1         3_1       a
  # 2         1                 2         3_1       b
  # 3         1                 3         3_2       c
  # 4         1                 4         3_2       d
  # 5         1                 1         4_1       e
  # 6         1                 2         4_1       f
  # 7         1                 3         4_2       g
  # 8         1                 4         4_2       h
  # 实现在 56行 至 58行
  def create
    automation = Automation.new
    automation.name = params[:automation_name]
    automation.description = params[:description]
    automation.export_type_id = params[:export][:export_type_id]
    automation.part_id = params[:automation_part_id]
    unless automation.valid?
      init_and_memory_automation_new                                        # automation不合法时返回new页面，同时要记忆已输入值并对某些实例变量初始化
      flash.now[:danger] = automation.errors.full_messages.join(" ")        # 给出错误信息
      render new_automation_path
      return
    end
    if automation.save
      unless params[:automation_parameters].blank?
        params[:automation_parameters].each do |automation_parameter|
          a = AutoParameter.new
          a.automation_id = automation.id
          a.parameter_id = automation_parameter.first.split(",").last.to_i
          a.path = automation_parameter.first.split(",").second[2..automation_parameter.first.split(",").second.size-1]
          a.value = automation_parameter.last
          a.save
        end
      end
      flash[:success] = "#{automation.name}创建完成！"
      redirect_to automations_path
      return
    else
      init_and_memory_automation_new                                          # automation保存失败时返回new页面，同时要记忆已输入值并对某些实例变量初始化
      flash.now[:danger] = "操作冲突！"
      render new_automation_path
      return
    end
  end

  # 通过模式框选择得到的part_id，对页面进行填充，3部分
  # 一、【パーツ名】和【コレクション属性】
  # 二、 パラメータ設置中左边的树形结构图
  # 三、 パラメータ設置中右边的内容
  # 主要依靠choose_part.js.erb中js代码对页面对应元素进行替换以及填值完成。
  def choose_part
    begin
      part = Part.find(params[:part_id])
    rescue
      return
    end
    @automation_part_id = params[:part_id]                      # パーツ名的ID
    @part_name = part.name                                      # パーツ名
    @part_property = part.property.name                         # コレクション属性
    @tree_html = generate_tree_html params[:part_id]            # パラメータ設置左边树形结构的html文本字符串
    @eps = generate_array_ep_path params[:part_id], "0", ""     # @eps保存パーツ下属结构的末梢子パーツ以及对应的路径
    
    render 'choose_part.js.erb'
  end

  #出力文件
  def execute
    final_text = generate_final_text params[:id]
    file_name = Automation.find(params[:id]).name + ".xls"
    to_xls file_name, final_text
    return
  end
end
