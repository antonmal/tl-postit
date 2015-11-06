module ApplicationHelper
  def full_url(url)
    url.starts_with?('http://') ? url : "http://#{url}"
  end

  def categories_list
    Category.all order: 'name'
  end
end
