class UserKnowledgeRating < ActiveRecord::Base
  belongs_to :user
  belongs_to :knowledgeable, :polymorphic => true
  attr_accessible :user_id, :knowledgeable_id, :knowledgeable_type, :knowledge_level

  def self.top_users(knowledgeable)
    UserKnowledgeRating.where(:knowledgeable_id => knowledgeable.id, :knowledgeable_type => knowledgeable.class).order('knowledge_level DESC').limit(5).collect {|ukr| [ukr.user, ukr.knowledge_level]}
  end
end
