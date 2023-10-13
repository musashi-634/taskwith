require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validation' do
    let(:organization) { create(:organization) }

    it '組織メンバーだけを許可する' do
      organization_member = create(:user, organization: organization)
      project = build(:project, organization: organization, users: [organization_member])
      expect(project).to be_valid

      not_organization_member = create(:user)
      project.users = [not_organization_member]
      expect(project).to be_invalid
    end
  end
end
