require "rails_helper"

feature "Admin deletes admin" do
  scenario "from the Users page" do
    to_be_deleted = create(:admin, name: "To Be Deleted")

    visit_users_page_as_admin
    within_admin_row(to_be_deleted) do
      click_on t("users.delete.text")
    end

    expect(page).to have_success_flash(to_be_deleted)
    within_admin_rows do
      expect(page).not_to have_user(to_be_deleted)
    end
  end

  def have_success_flash(admin)
    have_text t("users.destroy.success", name: admin.name)
  end

  def within_admin_rows(&block)
    within("[data-role=admins]", &block)
  end

  def within_admin_row(admin, &block)
    within("#user_#{admin.id}", &block)
  end

  def have_user(user)
    have_text(user.name)
  end

  def visit_users_page_as_admin
    visit users_path(as: create(:admin))
  end
end
