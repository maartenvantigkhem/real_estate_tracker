class AddPostingUrlToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :posting_url, :string
  end
end
