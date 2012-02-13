formats = {
  :default => "%A %d %B",
  :precise => "%A %d %B (at %H:%M%p)",
  :short => "%d %B, %Y",
  :month => "%B %Y"
}

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(formats)
