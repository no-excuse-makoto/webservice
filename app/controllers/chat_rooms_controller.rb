class ChatRoomsController < ApplicationController
    before_action :authenticate_user
  
    def index
      # 自分が関わるチャットルームを取得
      @chat_rooms = ChatRoom.where("user1_id = ? OR user2_id = ?", current_user.id, current_user.id)
          # 最初のチャットルームのメッセージを取得（必要に応じて変更）
    if @chat_rooms.any?
        @messages = @chat_rooms.first.messages.includes(:user)
      else
        @messages = [] # チャットルームがない場合は空の配列を設定
      end
    end
  
    def new
      @user = User.find(params[:user_id]) # チャット相手のユーザー
      @chat_room = ChatRoom.new
    end
  
    def create
        # 既存のチャットルームを検索
        @chat_room = ChatRoom.find_by(
          user1_id: current_user.id, user2_id: params[:user2_id]
        ) || ChatRoom.find_by(
          user1_id: params[:user2_id], user2_id: current_user.id
        )
    
        # 既存のチャットルームがない場合のみ作成
        unless @chat_room
          @chat_room = ChatRoom.create(user1_id: current_user.id, user2_id: params[:user2_id])
        end
    
        redirect_to chat_room_path(@chat_room)
      end
  
    def show
      @chat_room = ChatRoom.find(params[:id])
      @messages = @chat_room.messages.order(:created_at)
      @message = Message.new
    end
  end