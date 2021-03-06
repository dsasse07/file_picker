  
module CliControls

  @@prompt = TTY::Prompt.new

  # Overwriting the "yes?" method given by TTY prompt to have custom answers
  def yes_no(question_str)
      @@prompt.yes?(question_str) do |q|
      q.suffix "Yes/No"
      q.positive "Yes"
      q.negative "No"
      end
  end

  # A method for downcasing an ask
  def down_ask(str)
      @@prompt.ask(str).downcase
  end

end