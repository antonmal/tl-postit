module ApplicationHelper
  def full_url(url)
    url.starts_with?('http://') ? url : "http://#{url}"
  end

  def short_date(date_str)
    date_str.to_time.strftime('%b %d, %H:%M')
  end

  def category_list
    Category.all order: 'name'
  end
end
