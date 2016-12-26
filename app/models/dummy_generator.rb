class DummyGenerator
  def self.generateUserVote(from, to)
    UserVote.create()
  end

  def self.generateRandom(from, to)
    rand(from..to)
  end
end
