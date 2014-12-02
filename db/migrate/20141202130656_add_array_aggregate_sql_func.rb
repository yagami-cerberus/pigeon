class AddArrayAggregateSqlFunc < ActiveRecord::Migration
  def up
    execute <<-eos
CREATE AGGREGATE array_agg_mult (anyarray)  (
    SFUNC     = array_cat,
    STYPE     = anyarray,
    INITCOND  = '{}'
);
eos
  end

  def down
    execute 'DROP AGGREGATE array_agg_mult (anyarray)'
  end
end
