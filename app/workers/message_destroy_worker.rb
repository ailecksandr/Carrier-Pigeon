class MessageDestroyWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: 'message_destroying'

  def perform(id)
    Message.find_by_id(id).destroy
  end
end