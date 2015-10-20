require 'rails_helper'

describe DiscussionReader do

  let(:user) { FactoryGirl.create :user }
  let(:other_user) { FactoryGirl.create :user }
  let(:group) { FactoryGirl.create :group }
  let(:discussion) { FactoryGirl.create :discussion, group: group }
  let(:membership) { FactoryGirl.create :membership, user: user, group: group, volume: :normal }
  let(:reader) { DiscussionReader.for(user: user, discussion: discussion) }

  describe 'volume' do
    it 'can change its volume' do
      reader.set_volume! :loud
      expect(reader.reload.volume.to_sym).to eq :loud
    end

    it 'defaults to the memberships volume when nil' do
      expect(membership.volume).to eq reader.volume
    end
  end

  describe "#first_unread_page" do
    before do
      Discussion.send(:remove_const, 'PER_PAGE')
      Discussion::PER_PAGE = 2
      discussion.group.add_member! user
      discussion.group.add_member! other_user
    end

    subject do
      reader.first_unread_page
    end

    context '0 items' do
      it {should == 1}
    end

    context '0 read, 1 unread' do
      before do
        CommentService.create comment: build(:comment, discussion: discussion), actor: user
      end
      it {should == 1}
    end

    context '1 read, 1 unread' do
      before do
        CommentService.create comment: build(:comment, discussion: discussion), actor: user
        CommentService.create comment: build(:comment, discussion: discussion), actor: user
      end
      it {should == 1}
    end

    context '2 read' do
      before do
        CommentService.create comment: build(:comment, discussion: discussion), actor: user
        CommentService.create comment: build(:comment, discussion: discussion), actor: user
      end

      it {should == 1}
    end

    context '2 read, 1 unread' do
      before do
        2.times do
          CommentService.create comment: build(:comment, discussion: discussion), actor: user
        end
        CommentService.create comment: build(:comment, discussion: discussion), actor: user
      end

      it {should == 2}
    end
  end


end
