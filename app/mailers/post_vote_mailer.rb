class PostVoteMailer < ApplicationMailer
  def up_voted(user, post, current_user)
    @user = user
    @post = post
    @current_user = current_user
    @url = "#{ENV["REDIRECT_URL"]}/#{@post.id}"
    mail(to: @user.email, subject: t('upvote_post'))
  end
  
  def down_voted(user, post, current_user)
    @user = user
    @post = post
    @current_user = current_user
    @url = "#{ENV["REDIRECT_URL"]}/#{@post.id}"
    mail(to: @user.email, subject: t('downvote_post'))
  end  
end
