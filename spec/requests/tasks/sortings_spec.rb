require 'rails_helper'

RSpec.describe "Tasks::Sortings", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "PATCH /tasks/sortings/:id" do
    context 'ユーザーが組織に所属している場合' do
      let(:project) { create(:project) }

      before { project.organization.users << user }

      context '所属組織のタスクの場合' do
        let!(:task) { create(:task, project: project) }

        before { create_list(:task, 3, project: task.project) }

        context '有効な属性値の場合' do
          let(:new_row_order) { 2 }

          it 'ソート順の値を更新できること' do
            expect do
              patch tasks_sorting_path(task), params: { row_order_position: new_row_order }
            end.to change { task.reload.row_order_rank }.from(0).to(new_row_order)
            expect(response).to have_http_status :no_content
          end
        end

        context '無効な属性値の場合' do
          let(:new_row_order) { nil }

          it 'ソート順の値を更新できないこと' do
            expect do
              patch tasks_sorting_path(task), params: { row_order_position: new_row_order }
            end.not_to change { task.reload.row_order_rank }.from(0)
            expect(response).to have_http_status :no_content
          end
        end
      end

      context '他の組織のタスクの場合' do
        let!(:task) { create(:task) }
        let(:new_row_order) { 2 }

        before { create_list(:task, 3, project: task.project) }

        it 'ソート順の値を更新できず、プロジェクト一覧ページにリダイレクトされること' do
          expect do
            patch tasks_sorting_path(task), params: { row_order_position: new_row_order }
          end.not_to change { task.reload.row_order_rank }.from(0)
          expect(response).to redirect_to projects_path
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let!(:task) { create(:task) }
      let(:new_row_order) { 2 }

      before { create_list(:task, 3, project: task.project) }

      it 'ソート順の値を更新できず、組織作成ページにリダイレクトされること' do
        expect do
          patch tasks_sorting_path(task), params: { row_order_position: new_row_order }
        end.not_to change { task.reload.row_order_rank }.from(0)
        expect(response).to redirect_to new_organization_path
      end
    end
  end
end
