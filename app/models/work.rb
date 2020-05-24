class Work < ApplicationRecord
  validates :title, presence: true
  validates_uniqueness_of :title, scope: :category

  has_many :votes, dependent: :destroy

  def self.abcd(category)
    # assumption: we can expect a user will never assign a work to a cateogry other than the ones listed below 
    # since work and edit views use the select element to pick a category

    works_list = self.all 

    case category 
      when "album"
        albums = works_list.select { |work| work.category == "album" }
        return albums
      when "book"
        books = works_list.select { |work| work.category == "book" }
        return books  
      when "movie"
        movies = works_list.select { |work| work.category == "movie" }
        return movies
      end 

  end

  def self.spotlight

    works_list = self.all 

    vote_counts = works_list.max_by{ |work| work.votes.length}

    spotlight_work = vote_counts

    return spotlight_work


  end 

end
