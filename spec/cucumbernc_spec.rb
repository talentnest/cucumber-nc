require 'cucumber_nc'
require 'set'
require 'bigdecimal'

class Duration
  attr_accessor :duration
  def initialize(d)
    @duration = BigDecimal.new(d, 4)
  end
end

class StepMocker
  ALLOWED_SCENARIO_STATUSES=Set.new([:passed, :pending, :undefined, :failed])
  class << ALLOWED_SCENARIO_STATUSES; def to_s; self.to_a.join(", "); end; end
  ALLOWED_STEP_STATUSES=Set.new([:passed, :pending, :undefined, :skipped, :failed])
  class << ALLOWED_STEP_STATUSES; def to_s; self.to_a.join(", "); end; end

  def initialize
    clear_mocks
  end

  def scenarios(status=nil)
    return self.data.
      select { |scenario| status.nil? || scenario[:status] == status }
  end

  def steps(status=nil)
    return self.data.
      map { |scenario| scenario[:steps] }.
      flatten.
      select { |step| status.nil? || step == status }
  end

  def clear_mocks
    self.data = []
    return self
  end

  def add_scenario(status)
    raise ArgumentError.new("Scenario status must be one of: #{ALLOWED_SCENARIO_STATUSES}, got '#{status}'!") unless(ALLOWED_SCENARIO_STATUSES.include?(status))
    scenario_mock = {
      :status => status,
      :steps  => [],
    }

    class << scenario_mock[:steps]
      def add_step(status)
        raise ArgumentError.new("Step status must be one of: #{ALLOWED_STEP_STATUSES}, got '#{status}'!") unless(ALLOWED_STEP_STATUSES.include?(status))
        self << status
        return self
      end
    end

    yield scenario_mock[:steps] if(block_given?)

    self.data << scenario_mock
    return self
  end

protected

  attr_accessor :data
end

describe CucumberNc do
  let(:step_mocker) do
    StepMocker.new
  end

  let(:formatter)   do
    CucumberNc.new(step_mocker, nil, nil)
  end

  let(:current_dir) { File.basename(File.expand_path '.') }

  # emoji
  let(:success) { "\u2705" }
  let(:failure) { "\u26D4" }

  it 'gives TerminalNotifier an accurate summary' do
    step_mocker.
      clear_mocks.
      add_scenario(:failed) do |mock|
        mock.add_step(:passed)
        mock.add_step(:failed)
        mock.add_step(:pending)
      end

    TerminalNotifier.should_receive(:notify).with(
      "1 scenario (1 failed)\n3 steps (1 pending, 1 failed, 1 passed)\n0.0m0.001s",
      :title => "#{failure} #{current_dir}: 1 failed scenario"
    )

    formatter.send(:print_summary, Duration.new(0.001))
  end

  it 'properly indicates failure to TerminalNotifier' do
    step_mocker.
      clear_mocks.
      add_scenario(:failed) do |mock|
        mock.add_step(:failed)
      end

    TerminalNotifier.should_receive(:notify).with(
      "1 scenario (1 failed)\n1 step (1 failed)\n0.0m0.001s",
      :title => "#{failure} #{current_dir}: 1 failed scenario"
    )

    formatter.send(:print_summary, Duration.new(0.001))
  end

  it 'properly indicates success to TerminalNotifier' do
    step_mocker.
      clear_mocks.
      add_scenario(:passed) do |mock|
        mock.add_step(:passed)
      end

    TerminalNotifier.should_receive(:notify).with(
      "1 scenario (1 passed)\n1 step (1 passed)\n0.0m0.001s",
      :title => "#{success} #{current_dir}: Success"
    )

    formatter.send(:print_summary, Duration.new(0.001))
  end
end
