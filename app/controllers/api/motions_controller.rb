class API::MotionsController < API::RestfulController
  include UsesDiscussionReaders
  load_and_authorize_resource only: [:show], find_by: :key

  def close
    load_and_authorize(:motion, :close)
    @event = MotionService.close_by_user(@motion, current_user)
    respond_with_resource
  end

  def create_outcome
    load_and_authorize(:motion, :create_outcome)
    @event = MotionService.create_outcome(motion: @motion,
                                          params: permitted_params.motion,
                                          actor:  current_user)
    respond_with_resource
  end

  def update_outcome
    load_and_authorize(:motion, :update_outcome)
    @event = MotionService.update_outcome(motion: @motion,
                                          params: permitted_params.motion,
                                          actor:  current_user)
    respond_with_resource
  end

  def index
    load_and_authorize :discussion
    instantiate_collection { |collection| collection.where(discussion: @discussion).order(:created_at) }
    respond_with_collection
  end

  def closed
    load_and_authorize :group, :view_previous_proposals
    instantiate_collection { |collection| collection.closed.where(discussion_id: @group.discussion_ids).order(closed_at: :desc) }
    respond_with_collection
  end

  private

  def visible_records
    Queries::VisibleMotions.new(user: current_user, groups: current_user.groups)
  end

  def serializer_root
    :proposals
  end

end
