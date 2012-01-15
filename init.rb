ActiveRecord::Base.send(:include, FireInc::RestfulRoles)
ActionController::Base.send(:include, FireInc::RestfulRolesController)
