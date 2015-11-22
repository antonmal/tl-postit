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

  def current_url_with(**options)
    uri = URI::parse(request.original_url)
    uri_query_hash = uri.query.nil? ? {} : Hash[URI::decode_www_form(uri.query)]
    options = Hash[options.map { |k,v| [k.to_s, v.to_s] }]
    uri_query_hash.update(options)
    uri.path + '?' + URI::encode_www_form(uri_query_hash)
  end
end
