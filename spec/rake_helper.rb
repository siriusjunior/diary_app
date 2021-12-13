require 'rails_helper'
require 'rake'

RSpec.configure do |config|
    # Railsが内部的に定義しているようなタスクも全て読み込む
    config.before(:suite) do
        Rails.application.load_tasks
    end

    # Remove persistency between examples テスト間で全てのタスクが呼ばれた履歴を削除
    config.before(:each) do
        Rake.application.tasks.each(&:reenable)
    end
end