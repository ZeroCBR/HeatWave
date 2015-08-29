##
# Pulls weather data from a specified source.
module Puller
  def self.pull_from(url, pipeline, destination)
    content = pipeline[:getter].get(url)
    data = pipeline[:processor].data_in(content)
    pipeline[:marshaller].dump(data, destination)
  end
end
