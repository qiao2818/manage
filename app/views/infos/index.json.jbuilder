json.array!(@infos) do |info|
  json.extract! info, :id, :user_id, :money, :date, :address
  json.url info_url(info, format: :json)
end
