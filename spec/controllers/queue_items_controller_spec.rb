require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    it "sets @queue_items to the queued items of the logged in user" do
      ryan = Fabricate(:user)
      session[:user_id] = ryan.id
      item_1 = Fabricate(:queue_item, user: ryan)
      item_2 = Fabricate(:queue_item, user: ryan)
      get :index
      expect(assigns(:queue_items)).to match_array([item_1, item_2])
    end
    it "redirects to sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST create" do
    context "when a user adds a video to the queue" do
      let(:video) { Fabricate(:video) }
      it "redirects to the my queue page" do
        session[:user_id] = Fabricate(:user).id
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end
      it "creates a queue item" do
        session[:user_id] = Fabricate(:user).id
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end
      it "creates the queue item that is associated with the video" do
        session[:user_id] = Fabricate(:user).id
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end
      it "creates the queue item that is associated with the user" do
        ryan = Fabricate(:user)
        session[:user_id] = ryan.id
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(ryan)
      end
    end
    context "when a queue item is created and there is more than one" do
      let(:video) { Fabricate(:video) }
      let(:next_video) { Fabricate(:video) }
      it "puts the video as the last video in the queue" do
        ryan = Fabricate(:user)
        session[:user_id] = ryan.id
        Fabricate(:queue_item, video_id: video.id, user: ryan)
        post :create, video_id: next_video.id
        next_video_queue_item = QueueItem.where(video_id: next_video.id, user_id: ryan.id).first
        expect(next_video_queue_item.position).to eq(2)
      end
    end

    context "when a queue time contains a video that is already in the queue" do
      let(:video) { Fabricate(:video) }
      it "does not add a duplicate video" do
        ryan = Fabricate(:user)
        session[:user_id] = ryan.id
        Fabricate(:queue_item, video_id: video.id, user: ryan)
        post :create, video_id: video.id
        expect(ryan.queue_items.count).to eq(1)
      end
    end
    
    context "when a user is unauthenticated" do
      it "redirects to the sign in page for unauthenticated users" do
        post :create, video_id: 3
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "DELETE destroy" do
    context "when deleting the queue for the associated user" do
      let(:user) { Fabricate(:user) }
      let(:queue_item) { Fabricate(:queue_item, user: user) }
      it "redirects to the my queue page" do
        session[:user_id] = user.id
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end
      it "deletes the queue item" do
        session[:user_id] = user.id
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end
      it "nomalizes the remaining queue items" do
        laura = Fabricate(:user)
        session[:user_id] = laura.id
        queue_item1 = Fabricate(:queue_item, user: laura, position: 1)
        queue_item2 = Fabricate(:queue_item, user: laura, position: 2)
        delete :destroy, id: queue_item1.id
        expect(QueueItem.first.reload.position).to eq(1)
      end
    end

    context "when trying to delete a queue item that does not belong to the current user" do
      let(:ryan) { Fabricate(:user) }
      let(:laura) { Fabricate(:user) }
      let(:queue_item) { Fabricate(:queue_item, user_id: laura.id) }
      it "does not delete the item if it is not in the current users queue" do
        session[:user_id] = ryan.id
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(1)
      end
    end

    context "dealing with an unauthenticated user" do
      let(:queue_item) { Fabricate(:queue_item) }
      it "redirects to the sign in page for unauthenticated users" do
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "POST update_queue" do
    context "with valid inputs" do
      it "redirects to the my queue page" do
        laura = Fabricate(:user)
        session[:user_id] = laura.id
        queue_item1 = Fabricate(:queue_item, user: laura, position: 1)
        queue_item2 = Fabricate(:queue_item, user: laura, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      it "reorders the queue items" do
        laura = Fabricate(:user)
        session[:user_id] = laura.id
        queue_item1 = Fabricate(:queue_item, user: laura, position: 1)
        queue_item2 = Fabricate(:queue_item, user: laura, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(laura.queue_items).to eq([queue_item2, queue_item1])
      end
      it "normalizes the position numbers" do
        laura = Fabricate(:user)
        session[:user_id] = laura.id
        queue_item1 = Fabricate(:queue_item, user: laura, position: 1)
        queue_item2 = Fabricate(:queue_item, user: laura, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(laura.queue_items.map(&:position)).to eq([1,2 ])
      end
    end

    context "with invalid inputs" do
      it "redirects to the my queue page" do
        laura = Fabricate(:user)
        session[:user_id] = laura.id
        queue_item1 = Fabricate(:queue_item, user: laura, position: 1)
        queue_item2 = Fabricate(:queue_item, user: laura, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.5}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end
      it "sets the flash notice" do
        laura = Fabricate(:user)
        session[:user_id] = laura.id
        queue_item1 = Fabricate(:queue_item, user: laura, position: 1)
        queue_item2 = Fabricate(:queue_item, user: laura, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.5}, {id: queue_item2.id, position: 2}]
        expect(flash[:error]).to be_present
      end
      it "does not change the queue items" do
        laura = Fabricate(:user)
        session[:user_id] = laura.id
        queue_item1 = Fabricate(:queue_item, user: laura, position: 1)
        queue_item2 = Fabricate(:queue_item, user: laura, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with unauthenticated user" do
      it "should redirect to the sign in path" do
        post :update_queue, queue_items: [{id: 10, position: 3}, {id: 11, position: 2}]
        expect(response).to redirect_to sign_in_path
      end
    end

    context "with queue items that do not belong to the current user" do
      it "should not update the queue items" do
        laura = Fabricate(:user)
        ryan = Fabricate(:user)
        session[:user_id] = laura.id
        queue_item1 = Fabricate(:queue_item, user: laura, position: 1)
        queue_item2 = Fabricate(:queue_item, user: ryan, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 4}]
        expect(queue_item2.reload.position).to eq(2)
      end
    end
  end
end