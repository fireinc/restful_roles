module FireInc
  module RestfulRoles
    def self.included(klass)
      klass.extend RestfulRolesRoleMethods
      klass.extend RestfulRolesInstanceMethods
    end
    
    module RestfulRolesRoleMethods
      def has_roles(*roles)
        unless included_modules.include? RestfulRolesInstanceMethods
          class_inheritable_accessor :roles
          extend RestfulRolesClassMethods
          include RestfulRolesInstanceMethods
        end

        self.roles = roles
        
        before_save lambda{|x| x.role ||= self.roles.first}
      end
    end
    
    module RestfulRolesClassMethods
      def roles
        self.roles
      end  
    end
    
    module RestfulRolesInstanceMethods
      def after_initialize
        self.roles.each{|r| eval "def #{r}?\n\tauthorized?('#{r}')\nend"}
      end
      def authorized?(requested_role)
        self.class.roles.index(self.role) >= 
                                            self.class.roles.index(requested_role)
      end
    end
  end
end
