# Hash extensions
#
# This is borrowed from ActiveSupport. We don't want the entire ActiveSupport
# library (it's huge), so we'll just add the methods we want.
class Hash
  # Merge self with another hash recursively
  #
  # @api public
  #
  # @param [Hash] hash The hash to merge into this one.
  #
  # @example Merge two hashes with some common keys
  #   a_hash = { :foo => :bar, :baz => { :foobar => "hey" }}
  #   another_hash = { :foo => :foobar, :baz => { :foo => :bar }}
  #   a_hash.deep_merge(another_hash)
  #   # => { :foo => :foobar, :baz => { :foobar => "hey", :foo => :bar }}
  #
  # @return [Hash] The given hash merged recursively into this one.
  def deep_merge(hash)
    target = self.dup
    hash.keys.each do |key|
      if hash[key].is_a?(Hash) && self[key].is_a?(Hash)
        target[key] = target[key].deep_merge(hash[key])
        next
      end
      target[key] = hash[key]
    end
    target
  end

  # Make a new hash with all keys converted to symbols
  #
  # @api public
  #
  # @example Convert strings keys to symbol keys
  #   { 'foo' => 'bar' }.symbolize_keys
  #   # => { :foo => 'bar' }
  #
  # @return [Hash{Symbol => Object}]
  def symbolize_keys
    inject({}) do |options, (key, value)|
      options[(key.to_sym rescue key) || key] = value
      options
    end
  end
end

