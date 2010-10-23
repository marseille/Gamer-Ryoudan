class RecentChangesController < ApplicationController
  before_filter :require_user, :only => []  
end
