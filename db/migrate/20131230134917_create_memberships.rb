class CreateMemberships < ActiveRecord::Migration
  def up
    create_table :memberships do |t|
      t.belongs_to :group
      t.belongs_to :user
    end
  end
end
