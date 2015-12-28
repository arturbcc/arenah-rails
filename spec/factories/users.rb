FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "test#{i}@arenah.com.br" }
    name 'John Doe'
    slug 'john-doe'
    password '12345678'
    encrypted_password '$2a$10$jb0hkYy5d80PzkzMYztz1e85oHi1/WsiX02Wa4GV1bNL1mmdiIbr2'
    confirmed_at Time.now
    created_at Time.now
    updated_at Time.now
  end
end
