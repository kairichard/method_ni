ActiveRecord::Schema.define do
 
  create_table "dummies", :force => true do |t|
    t.column "name", :string
    t.column "custom_method", :text
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end
  
end