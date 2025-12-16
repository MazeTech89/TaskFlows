# Base class for all models - inherits from ActiveRecord::Base
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
