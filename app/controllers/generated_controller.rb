#
# GeneratedController class generated by wizardly_controller
#

class GeneratedController < ApplicationController
  before_filter :guard_entry

  
  # finish action method
  def finish
    begin
      @step = :finish
      @wizard = wizard_config
      @title = 'Finish'
      @description = ''
      _build_wizard_model
      if request.post? && callback_performs_action?(:_on_post_finish_form)
        raise CallbackError, "render or redirect not allowed in :on_post(:finish) callback", caller
      end
      button_id = check_action_for_button
      return if performed?
      if request.get?
        return if callback_performs_action?(:_on_get_finish_form)
        render_wizard_form
        return
      end

      # @user.enable_validation_group :finish
      unless @user.valid?(:finish)
        return if callback_performs_action?(:_on_invalid_finish_form)
        render_wizard_form
        return
      end

      @do_not_complete = false
      callback_performs_action?(:_on_finish_form_finish)
      complete_wizard unless @do_not_complete
    ensure
      _preserve_wizard_model
    end
  end        


  # init action method
  def init
    begin
      @step = :init
      @wizard = wizard_config
      @title = 'Init'
      @description = ''
      _build_wizard_model
      if request.post? && callback_performs_action?(:_on_post_init_form)
        raise CallbackError, "render or redirect not allowed in :on_post(:init) callback", caller
      end
      button_id = check_action_for_button
      return if performed?
      if request.get?
        return if callback_performs_action?(:_on_get_init_form)
        render_wizard_form
        return
      end

      # @user.enable_validation_group :init
      unless @user.valid?(:init)
        return if callback_performs_action?(:_on_invalid_init_form)
        render_wizard_form
        return
      end

      @do_not_complete = false
      if button_id == :finish
        callback_performs_action?(:_on_init_form_finish)
        complete_wizard unless @do_not_complete
        return
      end
      return if callback_performs_action?(:_on_init_form_next)
      redirect_to :action=>:second
    ensure
      _preserve_wizard_model
    end
  end        


  # second action method
  def second
    begin
      @step = :second
      @wizard = wizard_config
      @title = 'Second'
      @description = ''
      _build_wizard_model
      if request.post? && callback_performs_action?(:_on_post_second_form)
        raise CallbackError, "render or redirect not allowed in :on_post(:second) callback", caller
      end
      button_id = check_action_for_button
      return if performed?
      if request.get?
        return if callback_performs_action?(:_on_get_second_form)
        render_wizard_form
        return
      end

      # @user.enable_validation_group :second
      unless @user.valid?(:second)
        return if callback_performs_action?(:_on_invalid_second_form)
        render_wizard_form
        return
      end

      @do_not_complete = false
      if button_id == :finish
        callback_performs_action?(:_on_second_form_finish)
        complete_wizard unless @do_not_complete
        return
      end
      return if callback_performs_action?(:_on_second_form_next)
      redirect_to :action=>:finish
    ensure
      _preserve_wizard_model
    end
  end        

  def index
    redirect_to :action=>:init
  end



    protected
  def _on_wizard_finish
    return if @wizard_completed_flag
    @user.save(:validate => false) if @user.changed?
    @wizard_completed_flag = true
    reset_wizard_form_data
    _wizard_final_redirect_to(:completed)
  end
  def _on_wizard_skip
    self.progression = self.progression - [@step]
    redirect_to(:action=>wizard_config.next_page(@step)) unless self.performed?
  end
  def _on_wizard_back 
    redirect_to(:action=>(previous_in_progression_from(@step) || :init)) unless self.performed?
  end
  def _on_wizard_cancel
    _wizard_final_redirect_to(:canceled)
  end
  def _wizard_final_redirect_to(type)
    init = (type == :canceled && wizard_config.form_data_keep_in_session?) ?
      self.initial_referer :
      reset_wizard_session_vars
    unless self.performed?
      redir = (type == :canceled ? wizard_config.canceled_redirect : wizard_config.completed_redirect) || init
      return redirect_to(redir) if redir
      raise Wizardly::RedirectNotDefinedError, "No redirect was defined for completion or canceling the wizard.  Use :completed and :canceled options to define redirects.", caller
    end
  end
  hide_action :_on_wizard_finish, :_on_wizard_skip, :_on_wizard_back, :_on_wizard_cancel, :_wizard_final_redirect_to


    protected
  def do_not_complete; @do_not_complete = true; end
  def previous_in_progression_from(step)
    po = [:init, :second, :finish]
    p = self.progression
    p -= po[po.index(step)..-1]
    self.progression = p
    p.last
  end
  def check_progression
    p = self.progression
    a = params[:action].to_sym
    return if p.last == a
    po = [:init, :second, :finish]
    return unless (ai = po.index(a))
    p -= po[ai..-1]
    p << a
    self.progression = p
  end        
  # for :form_data=>:session
  def guard_entry 
    if (r = request.env['HTTP_REFERER'])
      begin
        h = Rails.application.routes.recognize_path(URI.parse(r).path, {:method=>:get})
      rescue
      else
        return check_progression if (h[:controller]||'') == 'generated'
        self.initial_referer = h unless self.initial_referer
      end
    end
    # coming from outside the controller or no route for GET
    
    if (params[:action] == 'init' || params[:action] == 'index')
      return check_progression
    elsif self.wizard_form_data
      p = self.progression
      return check_progression if p.include?(params[:action].to_sym)
      return redirect_to(:action=>(p.last||:init))
    end
    redirect_to :action=>:init
  end
  hide_action :guard_entry

  def render_and_return
    return if callback_performs_action?('_on_get_'+@step.to_s+'_form')
    render_wizard_form
    render unless self.performed?
  end

  def complete_wizard(redirect = nil)
    unless @wizard_completed_flag
      @user.save(:validate => false)
      callback_performs_action?(:_after_wizard_save)
    end
    redirect_to redirect if (redirect && !self.performed?)
    return if @wizard_completed_flag
    _on_wizard_finish
    redirect_to('/main/finished') unless self.performed?
  end
  def _build_wizard_model
    if self.wizard_config.persist_model_per_page?
      h = self.wizard_form_data
      if (h && model_id = h['id'])
          _model = User.find(model_id)
          _model.attributes = params[:user]||{}
          @user = _model
          return
      end
      @user = User.new(params[:user])
    else # persist data in session or flash
      h = (self.wizard_form_data||{}).merge(params[:user] || {})
      @user = User.new(h)
    end
  end
  def _preserve_wizard_model
    return unless (@user && !@wizard_completed_flag)
    if self.wizard_config.persist_model_per_page?
      @user.save(:validate => false)
      if request.get?
        @user.errors.clear
      else
        @user.reject_non_validation_group_errors
      end
      self.wizard_form_data = {'id'=>@user.id}
    else
      self.wizard_form_data = @user.attributes
    end
  end
  hide_action :_build_wizard_model, :_preserve_wizard_model

  def initial_referer
    session[:generated_irk]
  end
  def initial_referer=(val)
    session[:generated_irk] = val
  end
  def progression=(array)
    session[:generated_prg] = array
  end
  def progression
    session[:generated_prg]||[]
  end
  hide_action :progression, :progression=, :initial_referer, :initial_referer=

  def wizard_form_data=(hash)
    if wizard_config.form_data_keep_in_session?
      session[:generated_dat] = hash
    else
      if hash
        flash[:generated_dat] = hash
      else
        flash.discard(:generated_dat)
      end
    end
  end

  def reset_wizard_form_data; self.wizard_form_data = nil; end
  def wizard_form_data
    wizard_config.form_data_keep_in_session? ? session[:generated_dat] : flash[:generated_dat]
  end
  hide_action :wizard_form_data, :wizard_form_data=, :reset_wizard_form_data

  def render_wizard_form
  end
  hide_action :render_wizard_form

  def performed?; super; end
  hide_action :performed?

  def underscore_button_name(value)
    value.to_s.strip.squeeze(' ').gsub(/ /, '_').downcase
  end
  hide_action :underscore_button_name

  def reset_wizard_session_vars
    self.progression = nil
    init = self.initial_referer
    self.initial_referer = nil
    init
  end
  hide_action :reset_wizard_session_vars

  def check_action_for_button
    button_id = nil
    case 
    when params[:commit]
      button_name = params[:commit]
      button_id = underscore_button_name(button_name).to_sym
    when ((b_ar = self.wizard_config.buttons.find{|k,b| params[k]}) && params[b_ar.first] == b_ar.last.name)
      button_name = b_ar.last.name
      button_id = b_ar.first
    end
    if button_id
      unless [:next, :finish].include?(button_id) 
        action_method_name = "_on_" + params[:action].to_s + "_form_" + button_id.to_s
        callback_performs_action?(action_method_name)
        unless ((btn_obj = self.wizard_config.buttons[button_id]) == nil || btn_obj.user_defined?)
          method_name = "_on_wizard_" + button_id.to_s
          if (self.method(method_name))
            self.__send__(method_name)
          else
            raise MissingCallbackError, "Callback method either '" + action_method_name + "' or '" + method_name + "' not defined", caller
          end
        end
      end
    end
    button_id
  end
  hide_action :check_action_for_button

  @wizard_callbacks ||= []
  def self.wizard_callbacks; @wizard_callbacks; end

  def callback_performs_action?(methId)
    cache = self.class.wizard_callbacks
    return false if cache.include?(methId)

    if self.respond_to?(methId, true)
      self.send(methId)
    else
      cache << methId
      return false
    end
    
    self.performed?
  end
  hide_action :callback_performs_action?



    def self.on_post(*args, &block)
    self._define_action_callback_macro('on_post', '_on_post_%s_form', *args, &block)
  end
  def self.on_get(*args, &block)
    self._define_action_callback_macro('on_get', '_on_get_%s_form', *args, &block)
  end
  def self.on_errors(*args, &block)
    self._define_action_callback_macro('on_errors', '_on_invalid_%s_form', *args, &block)
  end
  def self.on_finish(*args, &block)
    self._define_action_callback_macro('on_finish', '_on_%s_form_finish', *args, &block)
  end
  def self.on_skip(*args, &block)
    self._define_action_callback_macro('on_skip', '_on_%s_form_skip', *args, &block)
  end
  def self.on_next(*args, &block)
    self._define_action_callback_macro('on_next', '_on_%s_form_next', *args, &block)
  end
  def self.on_back(*args, &block)
    self._define_action_callback_macro('on_back', '_on_%s_form_back', *args, &block)
  end
  def self.on_cancel(*args, &block)
    self._define_action_callback_macro('on_cancel', '_on_%s_form_cancel', *args, &block)
  end
  def self._define_action_callback_macro(macro_first, macro_last, *args, &block)
    return if args.empty?
    all_forms = [:init, :second, :finish]
    if args.include?(:all)
      forms = all_forms
    else
      forms = args.map do |fa|
        unless all_forms.include?(fa)
          raise(ArgumentError, ":"+fa.to_s+" in callback '" + macro_first + "' is not a form defined for the wizard", caller)
        end
        fa
      end
    end
    forms.each do |form|
      self.send(:define_method, sprintf(macro_last, form.to_s), &block )
      hide_action macro_last.to_sym
    end
  end

  def self.on_completed(&block)
    self.send(:define_method, :_after_wizard_save, &block )
  end


  public
  def wizard_config; self.class.wizard_config; end
  hide_action :wizard_config
  
  private

  def self.wizard_config; @wizard_config; end
  @wizard_config = Wizardly::Wizard::Configuration.create(:generated, :user, :allow_skip=>true) do
    when_completed_redirect_to '/main/finished'
    when_canceled_redirect_to '/main/canceled'
    
    # other things you can configure
    # change_button(:next).to('Next One')
    # change_button(:back).to('Previous')
    # create_button('Help')
    # set_page(:init).buttons_to :next_one, :previous, :cancel, :help #this removes skip
  end

end
