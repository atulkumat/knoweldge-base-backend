class CommentMailer < ApplicationMailer

  def comment_accepted(user, post)
    @user = user
    @post = post
    @url = "#{ENV["REDIRECT_URL"]}/#{@post.id}"
    mail(to: @user.email, subject: t('comment_accepted'))
  end

  def up_voted(user, comment, current_user)
    @user = user
    @comment = comment
    @current_user = current_user
    @url = "#{ENV["REDIRECT_URL"]}/#{@comment.post.id}"
    mail(to: @user.email, subject: t('comment_upvoted'))
  end
  
  def down_voted(user, comment, current_user)
    @user = user
    @comment = comment
    @current_user = current_user
    @url = "#{ENV["REDIRECT_URL"]}/#{@comment.post.id}"
    mail(to: @user.email, subject: t('comment_downvoted'))
  end  

  def comment_create(post, current_user)
    @post = post
    @current_user = current_user
    users_ids = Comment.where(post_id: @post.id).pluck(:user_id).uniq
    users_emails = User.where(id: users_ids).pluck(:email)
    users_emails.delete(current_user.email)
    users_emails << @post.user.email
    @url = "#{ENV["REDIRECT_URL"]}/#{@post.id}"
    mail(:to => users_emails, subject: t('comment_created'))
  end  
end
