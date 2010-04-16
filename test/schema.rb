ActiveRecord::Schema.define(:version => 20100413024653) do

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "original_input"
    t.string   "source_param"
  end

end