class Dictionary < ActiveRecord::Base
  has_many :items, :class_name=>"DictionaryItem"
end
