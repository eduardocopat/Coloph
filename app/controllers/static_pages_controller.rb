class StaticPagesController < ApplicationController
# http://stackoverflow.com/questions/4479233/static-pages-in-ruby-on-rails
  def features
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def bug_report
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def help
    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
