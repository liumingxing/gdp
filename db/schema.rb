# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 30) do

  create_table "area", :force => true do |t|
    t.string   "text",       :limit => 100, :null => false
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "budget_file", :force => true do |t|
    t.integer  "project_id"
    t.integer  "budget_id"
    t.integer  "budget_type"
    t.string   "path",        :limit => 300
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "company", :force => true do |t|
    t.string   "name",            :limit => 100
    t.string   "alias",           :limit => 100
    t.string   "company_type",    :limit => 100
    t.string   "area",            :limit => 20
    t.string   "fax",             :limit => 100
    t.string   "homepage",        :limit => 200
    t.float    "register_fund"
    t.string   "post_code",       :limit => 20
    t.string   "grade",           :limit => 100
    t.string   "business_number", :limit => 100
    t.string   "address",         :limit => 200
    t.string   "linker",          :limit => 20
    t.string   "telephone",       :limit => 20
    t.text     "desc"
    t.boolean  "is_delete"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contract", :force => true do |t|
    t.integer "category_id"
    t.integer "project_id"
    t.string  "name",              :limit => 200
    t.date    "begintime"
    t.date    "endtime"
    t.string  "contracttype",      :limit => 20
    t.string  "paymethod",         :limit => 20
    t.string  "contractscope",     :limit => 200
    t.integer "iscontract",                                                      :default => 1
    t.decimal "contract_amount",                  :precision => 15, :scale => 4, :default => 0.0
    t.decimal "change_amount",                    :precision => 15, :scale => 4, :default => 0.0
    t.decimal "clearing_amount",                  :precision => 15, :scale => 4, :default => 0.0
    t.decimal "pay_amount",                       :precision => 15, :scale => 4, :default => 0.0
    t.float   "pay_rate"
    t.decimal "detention_amount",                 :precision => 15, :scale => 4, :default => 0.0
    t.decimal "warranty_amount",                  :precision => 15, :scale => 4, :default => 0.0
    t.decimal "current_payamount",                :precision => 15, :scale => 4, :default => 0.0
    t.decimal "payment",                          :precision => 15, :scale => 4, :default => 0.0
    t.decimal "current_payment",                  :precision => 15, :scale => 4, :default => 0.0
    t.decimal "clearing_finished",                :precision => 15, :scale => 4, :default => 0.0
    t.decimal "stop_pay_amount",                  :precision => 15, :scale => 4, :default => 0.0
    t.decimal "total_complete",                   :precision => 15, :scale => 4, :default => 0.0
    t.decimal "target_amount",                    :precision => 15, :scale => 4, :default => 0.0
    t.string  "cost_source",       :limit => 100
    t.string  "company_name",      :limit => 100
    t.text    "memo"
  end

  create_table "contract_file", :force => true do |t|
    t.integer  "contract_id"
    t.string   "path",        :limit => 100
    t.datetime "created_at"
  end

  create_table "contract_payplan", :force => true do |t|
    t.integer  "contract_id"
    t.integer  "year"
    t.integer  "month"
    t.decimal  "plan_amount",  :precision => 15, :scale => 2
    t.decimal  "audit_amount", :precision => 15, :scale => 2
    t.decimal  "pay_amount",   :precision => 15, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contract_template", :force => true do |t|
    t.string "name", :limit => 100
  end

  create_table "contract_template_node", :force => true do |t|
    t.integer "template_id"
    t.string  "name",        :limit => 100
    t.integer "parent_id"
    t.integer "itemtype"
    t.float   "position"
    t.string  "tmpid",       :limit => 100
    t.string  "desc",        :limit => 100
  end

  create_table "contract_tree", :force => true do |t|
    t.integer "hygh_id"
    t.integer "parent_id"
    t.integer "project_id"
    t.string  "name",       :limit => 100
    t.string  "treetype",   :limit => 100
    t.integer "position"
  end

  create_table "contract_user", :id => false, :force => true do |t|
    t.integer "contract_id"
    t.integer "user_id"
  end

  create_table "department", :force => true do |t|
    t.string  "name",          :limit => 100
    t.integer "parent_id"
    t.integer "position"
    t.string  "desc",          :limit => 200
    t.integer "leader_id"
    t.integer "parent_leader"
    t.string  "phone",         :limit => 100
    t.string  "fax",           :limit => 100
  end

  create_table "dictionary", :force => true do |t|
    t.string   "name",       :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dictionary_item", :force => true do |t|
    t.integer  "dictionary_id"
    t.string   "name",          :limit => 100
    t.string   "code",          :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "doc", :force => true do |t|
    t.integer  "project_id"
    t.string   "doc_type",    :limit => 100
    t.integer  "contract_id"
    t.string   "name",        :limit => 100
    t.string   "path",        :limit => 300
    t.integer  "user_id"
    t.datetime "created_at"
  end

  create_table "hygh", :force => true do |t|
    t.integer "project_id"
    t.string  "name",          :limit => 100
    t.integer "parent_id"
    t.string  "sn",            :limit => 100
    t.integer "fzr"
    t.decimal "mbcb",                         :precision => 15, :scale => 2
    t.decimal "nkcb",                         :precision => 15, :scale => 2
    t.integer "isht"
    t.integer "iszb"
    t.string  "contractscope", :limit => 100
    t.integer "itemtype"
    t.float   "position"
    t.string  "tmpid",         :limit => 100
  end

  create_table "hygh_unit", :force => true do |t|
    t.integer "hygh_id"
    t.integer "budget_id"
    t.string  "name",      :limit => 100
    t.decimal "cost",                     :precision => 15, :scale => 2
  end

  create_table "lmx_aabb", :force => true do |t|
    t.integer  "user_id"
    t.integer  "flow_id"
    t.integer  "next_user_id"
    t.integer  "A1"
    t.boolean  "B1"
    t.integer  "C1"
    t.integer  "D1"
    t.integer  "A2"
    t.integer  "B2"
    t.integer  "C2"
    t.integer  "D2"
    t.integer  "A3"
    t.integer  "B3"
    t.integer  "C3"
    t.integer  "D3"
    t.integer  "A4"
    t.integer  "B4"
    t.integer  "C4"
    t.integer  "D4"
    t.integer  "A5"
    t.integer  "B5"
    t.integer  "C5"
    t.integer  "D5"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lmx_form", :force => true do |t|
    t.string   "code",       :limit => 100
    t.string   "name",       :limit => 100
    t.string   "table",      :limit => 100
    t.string   "form_type",  :limit => 100
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lmx_qb", :force => true do |t|
    t.integer  "user_id"
    t.integer  "flow_id"
    t.integer  "next_user_id"
    t.text     "A3"
    t.text     "A5"
    t.text     "A7"
    t.string   "B8"
    t.string   "B10"
    t.string   "B11"
    t.string   "F11"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lmx_zcfz", :force => true do |t|
    t.integer  "user_id"
    t.integer  "flow_id"
    t.integer  "next_user_id"
    t.decimal  "B3",           :precision => 15, :scale => 3
    t.decimal  "C3",           :precision => 15, :scale => 3
    t.decimal  "E3",           :precision => 15, :scale => 3
    t.decimal  "F3",           :precision => 15, :scale => 3
    t.decimal  "B4",           :precision => 15, :scale => 3
    t.decimal  "C4",           :precision => 15, :scale => 3
    t.decimal  "E4",           :precision => 15, :scale => 3
    t.decimal  "F4",           :precision => 15, :scale => 3
    t.decimal  "B5",           :precision => 15, :scale => 3
    t.decimal  "C5",           :precision => 15, :scale => 3
    t.decimal  "E5",           :precision => 15, :scale => 3
    t.decimal  "F5",           :precision => 15, :scale => 3
    t.decimal  "B6",           :precision => 15, :scale => 3
    t.decimal  "C6",           :precision => 15, :scale => 3
    t.decimal  "E6",           :precision => 15, :scale => 3
    t.decimal  "F6",           :precision => 15, :scale => 3
    t.decimal  "B7",           :precision => 15, :scale => 3
    t.decimal  "C7",           :precision => 15, :scale => 3
    t.decimal  "E7",           :precision => 15, :scale => 3
    t.decimal  "F7",           :precision => 15, :scale => 3
    t.decimal  "B8",           :precision => 15, :scale => 3
    t.decimal  "C8",           :precision => 15, :scale => 3
    t.decimal  "E8",           :precision => 15, :scale => 3
    t.decimal  "F8",           :precision => 15, :scale => 3
    t.decimal  "B9",           :precision => 15, :scale => 3
    t.decimal  "C9",           :precision => 15, :scale => 3
    t.decimal  "E9",           :precision => 15, :scale => 3
    t.decimal  "F9",           :precision => 15, :scale => 3
    t.decimal  "B10",          :precision => 15, :scale => 3
    t.decimal  "C10",          :precision => 15, :scale => 3
    t.decimal  "E10",          :precision => 15, :scale => 3
    t.decimal  "F10",          :precision => 15, :scale => 3
    t.decimal  "B11",          :precision => 15, :scale => 3
    t.decimal  "C11",          :precision => 15, :scale => 3
    t.decimal  "E11",          :precision => 15, :scale => 3
    t.decimal  "F11",          :precision => 15, :scale => 3
    t.decimal  "B12",          :precision => 15, :scale => 3
    t.decimal  "C12",          :precision => 15, :scale => 3
    t.decimal  "E12",          :precision => 15, :scale => 3
    t.decimal  "F12",          :precision => 15, :scale => 3
    t.decimal  "B13",          :precision => 15, :scale => 3
    t.decimal  "C13",          :precision => 15, :scale => 3
    t.decimal  "E13",          :precision => 15, :scale => 3
    t.decimal  "F13",          :precision => 15, :scale => 3
    t.decimal  "B14",          :precision => 15, :scale => 3
    t.decimal  "C14",          :precision => 15, :scale => 3
    t.decimal  "E14",          :precision => 15, :scale => 3
    t.decimal  "F14",          :precision => 15, :scale => 3
    t.decimal  "E15",          :precision => 15, :scale => 3
    t.decimal  "F15",          :precision => 15, :scale => 3
    t.decimal  "B16",          :precision => 15, :scale => 3
    t.decimal  "C16",          :precision => 15, :scale => 3
    t.decimal  "B17",          :precision => 15, :scale => 3
    t.decimal  "C17",          :precision => 15, :scale => 3
    t.decimal  "E17",          :precision => 15, :scale => 3
    t.decimal  "F17",          :precision => 15, :scale => 3
    t.decimal  "B18",          :precision => 15, :scale => 3
    t.decimal  "C18",          :precision => 15, :scale => 3
    t.decimal  "E18",          :precision => 15, :scale => 3
    t.decimal  "F18",          :precision => 15, :scale => 3
    t.decimal  "B19",          :precision => 15, :scale => 3
    t.decimal  "C19",          :precision => 15, :scale => 3
    t.decimal  "E19",          :precision => 15, :scale => 3
    t.decimal  "F19",          :precision => 15, :scale => 3
    t.decimal  "B20",          :precision => 15, :scale => 3
    t.decimal  "C20",          :precision => 15, :scale => 3
    t.decimal  "E20",          :precision => 15, :scale => 3
    t.decimal  "F20",          :precision => 15, :scale => 3
    t.decimal  "B21",          :precision => 15, :scale => 3
    t.decimal  "C21",          :precision => 15, :scale => 3
    t.decimal  "E21",          :precision => 15, :scale => 3
    t.decimal  "F21",          :precision => 15, :scale => 3
    t.decimal  "B22",          :precision => 15, :scale => 3
    t.decimal  "C22",          :precision => 15, :scale => 3
    t.decimal  "E22",          :precision => 15, :scale => 3
    t.decimal  "F22",          :precision => 15, :scale => 3
    t.decimal  "B23",          :precision => 15, :scale => 3
    t.decimal  "C23",          :precision => 15, :scale => 3
    t.decimal  "E23",          :precision => 15, :scale => 3
    t.decimal  "F23",          :precision => 15, :scale => 3
    t.decimal  "B24",          :precision => 15, :scale => 3
    t.decimal  "C24",          :precision => 15, :scale => 3
    t.decimal  "E24",          :precision => 15, :scale => 3
    t.decimal  "F24",          :precision => 15, :scale => 3
    t.decimal  "B25",          :precision => 15, :scale => 3
    t.decimal  "C25",          :precision => 15, :scale => 3
    t.decimal  "E25",          :precision => 15, :scale => 3
    t.decimal  "F25",          :precision => 15, :scale => 3
    t.decimal  "B26",          :precision => 15, :scale => 3
    t.decimal  "C26",          :precision => 15, :scale => 3
    t.decimal  "B27",          :precision => 15, :scale => 3
    t.decimal  "C27",          :precision => 15, :scale => 3
    t.decimal  "E27",          :precision => 15, :scale => 3
    t.decimal  "F27",          :precision => 15, :scale => 3
    t.decimal  "B28",          :precision => 15, :scale => 3
    t.decimal  "C28",          :precision => 15, :scale => 3
    t.decimal  "E28",          :precision => 15, :scale => 3
    t.decimal  "F28",          :precision => 15, :scale => 3
    t.decimal  "B29",          :precision => 15, :scale => 3
    t.decimal  "C29",          :precision => 15, :scale => 3
    t.decimal  "E29",          :precision => 15, :scale => 3
    t.decimal  "F29",          :precision => 15, :scale => 3
    t.decimal  "B30",          :precision => 15, :scale => 3
    t.decimal  "C30",          :precision => 15, :scale => 3
    t.decimal  "E30",          :precision => 15, :scale => 3
    t.decimal  "F30",          :precision => 15, :scale => 3
    t.decimal  "B31",          :precision => 15, :scale => 3
    t.decimal  "C31",          :precision => 15, :scale => 3
    t.decimal  "E31",          :precision => 15, :scale => 3
    t.decimal  "F31",          :precision => 15, :scale => 3
    t.decimal  "B32",          :precision => 15, :scale => 3
    t.decimal  "C32",          :precision => 15, :scale => 3
    t.decimal  "E32",          :precision => 15, :scale => 3
    t.decimal  "F32",          :precision => 15, :scale => 3
    t.decimal  "B33",          :precision => 15, :scale => 3
    t.decimal  "C33",          :precision => 15, :scale => 3
    t.decimal  "B34",          :precision => 15, :scale => 3
    t.decimal  "C34",          :precision => 15, :scale => 3
    t.decimal  "E34",          :precision => 15, :scale => 3
    t.decimal  "F34",          :precision => 15, :scale => 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log", :force => true do |t|
    t.string   "username",    :limit => 100
    t.string   "description", :limit => 200
    t.string   "url",         :limit => 100
    t.string   "ip",          :limit => 100
    t.datetime "created_at"
  end

  create_table "logfilter", :force => true do |t|
    t.string   "controller", :limit => 100
    t.string   "action",     :limit => 100
    t.string   "desc",       :limit => 200
    t.integer  "log",                       :default => 1, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu", :force => true do |t|
    t.string   "menutype",   :limit => 100
    t.string   "text",       :limit => 100
    t.string   "url",        :limit => 100
    t.integer  "list_right"
    t.integer  "edit_right"
    t.integer  "parent_id"
    t.integer  "position"
    t.integer  "hide"
    t.integer  "blank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message", :force => true do |t|
    t.integer  "user_id"
    t.string   "sender",     :limit => 100
    t.string   "title",      :limit => 100
    t.text     "text"
    t.integer  "isread",                    :default => 0
    t.datetime "created_at"
  end

  create_table "notice", :force => true do |t|
    t.string   "title",        :limit => 200
    t.text     "content"
    t.integer  "user_id"
    t.datetime "publish_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pbs", :force => true do |t|
    t.string  "name",    :limit => 100
    t.string  "pbstype", :limit => 10
    t.decimal "price",                  :precision => 15, :scale => 2
    t.string  "basis",   :limit => 10
    t.string  "unit",    :limit => 10
    t.string  "desc",    :limit => 200
  end

  create_table "pbs_node", :force => true do |t|
    t.integer "pbs_id"
    t.integer "template_id"
    t.string  "basis",       :limit => 10
    t.decimal "price",                      :precision => 15, :scale => 2
    t.string  "unit",        :limit => 10
    t.string  "desc",        :limit => 200
  end

  create_table "pbs_property", :force => true do |t|
    t.integer "pbs_id"
    t.string  "name",       :limit => 100
    t.string  "input_mode", :limit => 100
    t.string  "datatype",   :limit => 10
    t.integer "need"
    t.string  "options",    :limit => 200
    t.string  "unit",       :limit => 20
    t.integer "position"
  end

  create_table "pbs_template", :force => true do |t|
    t.string  "name",      :limit => 100
    t.integer "parent_id"
    t.string  "feetype",   :limit => 10
    t.string  "feescope",  :limit => 200
    t.integer "position",                 :default => 0
    t.string  "tmpid",     :limit => 100
  end

  create_table "project", :force => true do |t|
    t.integer  "position"
    t.string   "name",        :limit => 100,                                :null => false
    t.integer  "fzr_id"
    t.string   "gcdd",        :limit => 100
    t.string   "jzlx",        :limit => 100
    t.string   "jglx",        :limit => 100
    t.string   "jzxz",        :limit => 100
    t.string   "zxbz",        :limit => 100
    t.string   "wmxs",        :limit => 100
    t.string   "jcxs",        :limit => 100
    t.string   "wqbw",        :limit => 100
    t.string   "wqzs",        :limit => 100
    t.string   "wclx",        :limit => 100
    t.integer  "jzmj"
    t.integer  "dsmj"
    t.integer  "dxmj"
    t.integer  "zdmj"
    t.integer  "zcs"
    t.integer  "dscs"
    t.integer  "dxcs"
    t.float    "bzcg"
    t.string   "lxpw",        :limit => 100
    t.decimal  "gszj",                       :precision => 15, :scale => 2
    t.string   "jsdw",        :limit => 100
    t.string   "sjdw",        :limit => 100
    t.string   "jldw",        :limit => 100
    t.text     "zhms"
    t.string   "establisher", :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_budget", :force => true do |t|
    t.integer  "project_id"
    t.integer  "tzgh_id"
    t.integer  "position",                                                  :default => 0
    t.integer  "pbs_id"
    t.integer  "pbs_node_id"
    t.integer  "version_id"
    t.string   "name",        :limit => 100,                                               :null => false
    t.string   "feetype",     :limit => 100
    t.integer  "parent_id"
    t.string   "budgettype",  :limit => 10
    t.decimal  "jzgcf",                      :precision => 15, :scale => 2
    t.decimal  "azgcf",                      :precision => 15, :scale => 2
    t.decimal  "sbgzf",                      :precision => 15, :scale => 2
    t.decimal  "qtfy",                       :precision => 15, :scale => 2
    t.string   "unit",        :limit => 10
    t.decimal  "num",                        :precision => 15, :scale => 2
    t.decimal  "jjzb",                       :precision => 15, :scale => 2
    t.string   "state",       :limit => 20
    t.integer  "fzr"
    t.integer  "shr"
    t.datetime "jhsj"
    t.datetime "wcsj"
    t.string   "shyj",        :limit => 100
    t.string   "desc",        :limit => 200
    t.string   "properties",  :limit => 200
    t.string   "tmpid",       :limit => 200
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_budget_unit", :force => true do |t|
    t.integer  "project_id"
    t.integer  "budget_item_id"
    t.string   "name",           :limit => 100
    t.string   "basis",          :limit => 100
    t.string   "unit",           :limit => 10
    t.integer  "num"
    t.decimal  "price",                         :precision => 15, :scale => 2
    t.decimal  "rate",                          :precision => 15, :scale => 2, :default => 1.0
    t.string   "feecode",        :limit => 100
    t.string   "feetype",        :limit => 10
    t.string   "desc",           :limit => 200
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_right", :id => false, :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "right_type", :limit => 100
    t.string   "right",      :limit => 100
    t.datetime "created_at"
  end

  create_table "project_tzgh", :force => true do |t|
    t.integer  "project_id"
    t.integer  "position",                        :default => 0
    t.integer  "pbs_id"
    t.integer  "pbs_node_id"
    t.string   "name",             :limit => 100,                :null => false
    t.integer  "parent_id"
    t.string   "feetype",          :limit => 10
    t.string   "feescope",         :limit => 100
    t.integer  "template_node_id"
    t.string   "tmpid",            :limit => 200
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_user", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
  end

  create_table "project_version", :force => true do |t|
    t.integer  "project_id"
    t.string   "budgettype", :limit => 10
    t.string   "text",       :limit => 100, :null => false
    t.integer  "current"
    t.string   "creator",    :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "right", :force => true do |t|
    t.string   "name",        :limit => 100
    t.string   "description", :limit => 100
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "right_role", :id => false, :force => true do |t|
    t.integer  "role_id"
    t.integer  "right_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role", :force => true do |t|
    t.string   "name",        :limit => 100
    t.string   "description", :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role_user", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "system_config", :force => true do |t|
    t.string  "title",        :limit => 100
    t.integer "visitedtimes"
    t.string  "logo",         :limit => 200
    t.string  "address",      :limit => 200
    t.string  "telephone",    :limit => 200
  end

  create_table "tztemplate", :force => true do |t|
    t.string "name", :limit => 100
  end

  create_table "tztemplate_node", :force => true do |t|
    t.string  "name",        :limit => 100
    t.integer "template_id"
    t.integer "parent_id"
    t.string  "feetype",     :limit => 10
    t.string  "desc",        :limit => 200
    t.integer "position"
  end

  create_table "user", :force => true do |t|
    t.string   "login",           :limit => 100, :null => false
    t.string   "name",            :limit => 100
    t.string   "password",        :limit => 100
    t.integer  "company_id"
    t.integer  "department_id"
    t.string   "style",           :limit => 100
    t.integer  "resign"
    t.datetime "last_login_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workflow", :force => true do |t|
    t.string   "name",         :limit => 100
    t.integer  "formtable_id"
    t.string   "flow_type",    :limit => 100
    t.text     "content"
    t.integer  "position"
    t.boolean  "ischild"
    t.boolean  "has_bigtext"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workflow_file", :force => true do |t|
    t.string   "flow_id",    :limit => 100
    t.integer  "form_id"
    t.string   "path",       :limit => 200
    t.string   "uploader",   :limit => 100
    t.datetime "created_at"
  end

  create_table "workflow_formback", :force => true do |t|
    t.integer  "flow_id"
    t.integer  "form_id"
    t.string   "state",      :limit => 200
    t.string   "user",       :limit => 100
    t.datetime "created_at"
  end

  create_table "workflow_history", :force => true do |t|
    t.integer  "user_id"
    t.integer  "flow_id"
    t.integer  "form_id"
    t.datetime "process_time"
    t.string   "memo",         :limit => 400
    t.string   "state_name",   :limit => 200
    t.string   "point",        :limit => 400
  end

  create_table "workflow_interface", :force => true do |t|
    t.integer  "flow_id"
    t.string   "state_name", :limit => 100
    t.integer  "form_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workflow_qj", :force => true do |t|
    t.integer  "user_id"
    t.integer  "flow_id"
    t.string   "next_user_ids", :limit => 200
    t.text     "_content"
    t.string   "_state",        :limit => 30
    t.integer  "A1"
    t.integer  "B1"
    t.integer  "C1"
    t.integer  "D1"
    t.integer  "A2"
    t.integer  "B2"
    t.integer  "C2"
    t.integer  "D2"
    t.integer  "A3"
    t.integer  "B3"
    t.integer  "C3"
    t.integer  "D3"
    t.integer  "A4"
    t.integer  "B4"
    t.integer  "C4"
    t.integer  "D4"
    t.integer  "A5"
    t.integer  "B5"
    t.integer  "C5"
    t.integer  "D5"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workflow_select", :force => true do |t|
    t.integer  "user_id"
    t.integer  "flow_id"
    t.integer  "form_id"
    t.string   "state",      :limit => 100
    t.datetime "created_at"
  end

  create_table "workflow_yuezhi", :force => true do |t|
    t.integer  "flow_id"
    t.integer  "form_id"
    t.integer  "user_id"
    t.string   "state",      :limit => 200
    t.string   "users",      :limit => 100
    t.text     "memo"
    t.string   "creator",    :limit => 100
    t.datetime "created_at"
  end

  create_table "workflow_zcfz", :force => true do |t|
    t.integer  "user_id"
    t.integer  "flow_id"
    t.string   "next_user_ids", :limit => 200
    t.text     "_content"
    t.string   "_state",        :limit => 30
    t.decimal  "B3",                           :precision => 15, :scale => 3
    t.decimal  "C3",                           :precision => 15, :scale => 3
    t.decimal  "E3",                           :precision => 15, :scale => 3
    t.decimal  "F3",                           :precision => 15, :scale => 3
    t.decimal  "B4",                           :precision => 15, :scale => 3
    t.decimal  "C4",                           :precision => 15, :scale => 3
    t.decimal  "E4",                           :precision => 15, :scale => 3
    t.decimal  "F4",                           :precision => 15, :scale => 3
    t.decimal  "B5",                           :precision => 15, :scale => 3
    t.decimal  "C5",                           :precision => 15, :scale => 3
    t.decimal  "E5",                           :precision => 15, :scale => 3
    t.decimal  "F5",                           :precision => 15, :scale => 3
    t.decimal  "B6",                           :precision => 15, :scale => 3
    t.decimal  "C6",                           :precision => 15, :scale => 3
    t.decimal  "E6",                           :precision => 15, :scale => 3
    t.decimal  "F6",                           :precision => 15, :scale => 3
    t.decimal  "B7",                           :precision => 15, :scale => 3
    t.decimal  "C7",                           :precision => 15, :scale => 3
    t.decimal  "E7",                           :precision => 15, :scale => 3
    t.decimal  "F7",                           :precision => 15, :scale => 3
    t.decimal  "B8",                           :precision => 15, :scale => 3
    t.decimal  "C8",                           :precision => 15, :scale => 3
    t.decimal  "E8",                           :precision => 15, :scale => 3
    t.decimal  "F8",                           :precision => 15, :scale => 3
    t.decimal  "B9",                           :precision => 15, :scale => 3
    t.decimal  "C9",                           :precision => 15, :scale => 3
    t.decimal  "E9",                           :precision => 15, :scale => 3
    t.decimal  "F9",                           :precision => 15, :scale => 3
    t.decimal  "B10",                          :precision => 15, :scale => 3
    t.decimal  "C10",                          :precision => 15, :scale => 3
    t.decimal  "E10",                          :precision => 15, :scale => 3
    t.decimal  "F10",                          :precision => 15, :scale => 3
    t.decimal  "B11",                          :precision => 15, :scale => 3
    t.decimal  "C11",                          :precision => 15, :scale => 3
    t.decimal  "E11",                          :precision => 15, :scale => 3
    t.decimal  "F11",                          :precision => 15, :scale => 3
    t.decimal  "B12",                          :precision => 15, :scale => 3
    t.decimal  "C12",                          :precision => 15, :scale => 3
    t.decimal  "E12",                          :precision => 15, :scale => 3
    t.decimal  "F12",                          :precision => 15, :scale => 3
    t.decimal  "B13",                          :precision => 15, :scale => 3
    t.decimal  "C13",                          :precision => 15, :scale => 3
    t.decimal  "E13",                          :precision => 15, :scale => 3
    t.decimal  "F13",                          :precision => 15, :scale => 3
    t.decimal  "B14",                          :precision => 15, :scale => 3
    t.decimal  "C14",                          :precision => 15, :scale => 3
    t.decimal  "E14",                          :precision => 15, :scale => 3
    t.decimal  "F14",                          :precision => 15, :scale => 3
    t.decimal  "E15",                          :precision => 15, :scale => 3
    t.decimal  "F15",                          :precision => 15, :scale => 3
    t.decimal  "B16",                          :precision => 15, :scale => 3
    t.decimal  "C16",                          :precision => 15, :scale => 3
    t.decimal  "B17",                          :precision => 15, :scale => 3
    t.decimal  "C17",                          :precision => 15, :scale => 3
    t.decimal  "E17",                          :precision => 15, :scale => 3
    t.decimal  "F17",                          :precision => 15, :scale => 3
    t.decimal  "B18",                          :precision => 15, :scale => 3
    t.decimal  "C18",                          :precision => 15, :scale => 3
    t.decimal  "E18",                          :precision => 15, :scale => 3
    t.decimal  "F18",                          :precision => 15, :scale => 3
    t.decimal  "B19",                          :precision => 15, :scale => 3
    t.decimal  "C19",                          :precision => 15, :scale => 3
    t.decimal  "E19",                          :precision => 15, :scale => 3
    t.decimal  "F19",                          :precision => 15, :scale => 3
    t.decimal  "B20",                          :precision => 15, :scale => 3
    t.decimal  "C20",                          :precision => 15, :scale => 3
    t.decimal  "E20",                          :precision => 15, :scale => 3
    t.decimal  "F20",                          :precision => 15, :scale => 3
    t.decimal  "B21",                          :precision => 15, :scale => 3
    t.decimal  "C21",                          :precision => 15, :scale => 3
    t.decimal  "E21",                          :precision => 15, :scale => 3
    t.decimal  "F21",                          :precision => 15, :scale => 3
    t.decimal  "B22",                          :precision => 15, :scale => 3
    t.decimal  "C22",                          :precision => 15, :scale => 3
    t.decimal  "E22",                          :precision => 15, :scale => 3
    t.decimal  "F22",                          :precision => 15, :scale => 3
    t.decimal  "B23",                          :precision => 15, :scale => 3
    t.decimal  "C23",                          :precision => 15, :scale => 3
    t.decimal  "E23",                          :precision => 15, :scale => 3
    t.decimal  "F23",                          :precision => 15, :scale => 3
    t.decimal  "B24",                          :precision => 15, :scale => 3
    t.decimal  "C24",                          :precision => 15, :scale => 3
    t.decimal  "E24",                          :precision => 15, :scale => 3
    t.decimal  "F24",                          :precision => 15, :scale => 3
    t.decimal  "B25",                          :precision => 15, :scale => 3
    t.decimal  "C25",                          :precision => 15, :scale => 3
    t.decimal  "E25",                          :precision => 15, :scale => 3
    t.decimal  "F25",                          :precision => 15, :scale => 3
    t.decimal  "B26",                          :precision => 15, :scale => 3
    t.decimal  "C26",                          :precision => 15, :scale => 3
    t.decimal  "B27",                          :precision => 15, :scale => 3
    t.decimal  "C27",                          :precision => 15, :scale => 3
    t.decimal  "E27",                          :precision => 15, :scale => 3
    t.decimal  "F27",                          :precision => 15, :scale => 3
    t.decimal  "B28",                          :precision => 15, :scale => 3
    t.decimal  "C28",                          :precision => 15, :scale => 3
    t.decimal  "E28",                          :precision => 15, :scale => 3
    t.decimal  "F28",                          :precision => 15, :scale => 3
    t.decimal  "B29",                          :precision => 15, :scale => 3
    t.decimal  "C29",                          :precision => 15, :scale => 3
    t.decimal  "E29",                          :precision => 15, :scale => 3
    t.decimal  "F29",                          :precision => 15, :scale => 3
    t.decimal  "B30",                          :precision => 15, :scale => 3
    t.decimal  "C30",                          :precision => 15, :scale => 3
    t.decimal  "E30",                          :precision => 15, :scale => 3
    t.decimal  "F30",                          :precision => 15, :scale => 3
    t.decimal  "B31",                          :precision => 15, :scale => 3
    t.decimal  "C31",                          :precision => 15, :scale => 3
    t.decimal  "E31",                          :precision => 15, :scale => 3
    t.decimal  "F31",                          :precision => 15, :scale => 3
    t.decimal  "B32",                          :precision => 15, :scale => 3
    t.decimal  "C32",                          :precision => 15, :scale => 3
    t.decimal  "E32",                          :precision => 15, :scale => 3
    t.decimal  "F32",                          :precision => 15, :scale => 3
    t.decimal  "B33",                          :precision => 15, :scale => 3
    t.decimal  "C33",                          :precision => 15, :scale => 3
    t.decimal  "B34",                          :precision => 15, :scale => 3
    t.decimal  "C34",                          :precision => 15, :scale => 3
    t.decimal  "E34",                          :precision => 15, :scale => 3
    t.decimal  "F34",                          :precision => 15, :scale => 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workitem", :force => true do |t|
    t.integer  "user_id"
    t.string   "itemtype",    :limit => 100
    t.integer  "contract_id"
    t.string   "sn",          :limit => 100
    t.string   "name",        :limit => 100
    t.string   "scope",       :limit => 100
    t.decimal  "amount",                     :precision => 15, :scale => 2
    t.integer  "finished"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workitem_change", :force => true do |t|
    t.integer "workitem_id"
    t.string  "name",             :limit => 100
    t.string  "proposed_company", :limit => 100
    t.string  "change_type",      :limit => 100
    t.string  "change_reason",    :limit => 100
    t.string  "special",          :limit => 100
    t.text    "change_summary"
    t.decimal "estimate_amount",                 :precision => 15, :scale => 2
    t.date    "trial_date"
    t.decimal "trial_amount",                    :precision => 15, :scale => 2
    t.date    "validate_date"
    t.decimal "validate_amount",                 :precision => 15, :scale => 2
    t.string  "principal",        :limit => 100
    t.date    "effective_date"
    t.text    "memo"
  end

  create_table "workitem_clearing", :force => true do |t|
    t.integer "workitem_id"
    t.string  "name",            :limit => 100
    t.string  "desc",            :limit => 200
    t.date    "trial_date"
    t.decimal "trial_amount",                   :precision => 15, :scale => 2
    t.date    "clearing_date"
    t.decimal "clearing_amount",                :precision => 15, :scale => 2
    t.string  "principal",       :limit => 100
    t.text    "memo"
  end

  create_table "workitem_pay", :force => true do |t|
    t.integer "workitem_id"
    t.string  "name",                  :limit => 100
    t.decimal "pay_before_last_month",                :precision => 15, :scale => 2
    t.string  "paytype",               :limit => 100
    t.date    "pay_date"
    t.decimal "pay_amount",                           :precision => 15, :scale => 2
    t.decimal "total_pay_amount",                     :precision => 15, :scale => 2
    t.string  "principal",             :limit => 100
    t.string  "pay_reason",            :limit => 200
    t.text    "memo"
  end

  create_table "workitem_register", :force => true do |t|
    t.integer "workitem_id"
    t.string  "name",                :limit => 100
    t.string  "contracttype",        :limit => 100
    t.string  "part_a",              :limit => 100
    t.string  "part_b",              :limit => 100
    t.string  "part_c",              :limit => 100
    t.decimal "amount",                             :precision => 15, :scale => 2
    t.date    "start_date"
    t.date    "complete_date"
    t.string  "quality_standard",    :limit => 100
    t.string  "paymethod",           :limit => 100
    t.string  "advance_payment",     :limit => 100
    t.string  "progress_payment",    :limit => 100
    t.string  "balance_due",         :limit => 100
    t.string  "principal",           :limit => 100
    t.text    "comment"
    t.float   "pay_rate"
    t.decimal "stop_payment_amount",                :precision => 15, :scale => 2
    t.text    "contract_scope"
  end

  create_table "workitem_report", :force => true do |t|
    t.integer "workitem_id"
    t.string  "name",                  :limit => 100
    t.string  "desc",                  :limit => 2000
    t.date    "trial_date"
    t.decimal "pay_before_last_month",                 :precision => 15, :scale => 2
    t.decimal "trial_amount",                          :precision => 15, :scale => 2
    t.date    "validate_date"
    t.decimal "validate_amount",                       :precision => 15, :scale => 2
    t.string  "principal",             :limit => 100
    t.decimal "month_minus_amount",                    :precision => 15, :scale => 2
    t.decimal "total_complete",                        :precision => 15, :scale => 2
    t.decimal "buckle_retention",                      :precision => 15, :scale => 2
    t.decimal "advance_rebate",                        :precision => 15, :scale => 2
    t.decimal "other_charged",                         :precision => 15, :scale => 2
    t.string  "complete_rate",         :limit => 100
    t.text    "memo"
  end

  create_table "workitem_warranty", :force => true do |t|
    t.integer "workitem_id"
    t.string  "name",            :limit => 100
    t.string  "warranty_terms",  :limit => 200
    t.decimal "warranty_amount",                :precision => 15, :scale => 2
    t.string  "pay_method",      :limit => 100
    t.date    "begin_date"
    t.date    "end_date"
    t.string  "principal",       :limit => 100
    t.text    "memo"
  end

end
