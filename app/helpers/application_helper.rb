module ApplicationHelper
  def full_url(url)
    url.starts_with?('http://') ? url : "http://#{url}"
  end

  def short_date(dt)
    if logged_in? && !current_user.timezone.blank?
      dt = dt.in_time_zone(current_user.timezone)
    end
    dt.strftime('%b %d, %H:%M %Z')
  end

  def category_list
    Category.all order: 'name'
  end
end
