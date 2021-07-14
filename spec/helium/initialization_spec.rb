RSpec.describe Helium::Initialization do
  let(:klass) do
    foo = Module.new do
      attr_reader :foo

      def self.included(mod)
        mod.before_initialize { @foo = :foo }
      end
    end

    bar = Module.new do
      attr_reader :bar

      def self.included(mod)
        mod.after_initialize { @bar = :bar }
      end
    end

    Class.new do
      include Helium::Initialization

      include foo
      include bar

      attr_reader :foo_in_init, :bar_in_init, :args

      def initialize(*args)
        @args = args
        @foo_in_init = foo
        @bar_in_init = bar
      end
    end
  end

  let(:args) { Array.new(rand 1..10) { rand(1..10) } }

  subject { klass.new(*args) }

  it "executes before_initialize before initialization" do
    expect(subject.foo).to eq :foo
    expect(subject.foo_in_init).to eq :foo
  end

  it "executes after_initialize after the initialization" do
    expect(subject.bar).to eq :bar
    expect(subject.bar_in_init).to eq nil
  end

  it "doesn't change signature of the initialization" do
    expect(subject.args).to eq args
  end
end
