class UserMailer < BaseMailer
  helper :email
  helper :motions
  helper :application

  def missed_yesterday(user, time_since = nil)
    @recipient = @user = user
    @time_start = time_since || 24.hours.ago
    @time_finish = Time.zone.now
    @time_frame = @time_start...@time_finish

    @discussions = Queries::VisibleDiscussions.new(user: user,
                                                   groups: user.inbox_groups).
                                                   not_muted.
                                                   unread.
                                                   last_activity_after(@time_start)

    unless @discussions.empty? or @user.inbox_groups.empty?
      @discussions_by_group = @discussions.group_by(&:group)
      send_single_mail to: @user.email,
                       subject: t("email.missed_yesterday.subject"),
                       css: 'missed_yesterday',
                       locale: locale_fallback(user.locale)
    end
  end

  def group_membership_approved(user, group)
    @user = user
    @group = group

    send_single_mail to: @user.email,
                     reply_to: @group.admin_email,
                     subject: "#{email_subject_prefix(@group.full_name)} " + t("email.group_membership_approved.subject"),
                     locale: locale_fallback(user.locale, User.find_by_email(@group.admin_email).locale)
  end

  def added_to_group(user: nil, inviter: nil, group: nil, message: nil)
    @user = user
    @inviter = inviter || group.admins.first
    @group = group
    @message = message

    send_single_mail to: @user.email,
                     from: from_user_via_loomio(@inviter),
                     reply_to: inviter.try(:name_and_email),
                     subject: t("email.user_added_to_a_group.subject", which_group: group.full_name, who: @inviter.name),
                     locale: locale_fallback(user.try(:locale), inviter.try(:locale))
  end
end
