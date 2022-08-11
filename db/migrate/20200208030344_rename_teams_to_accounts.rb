class RenameTeamsToAccounts < ActiveRecord::Migration[6.0]
  def change
    if table_exists? :teams
      rename_column :team_members, :team_id, :account_id
      rename_column :team_invitations, :team_id, :account_id

      # Rename any team_id columns for your models here
      # Delete this exception when you're finished
      raise StandardError, "To upgrade your Jumpstart Pro version to support Multitenancy, we've renamed Teams to Accounts. You'll need to edit this migration to rename the 'team_id' column on your models to 'account_id'."

      # rubocop:disable Lint/UnreachableCode
      rename_table :teams, :accounts
      rename_table :team_members, :account_users
      rename_table :team_invitations, :account_invitations
      # rubocop:enable Lint/UnreachableCode
    end
  end
end
