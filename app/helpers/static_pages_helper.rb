module StaticPagesHelper
  def static_page(page)
    url_for(controller: :static_pages, action: page)
  end
end
