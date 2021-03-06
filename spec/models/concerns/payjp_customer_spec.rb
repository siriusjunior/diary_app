require 'rails_helper'

RSpec.describe PayjpCustomer, type: :model do
    
    before do
        charge_mock = double(:charge_mock)
        allow(charge_mock).to receive(:id).and_return(SecureRandom.uuid)
        allow(Payjp::Charge).to receive(:create).and_return(charge_mock)
    end

    describe 'スコープ' do
        describe 'subscription_to_be_updated' do
            let!(:subscripting_user) { create(:user) }
            let!(:canceled_user) { create(:user) }
            let!(:basic_plan) { create(:plan, :basic_plan) }
            before do
                subscripting_user.subscript!(basic_plan)
                canceled_user.subscript!(basic_plan)
                canceled_user.stop_subscript!
            end
            it 'キャンセルしていないユーザーは対象となること' do
                travel_to(Time.current.next_month)
                expect(User.subscription_to_be_updated).to include subscripting_user
            end
            it 'キャンセルしているユーザーは対象外であること' do
                travel_to(Time.current.next_month)
                expect(User.subscription_to_be_updated).not_to include canceled_user
            end
            it '期限が切れていないユーザーは対象外であること' do
                expect(User.subscription_to_be_updated).not_to include subscripting_user
            end
        end
    end

    describe 'インスタンスメソッド' do
        let(:user) { create(:user) }
        let!(:basic_plan) { create(:plan, :basic_plan) }
        let!(:premium_plan) { create(:plan, :premium_plan) }
        
        describe 'latest_contract' do
            let!(:old_contract) { user.subscript!(basic_plan) }
            let!(:new_contract) { user.subscript!(premium_plan) }
            it '最新の契約が取得できること' do
                expect(user.latest_contract).to eq(new_contract)
            end
        end

        describe 'subscripting_to?' do
            before do
                user.subscript!(basic_plan)
            end

            it '契約しているプランについてはtrueが返ること' do
                expect(user.subscripting_to?(basic_plan)).to be_truthy
            end
            
            it '契約していないプランについてはfalseが返ること' do
                expect(user.subscripting_to?(premium_plan)).to be_falsey
            end
        end

        describe 'about_to_cancel?' do
            before do
                user.subscript!(basic_plan)
            end

            it '購読停止した場合はtrueが返ること' do
                user.stop_subscript!
                expect(user.about_to_cancel?(basic_plan)).to be_truthy
            end
            
            it '購読停止していない場合はfalseが返ること' do
                expect(user.about_to_cancel?(basic_plan)).to be_falsey
            end
        end

        describe 'subscripting?' do
            before do
                user.subscript!(basic_plan)
            end

            it '有効期間内である場合はtrueが返ること' do
                expect(user.subscripting?).to be_truthy
            end

            it '有効期間が切れている場合はfalseが返ること' do
                travel_to(Time.current.next_month)
                expect(user.subscripting?).to be_falsey
            end
        end

        describe 'subscripting_basic_plan?' do
            it 'ベーシックプランを契約している場合はtrueが返ること' do
                user.subscript!(basic_plan)
                expect(user.subscripting_basic_plan?).to be_truthy
            end
            it 'ベーシックプランを契約していない場合はfalseが返ること' do
                user.subscript!(premium_plan)
                expect(user.subscripting_basic_plan?).to be_falsey
            end
        end
        describe 'subscripting_basic_plan?' do
            it 'プレミアムプランを契約している場合はtrueが返ること' do
                user.subscript!(premium_plan)
                expect(user.subscripting_premium_plan?).to be_truthy
            end
            it 'プレミアムプランを契約していない場合はfalseが返ること' do
                user.subscript!(basic_plan)
                expect(user.subscripting_premium_plan?).to be_falsey
            end
        end

        describe 'register_creditcard!' do
            let(:user) { create(:user, :without_customer_id) }
            let(:card_token) { SecureRandom.uuid }
            before do
                customer_mock = double(:customer_mock)
                allow(customer_mock).to receive(:id).and_return(card_token)
                allow(Payjp::Customer).to receive(:create).and_return(customer_mock)
            end

            it 'カード登録したらcustomer_idにトークンが反映されること' do
                expect(user.customer_id).to be_nil
                user.register_creditcard!(token: card_token)
                expect(user.customer_id).to eq(card_token)
            end
        end

        describe 'subscript!' do
            it 'contractとpaymentが作成されること' do
                expect {
                    user.subscript!(basic_plan)
                }.to change { Contract.count }.by(1).and change { Payment.count }.by(1)
            end
        end

        describe 'stop_subscript!' do
            before do
                user.subscript!(basic_plan)
            end
            it 'cancellationが作成されること' do
                expect {
                    user.stop_subscript!
                }.to change { ContractCancellation.count }.by(1)
            end
        end

        describe 'pay!' do
            before do
                user.contracts.create(plan: basic_plan)
            end
            it 'paymentが作成されること' do
                expect{
                    user.pay!
                }.to change{ Payment.count }.by(1)
            end
        end

        # describe 'can_message?' do
        #     let!(:invited) { create(:user) }
        #     context '未契約の場合' do
        #         before do
        #             @chatroom = Chatroom.chatroom_with_users([user] + [invited])
        #         end
        #         it 'メッセージが0件でもtrueが返ること' do
        #             expect(user.can_message?).to be_truthy
        #         end
        #         it 'メッセージが11件だとfalseが返ること' do
        #             create_list(:message, 11, user: user, chatroom: @chatroom)
        #             expect(user.can_message?).to be_falsey
        #         end
        #     end
        #     context 'ベーシックプランの場合' do
        #         before do
        #             user.subscript!(basic_plan)
        #             @chatroom = Chatroom.chatroom_with_users([user] + [invited])
        #         end
        #         it 'メッセージが11件でもtrueが返ること' do
        #             create_list(:message, 11, user: user, chatroom: @chatroom)
        #             expect(user.can_message?).to be_truthy
        #         end
        #         it 'メッセージが20件だとfalseが返ること' do
        #             create_list(:message, 20, user: user, chatroom: @chatroom)
        #             byebug
        #             expect(user.can_message?).to be_falsey
        #         end
        #     end
        #     context 'プレミアムプランの場合' do
        #         before do
        #             user.subscript!(premium_plan)
        #             @chatroom = Chatroom.chatroom_with_users([user] + [invited])
        #         end
        #         it 'メッセージが32件でもtrueが返ること' do
        #             create_list(:message, 32, user: user, chatroom: @chatroom)
        #             expect(user.can_message?).to be_truthy
        #         end
        #     end
        # end
    end
end