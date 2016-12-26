class DummyGenerator
  def self.generateUserVote(from, to)
    (from..to).each do |i|

    end
  end

  def self.generateRandom(from, to)
    rand(from..to)
  end
end
