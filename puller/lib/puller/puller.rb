##
# Pulls weather data from a specified source.
module Puller
  def self.pull_from(url, getter, processor, saver, destination)
    content = getter.get(url)
    data = processor.data_from(content)
    saver.save(data, destination)
  end
end
