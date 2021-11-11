class SearchDiariesForm
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations
    attribute :body, :string
    validates :body, presence: true

    def search
        scope = Diary.distinct
        # inject以下はscopeをorでチェーン
        scope = splited_bodies.map { |splited_body| scope.body_contain(splited_body) }.inject{ |result, scp| result.or(scp) } if body.present?
        scope
    end

    private

        def splited_bodies
            body.strip.split(/[[:blank:]]+/)
        end
end