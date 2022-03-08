FactoryBot.define do
  factory :article do
    title { "Article title" }
    body { "Article body." }
    status { "public" }
  end
end
