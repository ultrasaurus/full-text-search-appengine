java_import org.apache.lucene.analysis.snowball.SnowballAnalyzer
java_import java.io.StringReader

class Note
  include DataMapper::Resource
  
  property :id,      Serial
  property :content, String,        :required => true, :length => 500
  property :index,   List,          :required => true
  timestamps :at 

  before :valid?, :update_index

  def update_index
    puts "----------------------update index"
    analyzer = SnowballAnalyzer.new("English")
    s = StringReader.new(content)
    token_stream = analyzer.tokenStream(nil, s)

    terms = []
    while (token = token_stream.next) do
      terms << token.term 
    end
    self.index = terms
    puts self.index

  end
end
