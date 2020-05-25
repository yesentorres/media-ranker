require "test_helper"

describe Vote do

  describe 'validations' do
    it "can be created with a valid user id and valid work id" do
      # Arrange 
      toby = users(:toby)
      thewall = works(:thewall)
      vote = Vote.create(user_id: toby.id, work_id: thewall.id)

      # Act
      result = vote.valid?

      # Assert 
      expect(result).must_equal true
    end 

    it "cannot be created with an invalid user id" do
      # Arrange 
      thewall = works(:thewall)
      vote = Vote.create(user_id: -1, work_id: thewall.id)

      # Act
      result = vote.valid?

      # Assert 
      expect(result).must_equal false
    end

    it "cannot be created with an invalid work id" do
      # Arrange 
      toby = users(:toby)
      vote = Vote.create(user_id: toby.id, work_id: -1)

      # Act
      result = vote.valid?

      # Assert 
      expect(result).must_equal false
    end

    it "cannot be created when user has already voted for the work" do 
      # Arrange 
      toby = users(:toby)
      thewall = works(:thewall)
      vote1 = Vote.create(user_id: toby.id, work_id: thewall.id)
      vote2 = Vote.create(user_id: toby.id, work_id: thewall.id)

      # Act
      result = vote2.valid?

      # Assert 
      expect(result).must_equal false
      expect(vote2.errors.messages).must_include :user
      expect(vote2.errors.messages[:user]).must_include "has already voted for this work"
    end 
  end

  describe 'relations' do
    it "belongs to a user" do 
      # Arrange
      toby = users(:toby)
      thewall = works(:thewall)
      vote = Vote.create(user_id: toby.id, work_id: thewall.id)

      # Act - Assert
      expect(toby.votes.first.id).must_equal vote.id
    end 

    it "belongs to a work" do 
      # Arrange
      toby = users(:toby)
      thewall = works(:thewall)
      vote = Vote.create(user_id: toby.id, work_id: thewall.id)

      # Act - Assert
      expect(thewall.votes.first.id).must_equal vote.id
    end 
  end
end