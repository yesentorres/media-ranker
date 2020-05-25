require "test_helper"

describe User do

  describe 'validations' do
    it 'is valid when name is present' do
      # Act
      result = users(:toby).valid?

      # Assert
      expect(result).must_equal true
    end

    it 'is invalid without a name' do
      # Arrange
      invalid_user = User.new(name: "")
    
      # Act
      result = invalid_user.valid?
    
      # Assert
      expect(result).must_equal false
      expect(invalid_user.errors.messages).must_include :name
    end
  end

  describe 'relations' do
    it "can have many votes" do
      # Arrange 
      v1 = Vote.create(user_id: users(:toby).id, work_id: works(:thewall).id)
      v2 = Vote.create(user_id: users(:toby).id, work_id: works(:ratatouille).id)

      # Assert
      expect(users(:toby).votes.length).must_equal 2
    end
  end
end