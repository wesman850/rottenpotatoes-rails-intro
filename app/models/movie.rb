class Movie < ActiveRecord::Base
    def self.allRatings
        self.select(:rating).map{|x| x.rating}.sort.uniq
    end
    def self.fourRatings
        ['G','PG','PG-13','R']
    end
end
