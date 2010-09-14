class AboutController < ApplicationController
  before_filter :require_user, :only => []
end

