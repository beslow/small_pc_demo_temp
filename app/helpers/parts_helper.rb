module PartsHelper

  def init_new_part_page
    @properties = Property.all
    @property_default_id = 18
  end

  def init_combo_part_page
    @properties = Property.all
    @property_default_id = 18
    @source_parts = Part.all
    @target_parts = Array.new
    @target_parts << Part.new(id: -1, name: "")
  end

  def create_ep
    #初始化属性列表与默认值
    init_new_part_page

    #新建一个part，并根据表单传值赋值，
    part = Part.new
    part.property_id = params[:property]
    part.name = params[:name]
    part.description = params[:description]
    part.content = params[:content]
    part.company_id = 1
    part.partclass_id = 1                     #EP
    part.type_id = 1                          #文字列

    #识别番号，查找（公司、属性约束后）识别番号最大值，没有的话默认为1，查找到的话 +1
    max_classify_id = Part.where(company_id: 1, property_id: params[:property]).maximum("classify_id")
    part.classify_id = max_classify_id.blank? ? 1 : max_classify_id + 1

    #保存表单错误信息，为后面作为flash[:xxxx]的值
    errors_messages = Array.new
    unless params[:params].blank?     #判断是否有parameter

      #用表单传值来构造parameters数组，part_id默认为1， 后面会改动
      parameters = Array.new
      params[:params][:name].count.times do |i|
        parameters << Parameter.new(part_id: 1, name: params[:params][:name][i.to_s],
                                    description: params[:params][:description][i.to_s])
      end

      #对parameters逐个检查合法性，不合法的话，保存错误信息到errors_messages
      parameters.each do |parameter|
        errors_messages << parameter.errors.full_messages.join("") unless parameter.valid?
      end

    end
    part_is_valid = part.valid?
    unless errors_messages.count == 0 && part_is_valid    #判断parameters和part是否都合法，有不合法的话，跳转并显示非法信息
      errors_messages.concat(part.errors.full_messages)
      flash.now[:danger] = errors_messages.join("")
      render new_part_path
      return false
    end

    part.save
    unless params[:params].blank?     #判断是否有parameter
      parameters.each do |parameter|
        parameter.part_id = part.id   #通过part_id关联part和parameters
        parameter.save
      end
    end
    flash[:success] = "EP's created successfully!"
    true
  end

  def create_cp

  end

  def move_element_of_array arr, from, to
    return false if arr.blank? || from<0 || from>=arr.size || to<0 || to>=arr.size || from==to
    temp = arr[from]
    arr[from] = arr[to]
    arr[to] = temp
  end
end
