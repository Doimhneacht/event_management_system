FactoryGirl.define do
  factory :attachment do
    filename 'Some_file.txt'
    content_type 'audio/mpeg'
    file_contents 'TucTucTuc'
    user
    event
  end
end
