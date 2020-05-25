module ApplicationHelper
  def readable_date(date)
    return "[unknown]" unless date
    return date.strftime("%B %d, %Y")
  end
end
