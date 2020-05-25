require "test_helper"

describe Work do

  describe "validations" do 
    it "is valid when title is present" do 
      # Act
      result = works(:thewall).valid? 

      # Assert 
      expect(result).must_equal true
    end 

    it "is invalid when title is not present" do 
      # Arrange
      invalid_work = Work.new(title: "")

      # Act
      result = invalid_work.valid?
    
      # Assert
      expect(result).must_equal false
      expect(invalid_work.errors.messages).must_include :title
    end 

    it "is invalid when title is the same for another work within the same category" do 
      # Arrange
      w1 = works(:thewall) # in album category
      w2 = Work.new(title: "The Wall", category: "album")

      # Act
      result = w2.valid? 

      # Assert
      expect(result).must_equal false
      expect(w2.errors.messages).must_include :title
      expect(w2.errors.messages[:title]).must_include "has already been taken"
    end 

    it "is valid when title is the same for another work in a different category" do 
      # Arrange
      w1 = works(:thewall) # in album category
      w2 = Work.new(title: "The Wall", category: "movie")

      # Act
      result = w2.valid? 

      # Assert
      expect(result).must_equal true
    end 
  end 

  describe "relations" do 
    it "can have many votes" do
      # Arrange 
      v1 = Vote.create(user_id: users(:toby).id, work_id: works(:thewall).id)
      v2 = Vote.create(user_id: users(:kelly).id, work_id: works(:thewall).id)

      # Act
      result1 = v1.valid?
      result2 = v2.valid?

      # Assert
      expect(result1).must_equal true
      expect(result2).must_equal true
      expect(works(:thewall).votes.length).must_equal 2 
    end 

    it "deletes votes associated with it when work gets deleted" do 
      # Arrange 
      v1 = Vote.create(user_id: users(:toby).id, work_id: works(:thewall).id)
      v2 = Vote.create(user_id: users(:kelly).id, work_id: works(:thewall).id)

      # Act - Assert 
      expect(works(:thewall).votes.length).must_equal 2
      works(:thewall).destroy 
      # note: destroy removes record, but does not remove object 
      expect(works(:thewall).votes.length).must_equal 0
    end 
  end 

  describe "sort_works method" do 
    it "returns a string when there are no works in specific category" do 
      # Arrange 
      works(:thewall).destroy
      works(:hunkydory).destroy
      works(:thesuburbs).destroy
      
      # Act 
      result = Work.sort_works("album")

      # Assert
      expect(result).must_equal "No albums added yet!"
    end 

    it "returns an array of work objects when there are works" do 
      # Act
      result = Work.sort_works("album")

      # Assert
      expect(result).must_be_kind_of Array
      expect(result.first).must_be_kind_of Work
    end 

    it "returns only the works that are labeled with the requested cateogry" do 
      # Act
      result = Work.sort_works("album")

      # Assert
      expect(result.length).must_equal 3
      expect(result.first[:category]).must_equal "album"
      expect(result.last[:category]).must_equal "album"
    end 

    it "returns work array in ascending order based on vote count" do 
      # Arrange
      v1 = Vote.create(user_id: users(:toby).id, work_id: works(:thewall).id)
      v2 = Vote.create(user_id: users(:kelly).id, work_id: works(:thewall).id)
      v3 = Vote.create(user_id: users(:toby).id, work_id: works(:hunkydory).id)

      # Act
      result = Work.sort_works("album")

      # Assert
      expect(result[0].title).must_equal "The Wall"
      expect(result[1].title).must_equal "Hunky Dory"
      expect(result[2].title).must_equal "The Suburbs"
    end 
  end 

  describe "spotlight method" do
    it "returns a string when there are no works" do 
      # Arrange 
      works(:thewall).destroy
      works(:hunkydory).destroy
      works(:thesuburbs).destroy
      works(:ratatouille).destroy
      works(:flipped).destroy

      # Act 
      result = Work.spotlight

      # Assert
      expect(result).must_equal "No media added yet!"
    end 
    
    it "returns a string when there are no votes" do 
      # Act 
      result = Work.spotlight

      # Assert
      expect(result).must_equal "No votes added yet!"
    end 

    it "returns a work object when there are votes" do 
      # Arrange 
      v1 = Vote.create(user_id: users(:toby).id, work_id: works(:thewall).id)

      # Act
      result = Work.spotlight

      # Assert
      expect(result).must_be_kind_of Work
    end 

    it "returns a work with the highest vote count" do
      # Arrange
      v1 = Vote.create(user_id: users(:toby).id, work_id: works(:thewall).id)
      v2 = Vote.create(user_id: users(:kelly).id, work_id: works(:thewall).id)
      v3 = Vote.create(user_id: users(:toby).id, work_id: works(:hunkydory).id)

      # Act
      result = Work.spotlight

      # Assert
      expect(result.title).must_equal "The Wall"
    end 

    it "returns the first work in the work database in the case of a tie with other works" do 
      # Arrange
      v1 = Vote.create(user_id: users(:toby).id, work_id: works(:hunkydory).id)
      v2 = Vote.create(user_id: users(:toby).id, work_id: works(:thesuburbs).id)
      v3 = Vote.create(user_id: users(:toby).id, work_id: works(:thewall).id)

      # Act
      result = Work.spotlight

      # Assert
      expect(result.id).must_be :<, v1.work_id
      expect(result.id).must_be :<, v2.work_id
      expect(result.title).must_equal "The Wall"
    end 
  end

end