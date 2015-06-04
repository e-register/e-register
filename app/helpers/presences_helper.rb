module PresencesHelper
  def presence_badge(presence)
    label = presence.presence_type.present ? 'success' : 'danger'
    build_label(label, presence.presence_type.name.humanize)
  end
end
