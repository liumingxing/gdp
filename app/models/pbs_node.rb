include GridRecord
class PbsNode < ActiveRecord::Base
  belongs_to :template, :class_name=>"PbsTemplate"
end
