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
              @current_question_string = 'Bы имеете грин карту 5 лет и больше?'
              @current_question = :gc_5_years
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вам необходимо быть старше 18 лет. Но, вы можете стать грагданину по упрощенноы програме. Обратитесь к нам в офис:а) если ваши родители стали гражданами до того как вам исполнилось 18 лет и у вас была грин карта; б) елси вы на данный момент служите в Вооруженных силах США.'
            end
          end

          if params[:gc_5_years]
            if params[:gc_5_years] == 'true'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Вы жили последние 2.5 года в США?'
              @current_question = :lived_30_months_in_us
            else
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Bы имеете грин карту 3 года и больше?'
              @current_question = :gc_3_years
            end
          end

          if params[:lived_30_months_in_us]
            if params[:lived_30_months_in_us] == 'true'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Вы жили последние 3 месяца в штате из которого подаете на гражданство?'
              @current_question = :last_3_months_in_us
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вам необходимо прожить в США как минимум два с половиной года.'
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
              @alert = 'Для подачи на гражданство вам необходимо иметь грин карту 3 года и больше.'
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
              @alert = 'Для подачи на гражданство вам необходимо быть женатым на гражданине США или дождаться 5 лет от даты выдачи вам грин карты.'
            end
          end

          if params[:married_for_3_years]
            if params[:married_for_3_years] == 'true'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Вы жили в США последние 18 месяцев?'
              @current_question = :lived_18_months_in_us
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вам необходимо быть женатым на гражданине США последние 3 года или дождаться 5 лет от даты выдачи вам грин карты.'
            end
          end

          if params[:lived_18_months_in_us]
            if params[:lived_18_months_in_us] == 'true'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'За последние 5 лет, были ли у вас поездки за пределы США продолжитеьностью 1 год и более?'
              @current_question = :one_year_trips
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вам необходимо быть за пределами США менее 18 месяцев за последние 3 года.'
            end
          end

          if params[:one_year_trips]
            if params[:one_year_trips] == 'false'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Вы жили в США последние 3 месяца?'
              @current_question = :last_3_months_in_us
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вы не можете иметь поездки за пределы США длительностью 1 год и более за последние 5 лет.'
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
              @alert = 'Для подачи на гражданство вам необходимо находиться в США последние 3 месяца.'
            end
          end

          if params[:criminal]
            if params[:criminal] == 'false'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Можете ли вы читать и писать по-английски?'
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
              @current_question_string = 'Можете ли вы запомнить ответы на 100 вопросов об истории и устройстве США?'
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
              @current_question_string = 'Вы человек с хорошими моральными качествами?'
              @current_question = :good_man
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вам необходимо выучить ответы на 100 вопросов по истории и устройству США'
            end
          end

          if params[:good_man]
            if params[:good_man] == 'true'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Служили ли вы в Вооруженных Силах США?'
              @current_question = :been_in_military
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вам необходимо быть человек с хорошими моральными качествами.'
            end
          end

          if params[:been_in_military]
            if params[:been_in_military] == 'true'
              @eligible = true
              @more_to_ask = true
              @current_question_string = 'Дезертировали ли вы со службы в Вооруженных Силах США?'
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
              @current_question_string = 'Отстраняли ли вас от службы в Вооруженных Силах США?'
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

          # if params[:us_parents_before_18]
          #   if params[:us_parents_before_18] == 'true'
          #     @eligible = true
          #     @more_to_ask = false
          #     @alert = 'Вам необходимо обратиться к нам в офис т.к. в вашем случае вы можете получить гражданство автоматически.'
          #     @current_question = @current_question_string = nil
          #   else
          #     @eligible = true
          #     @title = nil
          #     @more_to_ask = false
          #   end
          # end
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
