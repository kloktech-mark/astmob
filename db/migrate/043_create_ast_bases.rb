class CreateAstBases < ActiveRecord::Migration
  def self.up
    create_table :ast_bases do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :ast_bases
  end
end
