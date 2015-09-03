##
# Provides top level control for the data pulling process using
# submodules as dependencies.
#
# These are dependencies are injected as method parameters
# so they may be replaced with other implementations if needed.
#
module Puller
  ##
  # Pulls weather data from the specified source using the provided
  # pipeline.
  #
  # ==== Parameters
  #
  # * +source+ - the parameter to pass to the getter.
  # * +pipeline+ - a hash containing:
  #   * +:getter+ - an object with a +#get(source)+ method
  #     which returns the +content+ provided by the source.
  #   * +:processor+ - an object with a +#data_in(content)+ method
  #     which takes the content produced by the getter and
  #     extracts the +data+ of interest.
  #   * +:marshaler+ - an object with a +#dump(data)+ method which
  #     takes the data produced by the processor and dumps it.
  #
  # ==== Returns
  #
  # * The value returned by the marshaler's +#dump+ method.
  #
  def self::pull_from(source, pipeline)
    content = pipeline[:getter].get(source)
    data = pipeline[:processor].data_in(content)
    pipeline[:marshaler].dump(data)
  end
end
