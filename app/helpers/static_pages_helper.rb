module StaticPagesHelper
  def full_title(page_title=nil)
    base_title = 'Infopolis'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end
