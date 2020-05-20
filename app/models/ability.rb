class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    alias_action :update, :destroy, to: :modify
    alias_action :voteup, :votedown, :votecancel, to: :vote

    if user
      user.admin? ? admin_rights : user_rights
    else
      guest_rights
    end
  end

  def guest_rights
    can :read, :all
  end

  def user_rights
    guest_rights
    can :create, [Question, Answer, Comment]
    can :modify, [Question, Answer, Comment], user_id: user.id

    can :vote, [Question, Answer] do |votable|
      votable.user.id != user.id
    end

    can :destroy, ActiveStorage::Attachment do |attach|
      user.author?(attach.record)
    end

    can :destroy, Link do |link|
      user.author?(link.linkable)
    end

    can :make_best, Answer, question: { user_id: user.id }
  end

  def admin_rights
    can :manage, :all
  end
end
