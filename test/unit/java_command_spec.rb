require_relative '../../libraries/java_command'


describe JavaCommand do
  subject { JavaCommand.new(class_or_jar, options)}
  context 'when created with the name of a class' do
    let(:options) { Hash.new }
    let(:class_or_jar) { 'SomeClass' }

    its(:to_s) { should == 'java SomeClass' }

    context 'when created with a classpath' do
      let(:classpath) { 'some/path:some/different/path' }
      let(:options) { { :classpath => classpath } }

      its(:to_s) { should == "java -classpath #{classpath} SomeClass" }
    end

    context 'when created with options' do
      let(:options) { {
        :system_properties => {'foo' => 'bar' },
        :standard_options => { 'server' => nil },
        :non_standard_options => { 'ms' => '69m' },
        :hotspot_options => { 'PrintCompilation' => true },
        :args => ['herp', 'derp']
      }}
      its(:to_s) { should == 'java -Dfoo=bar -server -Xms69m -XX:+PrintCompilation SomeClass herp derp' }
    end
  end

  context 'when created with the path to a jar file' do
    let(:options) { Hash.new }
    let(:class_or_jar) { '/path/application.jar' }
    its(:to_s) { should == 'java -jar /path/application.jar' }

    context 'when created with options' do
      let(:options) { {
        :system_properties => {'foo' => 'bar' },
        :standard_options => { 'server' => nil },
        :non_standard_options => { 'ms' => '69m' },
        :hotspot_options => { 'PrintCompilation' => true },
        :args => ['herp', 'derp']
      }}
      its(:to_s) { should == 'java -Dfoo=bar -server -Xms69m -XX:+PrintCompilation -jar /path/application.jar herp derp' }
    end
  end

  context 'when created with the path to a war file' do
    let(:options) { Hash.new }
    let(:class_or_jar) { '/path/to/application.war' }
    its(:to_s) { should == 'java -jar /path/to/application.war' }
  end
end
