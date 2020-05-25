class Work < ApplicationRecord
  validates :title, presence: true
  validates_uniqueness_of :title, scope: :category

  has_many :votes, dependent: :destroy

  def self.sort_works(category)
    # assumption: we can expect a user will never assign a work to a cateogry other than the ones listed below 
    # since work and edit views use the select element to pick a category

    # categorize works 
    case category 
      when "album"
        categorized_works = self.where(category: "album")
      when "book"
        categorized_works = self.where(category: "book")
      when "movie"
        categorized_works = self.where(category: "movie")
    end 

    # sort in ascending order by vote count
    if categorized_works.length == 0
      return "No #{category}s added yet !"
    else 
      return categorized_works.sort_by {|categorized_work| -categorized_work.votes.count}
    end
  end 


  def self.spotlight

    works_list = self.all 

    vote_counts = works_list.max_by{ |work| work.votes.length}

    spotlight_work = vote_counts

    return spotlight_work


  end 

end
