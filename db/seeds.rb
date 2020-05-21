require 'csv'

WORK_FILE = Rails.root.join('db', 'seed_data', 'works.csv')
puts "Loading raw works data from #{WORK_FILE}"

work_failures = []

CSV.foreach(WORK_FILE, :headers => true) do |row|

  work = Work.new

  work.category = row['category']
  work.title = row['title']
  work.creator = row['creator']
  work.publication_year = row['publication_year']
  work.description = row['description']

  successful = work.save

  if !successful
    work_failures << work
    puts "Failed to save work: #{work.inspect}"
  else
    puts "Created work: #{work.inspect}"
  end
end

puts "Added #{Work.count} work records"
puts "#{work_failures.length} works failed to save"