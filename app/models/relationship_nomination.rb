class RelationshipNomination < TagNomination
  belongs_to :fandom_nomination

  validate :known_fandom
  def known_fandom
    return true if self.fandom_nomination || self.parent_tagname
    return true if (tag = Relationship.find_by_name(self.tagname)) && tag.parents.any? {|p| p.is_a?(Fandom)}
    errors.add(:base, ts("We need to know what fandom your relationship tag %{tagname} belongs in.", :tagname => self.tagname))
  end

  def self.for_tag_set_through_fandom(tag_set)
    joins(:fandom_nomination => [{:tag_set_nomination => :owned_tag_set}]).
    where("owned_tag_sets.id = ?", tag_set.id)
  end

  before_save :set_parented
  def set_parented
    self.parented = (tag = Relationship.find_by_name(self.tagname)) && tag.parents.any? {|p| p.is_a?(Fandom)}
  end
    
end