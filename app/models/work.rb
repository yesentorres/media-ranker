class Work < ApplicationRecord
  validates :title, presence: true
  validates_uniqueness_of :title, scope: :category

  has_many :votes, dependent: :destroy

  def self.sort_works(category)
    # assumption: we can expect a user will never assign a work to a category other than the ones listed below 
    # since work and edit views use the select element to pick a category
    case category 
      when "album"
        categorized_works = self.where(category: "album")
      when "book"
        categorized_works = self.where(category: "book")
      when "movie"
        categorized_works = self.where(category: "movie")
    end 

    # sort in descending order by vote count
    if categorized_works.length == 0
      return "No #{category}s added yet!"
    else 
      return categorized_works.sort_by {|categorized_work| -categorized_work.votes.count}
    end
  end 


  def self.spotlight
    works_list = self.all 

    if works_list.length == 0 
      return "No media added yet!"
    end

    spotlight = works_list.max_by{ |work| work.votes.length}

    if spotlight.votes.length == 0 
      return "No votes added yet!"
    else 
      return spotlight 
    end

  end 

end
