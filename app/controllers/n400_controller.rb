class N400Controller < ApplicationController
  require 'pdf-forms'

  def questionnaire
    @eligible = nil
    @form_completed = nil
    @title = 'Проверим, можете те ли вы подать на гражданство США:'
    @current_question_string = 'Вам больше 18 лет?'
    @current_question = :age_ok

    unless params.blank?
      case params['commit']
        # when 'Назад'
        #   redirect_to :back
        when 'Далее'
          if params[:age_ok]
            if params[:age_ok] == 'true'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Bы имеете грин карту 5 лет или больше?'
              @current_question = :gc_5_years
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вам необходимо быть старше 18 лет. Но вы можете стать гражданином, если: а) ваши родители стали гражданами до того, как вам исполнилось 18 лет и у вас была грин карта; б) если вы в данный момент служите в вооруженных силах США. Обратитесь к нам в офис для рассмотрения вашей ситуации.'
            end
          end

          if params[:gc_5_years]
            if params[:gc_5_years] == 'true'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Находились ли вы последние 2.5 года в США, не беря во внимание коротких заграничных поездок?'
              @current_question = :lived_30_months_in_us
            else
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Bы имеете грин карту 3 года или больше?'
              @current_question = :gc_3_years
            end
          end

          if params[:lived_30_months_in_us]
            if params[:lived_30_months_in_us] == 'true'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Последние 3 месяца вы жили в штате, из которого подаете на гражданство?'
              @current_question = :last_3_months_in_us
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вам необходимо прожить в США последние два с половиной года, не беря во внимание коротких заграничных поездок.'
            end
          end

          if params[:gc_3_years]
            if params[:gc_3_years] == 'true'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Вы получили грин карту на основании брака с гражданином США?'
              @current_question = :married
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вам необходимо иметь грин карту 3 года, если она получена на основании брака с гражданином США, и 5 лет во всех остальных случаях.'
            end
          end

          if params[:married]
            if params[:married] == 'true'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Вы женаты на этом человеке последние 3 года?'
              @current_question = :married_for_3_years
            else
              @eligible = @more_to_ask = false
              @alert = 'Вам необходимо обратится к нам в офиц для детального рассмотрения вашый ситуации.'
            end
          end

          if params[:married_for_3_years]
            if params[:married_for_3_years] == 'true'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Вы находились последние 18 месяцев в США, не беря во внимание коротких заграничных поездок?'
              @current_question = :lived_18_months_in_us
            else
              @eligible = @more_to_ask = false
              @alert = 'Вам необходимо обратится к нам в офис для детального рассмотрения вашей ситуации.'
            end
          end

          if params[:lived_18_months_in_us]
            if params[:lived_18_months_in_us] == 'true'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Последние 3 месяца вы жили в штате, из которого подаете на гражданство?'
              @current_question = :last_3_months_in_us
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вам необходимо прожить в США последние 18 месяцев, не беря во внимание коротких заграничных поездок.'
            end
          end

          if params[:last_3_months_in_us]
            if params[:last_3_months_in_us] == 'true'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Вас когда нибудь судили или арестовывали на территории США?'
              @current_question = :criminal
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вам необходимо проживать в штате, из которого вы подаете на гражданство.'
            end
          end

          if params[:criminal]
            if params[:criminal] == 'false'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Можете ли вы читать и писать по-английски на базовом уровне?'
              @current_question = :english
            else
              @eligible = @more_to_ask = false
              @alert = 'Вам необходимо обратиться к нам в офис для детального рассмотрения вашей ситуации.'
            end
          end

          if params[:english]
            if params[:english] == 'true'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Можете ли вы запомнить и быть готобым ответить на 100 вопросов об истории и устройстве США на английском языке?'
              @current_question = :history
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вам необходимо иметь базовый английский.'
            end
          end

          if params[:history]
            if params[:history] == 'true'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Служили ли вы в Вооруженных Силах США?'
              @current_question = :been_in_military
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вам необходимо выучиты и быть готобым ответить на 100 вопросов по истории и устройству США на английском языке.'
            end
          end

          if params[:been_in_military]
            if params[:been_in_military] == 'true'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Дезертировали ли вы со службы в вооруженных силах США?'
              @current_question = :deserted_from_military
            else
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Согласны ли вы идти на военную или гражданскую службу, если того потребует закон?'
              @current_question = :fight_if_needed
            end
          end

          if params[:deserted_from_military]
            if params[:deserted_from_military] == 'false'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Отстраняли ли вас от службы в вооруженных силах США?'
              @current_question = :discharged_from_military
            else
              @eligible = @more_to_ask = false
              @alert = 'Вам необходимо обратиться к нам в офис для детального рассмотрения вашей ситуации.'
            end
          end

          if params[:discharged_from_military]
            if params[:discharged_from_military] == 'false'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Согласны ли вы идти на военную или гражданскую службу, если того потребует закон?'
              @current_question = :fight_if_needed
            else
              @eligible = @more_to_ask = false
              @alert = 'Вам необходимо обратиться к нам в офис для детального рассмотрения вашей ситуации.'
            end
          end

          if params[:fight_if_needed]
            if params[:fight_if_needed] == 'true'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Поддерживаете ли вы конституцию США?'
              @current_question = :support_constitution
            else
              @eligible = @more_to_ask = false
              @alert = 'Вам необходимо обратиться к нам в офис для детального рассмотрения вашей ситуации.'
            end
          end

          if params[:support_constitution]
            if params[:support_constitution] == 'true'
              @eligible = true
              @more_to_ask = false
            else
              @eligible = @more_to_ask = false
              @alert = 'Вам необходимо обратиться к нам в офис для детального рассмотрения вашей ситуации.'
            end
          end
        when 'Начать заполнение формы'
          redirect_to n400_form_path
      end
    end
  end

  def form
    @form_completed = nil
    @eligible = nil
    @current_question_string = nil
    @current_question = nil

    unless params.blank?
      case params['commit']
        when 'Submit'
          pdftk = PdfForms.new('/app/bin/pdftk')
          file_path = Dir.pwd + '/lib/assets/n400/n-400.pdf'

          puts pdftk.get_field_names file_path

          form = Hash.new
          form[:a_number] = params['a_number']
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
