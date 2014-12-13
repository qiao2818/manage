def basic_info(arr,row,category_flag,arr_index)
  list_hash = {}
  list_hash["id"] = row[1]
  list_hash["name"] = row[2]
  list_hash["img"] = row[3]
  list_hash["description"] = row[4]
  list_hash["price"] = row[5]

  if(category_flag)
    current_arr = arr[arr_index]
    list_arr = current_arr["list"]
    list_arr << list_hash
    option_extra_info(list_hash,row)
  else
    hash = {}
    hash["name"] = row[0]
    hash["list"] = []
    hash["list"] << list_hash
    option_extra_info_new(hash,row,arr)
  end
end

def option_extra_info_new(hash,row,arr)
  list_0_hash = hash["list"][0]
  list_0_hash["options"] = {}
  options_arr = row[52..55]

  options_arr.each_with_index do |option,i|
    if(!option.nil?)
      list_0_hash["options"][@title[i]] = {};
      option.split("/").each do |o|
        list_0_hash["options"][@title[i]][o] = false
      end
    end
  end

  list_0_hash["extras"] = {}
  extras_arr = row[6..51]
  extras_arr.each_with_index do |extra,i|
    if(!extra.nil? && extra.class != Float)
      list_0_hash["extras"][extra] = {}
      list_0_hash["extras"][extra]["name"] = extra;
      list_0_hash["extras"][extra]["price"] = extras_arr[i+1]
    end
  end

  arr << hash
end

def option_extra_info(list_hash,row)
  list_hash["options"] = {}
  options_arr = row[52..55]

  options_arr.each_with_index do |option,i|
    if(!option.nil?)
      list_hash["options"][@title[i]] = {}
      option.split("/").each do |o|
        list_hash["options"][@title[i]][o] = false
      end
    end
  end

  list_hash["extras"] = {}
  extras_arr = row[6..51]
  extras_arr.each_with_index do |extra,i|
    if(!extra.nil? && extra.class != Float)
      list_hash["extras"][extra] = {}
      list_hash["extras"][extra]["name"] = extra;
      list_hash["extras"][extra]["price"] = extras_arr[i+1]
    end
  end
end

###############################################

#使用spreadsheet读写xls文件，xlsx需另存为xls格式。
book = Spreadsheet.open '2.xls';nil
sheet_count = book.worksheets.count

#指定xls文件中需要读取的sheet名。
sheet_test = book.worksheet 'test'

#初始化一个数组，作为最后结果的对象。
arr = []

#读取title
title_row = sheet_test.row(1)
@title = title_row[52..55]

#跳过第一行为each 1,跳过前两行为each 2，请自行设置。
sheet_test.each 2 do |row|
  #category_flag为0表示没有此key
  arr_index = -1
  category_flag = false
  category_title = row[0]
  arr.each_with_index do |a,i|
    if(a["name"] == category_title)
      category_flag = true
      arr_index = i
    end
  end
  basic_info(arr,row,category_flag,arr_index)
end;nil


################################################

#使用spreadsheet读写xls文件，xlsx需另存为xls格式。
book = Spreadsheet.open '3.xls';nil
sheet_count = book.worksheets.count

#指定xls文件中需要读取的sheet名。
sheet_test = book.worksheet 'Food Menu-Chinese'

#初始化一个数组，作为最后结果的对象。
arr = []

#读取title
title_row = sheet_test.row(1)
@title = title_row[52..55]

#跳过第一行为each 1,跳过前两行为each 2，请自行设置。
sheet_test.each 2 do |row|
  #category_flag为0表示没有此key
  arr_index = -1
  category_flag = false
  category_title = row[0]
  arr.each_with_index do |a,i|
    if(a["name"] == category_title)
      category_flag = true
      arr_index = i
    end
  end
  basic_info(arr,row,category_flag,arr_index)
end;nil