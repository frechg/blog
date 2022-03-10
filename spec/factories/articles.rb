FactoryBot.define do
  factory :article do
    sequence(:title) { |i| "Article #{i}" }
    body { "Article body." }
    status { "public" }
  end
end
