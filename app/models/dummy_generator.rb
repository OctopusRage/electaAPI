class DummyGenerator
  def self.generateUserVote(from, to, target)
    vote = Vote.find(target)
    vote_length = vote.vote_options.count
    (from..to).each do |i|
      UserVote.participate(User.find(i), target, generateRandom(0, vote_length-1))
    end
  end

  def self.updateUserVote(from, to)
    (from..to).each do |i|
      rnd_date = generateRandom(1,60).days.ago
      UserVote.find(i).update(created_at: rnd_date)
    end
  end

  def self.generateRandom(from, to)
    rand(from..to)
  end
end
