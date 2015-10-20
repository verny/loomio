class NotificationItems::UserAddedToGroup < NotificationItem
  attr_accessor :notification

  def initialize(notification)
    @notification = notification
  end

  def action_text
    I18n.t('notifications.user_added_to_group')
  end

  def title
    @notification.eventable.group_full_name
  end

  def linkable
    [@notification.eventable.group]
  end

  def actor
    @notification.event.user or @notification.user
  end
end
