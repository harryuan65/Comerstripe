class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :stripe_id, index: { unique: true }
      t.string :status
      t.datetime :paid_at

      t.timestamps
    end
  end
end
