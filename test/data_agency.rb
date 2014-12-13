#使用spreadsheet读写xls文件，xlsx需另存为xls格式。
book = Spreadsheet.open 'agency_info.xls';nil
sheet_count = book.worksheets.count

#指定xls文件中需要读取的sheet名。
sheet_test = book.worksheet 'original'

#初始化一个数组，作为最后结果的对象。
arr = []

email = /[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+/
phone = /(\d{11})|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$/

sheet_test.each 1 do |row|
  #category_flag为0表示没有此key
  hash = {}
  content = row[1]

  email_result = email.match(content)
  if(!email_result.nil?)
    if(email_result.length > 0)
      hash["email"] = email_result[0]
    else
      hash["email"] = "email为空"
    end
  else
    hash["email"] = "email为空"
  end

  tel_result = phone.match(content)
  if(!tel_result.nil?)
    if(tel_result.length > 0)
      hash["phone"] = tel_result[0]
    else
      hash["phone"] = "手机号码空"
    end
  else
    hash["phone"] = "手机号码空"
  end

  arr << hash
end;nil