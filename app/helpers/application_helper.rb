module ApplicationHelper
  def markdown(text)
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
    syntax_highlighter(Redcarpet.new(text, *options).to_html).html_safe
  end
    
  def syntax_highlighter(html)
    doc = Nokogiri::HTML(html)
    doc.search("//pre[@lang]").each do |pre|  
      pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])  
    end
    doc.to_s
  end
  
  def relationship_bullet(relationship, node)
    full_sentence = relationship.sentence_from(node)
    othernode = relationship.other_node(node)
    
    link_to_other_node = link_to othernode.to_s, node_url(othernode), :id => "node_#{othernode.id}"
    link_sentence = link_to full_sentence, relationship, :class => 'relSentenceLink loud', :id => "relationshipLink#{relationship.id}"
    
    link_to_other_node + " - " + link_sentence
  end

  def relationship_sentence_with_links(relationship)
    sentence = relationship.sentence1
    node1 = relationship.node1
    link1 = link_to node1.to_s, node_path(node1)
    node2  = relationship.node2
    link2 = link_to node2.to_s, node_path(node2)
    RelHelper::Sentences.populate(sentence, link1, link2).html_safe
  end

  def link_to_remove_fields(name, f)
    f.input(:_destroy, :as => "hidden") + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.simple_fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end
end
