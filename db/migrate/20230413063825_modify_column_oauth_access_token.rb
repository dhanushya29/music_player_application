class ModifyColumnOauthAccessToken < ActiveRecord::Migration[6.0]
  def change
    change_column_null :oauth_access_tokens,:application_id, true
  end
end
