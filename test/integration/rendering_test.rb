require 'test_helper'

class RenderingTest < ActionDispatch::IntegrationTest
  test "simple get for settings pages" do
    test_paths = [
      settings_user_index_path,
      new_settings_user_path,
      edit_settings_user_path(id_for :guest_user),
      edit_settings_user_path(id_for :admin_user),

      settings_group_index_path,
      new_settings_group_path,
      edit_settings_group_path(id_for :typist_group),
      edit_settings_group_path(id_for :admin_group),

      settings_issue_statuses_path,
      new_settings_issue_status_path,
      edit_settings_issue_status_path(1),

      settings_inspection_item_index_path,
      new_settings_inspection_item_path,
      edit_settings_inspection_item_path(101),

      new_settings_inspection_item_inspection_atom_path(101),
      edit_settings_inspection_item_inspection_atom_path(101, id_for(:gene_weight_rs5443)),

      settings_inspection_bundle_index_path,
      new_settings_inspection_bundle_path,
      edit_settings_inspection_bundle_path(id_for :gene_weight_bundle)
    ]
    
    login_as "admin"
    test_paths.each do |path|
      get path
      assert_response 200
    end
  end

  test "issue list/create/update simple test" do
    login_as "typist"

    # List
    get issues_path
    assert_response 200

    # Create
    post issues_path, {
      "issue_status_id"=>"1",
      "issue" => {
        "profile_id" => "416065057",
        "issue_bundles_attributes" => {
          "725765714" => {
            "id" => "", "inspection_bundle_id" => "725765714",
            "inspection_item_ids" => ["201", "202"], "_destroy" => "false"}},
        "samples_attributes" => {
          "0" => {
            "id" => "", "no"=>"1234567890", "sample_type" => "swab", "quantity"=>"1", "_destroy" => "false"},
    }}}
    follow_redirect!
    assert_response 200
    id = controller.params[:id]
    
    put issue_path(id), {"issue" => {"profile_id" => "416065057"}}
    follow_redirect!
    assert_response 200
  end

  test "inspections list/show simple test" do
    login_as "typist"

    # Dashboard
    get issue_bundles_path
    assert_response 200

    # Search
    get search_issue_bundles_path
    assert_response 200

    # Show
    get issue_bundle_path(id_for :padding_issue_bundle1)
    assert_response 200
  end

  test "samples list simple test" do
    login_as "admin"

    # List
    get samples_path
    assert_response 200
  end

  def login_as username
    u = User.find_by_login username
    u.disabled = false
    u.password = "abcdefghijklmn"
    u.save
    
    post login_path, :username => username, :password => "abcdefghijklmn", :to => "/"
    assert_redirected_to '/'
  end

  def id_for symbol
    ActiveRecord::FixtureSet.identify symbol
  end
end
