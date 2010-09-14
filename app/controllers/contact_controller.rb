class ContactController < ApplicationController
  before_filter :require_user, :only => []
end
