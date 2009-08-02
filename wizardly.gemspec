# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{wizardly}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeff Patmon"]
  s.date = %q{2009-08-02}
  s.description = %q{Create wizards from any model in three steps}
  s.email = %q{jpatmon@yahoo.com}
  s.files = ["lib/generators/wizardly_app", "lib/generators/wizardly_app/templates", "lib/generators/wizardly_app/templates/wizardly.rake", "lib/generators/wizardly_app/USAGE", "lib/generators/wizardly_app/wizardly_app_generator.rb", "lib/generators/wizardly_controller", "lib/generators/wizardly_controller/templates", "lib/generators/wizardly_controller/templates/controller.rb.erb", "lib/generators/wizardly_controller/templates/helper.rb.erb", "lib/generators/wizardly_controller/USAGE", "lib/generators/wizardly_controller/wizardly_controller_generator.rb", "lib/generators/wizardly_scaffold", "lib/generators/wizardly_scaffold/templates", "lib/generators/wizardly_scaffold/templates/form.html.erb", "lib/generators/wizardly_scaffold/templates/helper.rb.erb", "lib/generators/wizardly_scaffold/templates/layout.html.erb", "lib/generators/wizardly_scaffold/templates/style.css", "lib/generators/wizardly_scaffold/USAGE", "lib/generators/wizardly_scaffold/wizardly_scaffold_generator.rb", "lib/tasks/rspec.rake", "lib/tasks/wizardly.rake", "lib/wizardly", "lib/wizardly/action_controller.rb", "lib/wizardly/validation_group.rb", "lib/wizardly/wizard", "lib/wizardly/wizard/button.rb", "lib/wizardly/wizard/configuration", "lib/wizardly/wizard/configuration/methods.rb", "lib/wizardly/wizard/configuration.rb", "lib/wizardly/wizard/dsl.rb", "lib/wizardly/wizard/page.rb", "lib/wizardly/wizard/text_helpers.rb", "lib/wizardly/wizard/utils.rb", "lib/wizardly/wizard.rb", "lib/wizardly.rb", "rails_generators/wizardly_app", "rails_generators/wizardly_app/templates", "rails_generators/wizardly_app/templates/wizardly.rake", "rails_generators/wizardly_app/USAGE", "rails_generators/wizardly_app/wizardly_app_generator.rb", "rails_generators/wizardly_controller", "rails_generators/wizardly_controller/templates", "rails_generators/wizardly_controller/templates/controller.rb.erb", "rails_generators/wizardly_controller/templates/helper.rb.erb", "rails_generators/wizardly_controller/USAGE", "rails_generators/wizardly_controller/wizardly_controller_generator.rb", "rails_generators/wizardly_scaffold", "rails_generators/wizardly_scaffold/templates", "rails_generators/wizardly_scaffold/templates/form.html.erb", "rails_generators/wizardly_scaffold/templates/helper.rb.erb", "rails_generators/wizardly_scaffold/templates/layout.html.erb", "rails_generators/wizardly_scaffold/templates/style.css", "rails_generators/wizardly_scaffold/USAGE", "rails_generators/wizardly_scaffold/wizardly_scaffold_generator.rb", "CHANGELOG.rdoc", "init.rb", "LICENSE", "README.rdoc"]
  s.homepage = %q{http://github.com/jeffp/wizardly/tree/master}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Produces controllers and wizard scaffolding for models with validation_groups}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end