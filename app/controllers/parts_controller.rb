class PartsController < ApplicationController
  include PartsHelper
  include AutomationsHelper
  def index
    @parts = Part.all
  end

  def new
    init_new_part_page
  end
  
  def create
    @num_params = params[:num_params]
    if params[:commit] == "確定"
      render 'insert.js.erb'
      return
    end
    #根据params[:commit]判断用户点击的是"保存"，还是"連続作成"，跳转到相应页面
    if create_ep          #创建part和parameter
      redirect_to parts_path if params[:commit] == "保存"
      redirect_to new_part_path if params[:commit] == "連続作成"
    end
  end

  def create_cp
    init_combo_part_page

    part = Part.new
    part.property_id = params[:property]
    part.name = params[:cp_name]
    part.company_id = 1
    part.partclass_id = 2 #CP

    #识别番号，查找（公司、属性约束后）识别番号最大值，没有的话默认为1，查找到的话 +1
    max_classify_id = Part.where(company_id: 1, property_id: params[:property]).maximum("classify_id")
    part.classify_id = max_classify_id.blank? ? 1 : max_classify_id + 1

    unless part.valid? #&& params[:target_parts_id].blank?
      flash.now[:danger] = part.errors.full_messages.join("")

      # 保持属性值
      @default_property_id  = params[:property]
      unless params[:target_parts_id].blank?
        # 保持右边list的列表项
        @target_parts = Array.new
        params[:target_parts_id].split(",").each do |t_p_id|
          @target_parts << Part.find(t_p_id.to_i)
        end

        #将@target_parts的每个part的id组成字符串保存到@target_parts_ids中
        @target_parts_ids = @target_parts.collect{ |t_p| t_p.id }.join(",")
      end

      render combination_parts_path
      return
    end

    if params[:target_parts_id].blank?
      flash.now[:danger] = "CP的子part不能为空！"

      render combination_parts_path
      return
    end

    if part.save
      sub_parts_ids = params[:target_parts_id].split(",")
      sub_parts_ids.each_with_index do |s_p_id,index|
        Combo.new(part_id: part.id, sub_part_id: s_p_id.to_i, sort: index+1).save
      end
    end
    redirect_to parts_path
  end

  def search
    redirect_to parts_path
  end

  def combination
    init_combo_part_page
  end

  def insert
    @num_params = params[:num_params]
    render 'insert.js.erb'
  end

  def change_listbox

    @target_parts = Array.new
    if params[:commit] == "→"    #从左边把选中的part添加到右边，忽略已有的

      #读取已有的part，并存入到实例变量@target_parts中
      unless params[:target_parts_id].blank?
        array_target_parts_id = params[:target_parts_id].split(",")
        array_target_parts_id.collect! { |p_id| p_id.to_i}
        array_target_parts_id.each do |id|   #这样做得到的part顺序不会乱掉
          @target_parts << Part.find(id)
        end
      end

      unless params[:source_parts].blank?
        params[:source_parts].collect! { |p_id| p_id.to_i}

        #将选中的parts添加到@target_parts的尾部，忽略掉已有的
        Part.find(params[:source_parts]).each do |s_p|
          #modify start by chenxp #使得CP可以由相同的part组成，如2个EP1
          #@target_parts << s_p unless @target_parts.include? s_p
          @target_parts << s_p
          #modify end
        end
      end
    end

    if params[:commit] == "←"    #把右边选中的part删除掉

      unless params[:target_parts_id].blank?
        #读取已有的part的id
        array_target_parts_id = params[:target_parts_id].split(",")
        unless params[:target_parts].blank?
          #删除选中的part的id
          #params[:target_parts]类似 [1,4] ,前一个是partid，后一个是下标，下面执行后，删除array_target_parts_id[4]的元素
          array_target_parts_id.delete_at((params[:target_parts].split(",").last.delete "]").to_i)
        end
        array_target_parts_id.collect! { |p_id| p_id.to_i}
        array_target_parts_id.each do |id|   #这样做得到的part顺序不会乱掉
          @target_parts << Part.find(id)
        end
      end
    end

    if params[:commit] == "↑" || params[:commit] == "↓"   #将右边选中的part向上或下移动

      #读取已有的part，并存入到实例变量@target_parts中
      unless params[:target_parts_id].blank?
        array_target_parts_id = params[:target_parts_id].split(",")
        unless params[:target_parts].blank?
          #把选中的part向上或向下移动一个位置
          if params[:commit] == "↑"
            move_step = -1
          else
            move_step = 1
          end

          index = (params[:target_parts].split(",").last.delete "]").to_i
          move_element_of_array array_target_parts_id, index, index+move_step
          #保持选中part的选中状态
          temp_arr =
          i = index + move_step
          true_index = i > -1 && i < array_target_parts_id.size ? i : i < 0 ? 0 : array_target_parts_id.size - 1
          @selected = "#{params[:target_parts].split(",").first},#{true_index}]"
        end
        array_target_parts_id.collect! { |p_id| p_id.to_i}
        array_target_parts_id.each do |id|   #这样做,得到的part顺序不会乱掉
          @target_parts << Part.find(id)
        end
      end
    end

    #将@target_parts的每个part的id组成字符串保存到@target_parts_ids中
    @target_parts_ids = @target_parts.collect{ |t_p| t_p.id }.join(",")
    render 'change_target_parts.js.erb'
  end

  def show
    begin
    @part = Part.find(params[:id])
    rescue
      redirect_to parts_path
      return
    end
    @parameters = @part.parameters
    if @part.partclass.name.eql? "CP"
      @cp_tree_html = generate_tree_html @part.id
    end
  end

end
