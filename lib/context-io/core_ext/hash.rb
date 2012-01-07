class Hash
  # Public: Merges self with another Hash, recursively.
  #
  # hash - The Hash to merge
  #
  # Returns self merged recursively with the passed Hash.
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
end

