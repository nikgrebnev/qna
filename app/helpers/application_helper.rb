module ApplicationHelper

  def vote_links_showing(resource,user)
    return '' if resource.can_vote?(user)

    'hidden'
  end

  def vote_cancel_showing(resource,user)
    return '' if resource.can_cancel?(user)

    'hidden'
  end
end
