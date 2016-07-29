class XmlHasherizer
  CONTENT_ROOT = '__content__'.freeze

  def self.serialize(node, hash={})
    node_hash = {}

    # Insert node hash into parent hash correctly.
    case hash[node.name]
      when Array then hash[node.name] << node_hash
      when Hash  then hash[node.name] = [hash[node.name], node_hash]
      when nil   then hash[node.name] = node_hash
    end

    # Handle child elements
    node.children.each do |c|
      if c.element?
        serialize(c, node_hash)
      elsif c.text? || c.cdata?
        node_hash[CONTENT_ROOT] ||= ''
        node_hash[CONTENT_ROOT] << c.content
      end
    end

    # Remove content node if it is blank and there are child tags
    if node_hash.length > 1 && node_hash[CONTENT_ROOT].blank?
      node_hash.delete(CONTENT_ROOT)
    elsif node_hash.length == 1 && node_hash.keys.include?(CONTENT_ROOT)
      hash[node.name] = node_hash[CONTENT_ROOT]
    end

    # Handle attributes
    node.attribute_nodes.each { |a| node_hash[a.node_name] = a.value }

    hash
  end

end
