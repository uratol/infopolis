class StaticPagesController < ApplicationController
  def home

  end

  def any
    render params[:page_name]
  end
end
