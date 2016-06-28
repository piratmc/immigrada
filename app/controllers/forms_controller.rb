class FormsController < ApplicationController
  require 'pdf-forms'

  def show
    @form_completed = nil
    @eligible = nil

    unless params.blank?
      case params['commit']
        when 'Check eligibility'
          redirect_to forms_n400_questionnaire_path
      end
    end
  end

  def n400_questionnaire
    @eligible = nil
    @form_completed = nil

    unless params.blank?
      case params['commit']
        when 'Submit'
          @eligible = true if params['killer'] == 'No'
          @eligible = false if params['killer'] == 'Yes'
        when 'Start application'
          redirect_to forms_n400_path
      end
    end
  end

  def n400
    @form_completed = nil
    @eligible = nil

    unless params.blank?
      case params['commit']
        when 'Submit'
          pdftk = PdfForms.new('/app/bin/pdftk')
          file_path = Dir.pwd + '/lib/assets/forms/n-400.pdf'

          puts pdftk.get_field_names file_path

          form = Hash.new
          form[:a_number] = params['a_number']
          # form[:Alexei1] = 'A'
          form[:last_name] = params['last_name']
          form[:first_name] = params['first_name']
          form[:gc_last_name] = params['gc_last_name']
          form[:gc_first_name] = params['gc_first_name']

          pdftk.fill_form file_path, Dir.pwd + '/lib/assets/completed/filled_form.pdf', form

          @form_completed = true
        when 'Download PDF'
          send_file Dir.pwd + '/lib/assets/completed/filled_form.pdf'
      end
    end
  end
end
