module SessionsHelper

  # 渡されたユーザーでログインする
    def log_in(user)
        session[:user_id] = user.id
    end
 # ユーザーのセッションを永続的にする
 def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end


   # 渡されたユーザーがログイン済みユーザーであればtrueを返す
   def current_user?(user)
    user == current_user
  end

  
  # 記憶トークンcookieに対応するユーザーを返す

  # 現在ログイン中のユーザーを返す (いる場合)
    def current_user
        if (user_id = session[:user_id])
            
          @current_user ||= User.find_by(id: user_id)
          
        elsif (user_id = cookies.signed[:user_id])
            # raise       # テストがパスすれば、この部分がテストされていないことがわかる
          user = User.find_by(id: user_id)
          if user && user.authenticated?(cookies[:remember_token])
            log_in user
            @current_user = user
          end
        end
    end #current_user

    # ユーザーがログインしていればtrue、その他ならfalseを返す
    def logged_in?
        !current_user.nil?
    end

    # 永続的セッションを破棄する
    def forget(user)
        user.forget #remember_digestをnil で更新
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end


    def log_out
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end






end
