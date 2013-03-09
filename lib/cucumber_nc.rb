require 'cucumber/formatter/duration'
require 'cucumber/formatter/io'
require 'terminal-notifier'

class CucumberNc
  include Cucumber::Formatter::Duration
  include Cucumber::Formatter::Io

  attr_reader :step_mother
  def initialize(step_mother, path_or_io, options)
    @step_mother, @options = step_mother, options
  end

  def after_features(features)
    print_summary(features)
  end

  def before_feature(feature); end
  def comment_line(comment_line); end
  def after_tags(tags); end
  def tag_name(tag_name); end
  def feature_name(keyword, name); end
  def before_feature_element(feature_element); end
  def after_feature_element(feature_element); end
  def before_background(background); end
  def after_background(background); end
  def background_name(keyword, name, file_colon_line, source_indent); end
  def before_examples_array(examples_array); end
  def examples_name(keyword, name); end
  def before_outline_table(outline_table); end
  def after_outline_table(outline_table); end
  def scenario_name(keyword, name, file_colon_line, source_indent); end
  def before_step(step); end
  def before_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background, file_colon_line); end
  def step_name(keyword, step_match, status, source_indent, background, file_colon_line); end
  def doc_string(string); end
  def exception(exception, status); end
  def before_multiline_arg(multiline_arg); end
  def after_multiline_arg(multiline_arg); end
  def before_table_row(table_row); end
  def after_table_row(table_row); end
  def after_table_cell(cell); end
  def table_cell_value(value, status); end

  private

  def pluralize(num, str)
    (num == 1) ? str : "#{str}s"
  end

  def summary_line(features)
    scenarios = step_mother.scenarios.count
    scenarios_failed = step_mother.scenarios(:failed).count
    scenarios_undefined = step_mother.scenarios(:undefined).count
    scenarios_pending = step_mother.scenarios(:pending).count
    scenarios_passing = step_mother.scenarios(:passed).count
    
    steps = step_mother.steps.count
    steps_failed = step_mother.steps(:failed).count
    steps_skipped = step_mother.steps(:skipped).count
    steps_undefined = step_mother.steps(:undefined).count
    steps_pending = step_mother.steps(:pending).count
    steps_passing = step_mother.steps(:passed).count

    counts = []
    counts << "#{scenarios_undefined} undefined" if scenarios_undefined > 0
    counts << "#{scenarios_pending} pending" if scenarios_pending > 0
    counts << "#{scenarios_failed} failed" if scenarios_failed > 0
    counts << "#{scenarios_passing} passed" if scenarios_passing > 0

    # 5 scenarios (1 undefined, 3 pending, 1 passed)
    summary = "#{scenarios} #{pluralize(scenarios, "scenario")} (#{counts.join(', ')})\n\n"

    counts = []
    counts << "#{steps_undefined} undefined" if steps_undefined > 0
    counts << "#{steps_skipped} skipped" if steps_skipped > 0
    counts << "#{steps_pending} pending" if steps_pending > 0
    counts << "#{steps_failed} failed" if steps_failed > 0
    counts << "#{steps_passing} passed" if steps_passing > 0

    # 35 steps (23 skipped, 1 undefined, 3 pending, 8 passed)
    summary << "#{steps} #{pluralize(steps, "step")} (#{counts.join(', ')})"

    summary
  end

  def print_summary(features)
    body = []
    body << summary_line(features)
    
    # 0m0.024s
    body << "#{ format_duration(features.duration) }"

    name = File.basename(File.expand_path('.'))

    title = unless step_mother.scenarios(:failed).empty?
      "\u26D4 #{ name }: #{ step_mother.scenarios(:failed).count } failed #{ pluralize(step_mother.scenarios(:failed).count, 'scenario') }"
    else
      "\u2705 #{ name }: Success"
    end

    say title, body.join("\n")
  end

  def say(title, body)
    TerminalNotifier.notify body, :title => title
  end
end
