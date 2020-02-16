module ApplicationHelper

  def show_vote_link(resource,user)
    if resource.can_vote?(user)
      return ''
    else
      return 'hidden'
    end
  end

  def show_cancel_vote_link(resource,user)
    if resource.can_cancel?(user)
      return ''
    else
      return 'hidden'
    end
  end
end
