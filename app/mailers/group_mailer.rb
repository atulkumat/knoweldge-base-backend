class GroupMailer < ApplicationMailer

  def new_member_added(user_ids, group)
    users_email = User.where(id: user_ids).pluck(:email)
    @group = group
    @url = "#{ENV["REDIRECT_URL"]}/#{@group.id}"
    mail(to: users_email, subject: t('mailer.group.member_added'))
  end

  def promoted_to_admin(user, group)
    @user = user
    @group = group
    @url = "#{ENV["REDIRECT_URL"]}/#{@group.id}"
    mail(to: @user.email, subject: t('mailer.group.promoted'))
  end

  def remove_member(user, group)
    @user = user
    @group = group
    mail(to: @user.email, subject: t('mailer.group.member_removed'))
  end

  def demote_to_member(user, group)
    @user = user
    @group = group
    mail(to: @user.email, subject: t('mailer.group.demoted'))
  end
end
