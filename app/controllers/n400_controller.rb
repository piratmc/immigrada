class N400Controller < ApplicationController
  require 'pdf-forms'

  $questionnaire = Hash.new
  $questionnaire[:over_18] = 'Вам больше 18 лет?'
  $questionnaire[:gc_5_years] = 'Bы имеете грин карту 5 лет или больше?'
  $questionnaire[:gc_3_years] = 'Bы имеете грин карту 3 года или больше?'
  $questionnaire[:lived_30_months_in_us] = 'Находились ли вы последние 2.5 года в США, не беря во внимание коротких заграничных поездок?'
  $questionnaire[:last_3_months_in_us] = 'Последние 3 месяца вы жили в штате, из которого подаете на гражданство?'
  $questionnaire[:married] = 'Вы получили грин карту на основании брака с гражданином США?'
  $questionnaire[:married_for_3_years] = 'Вы женаты на этом человеке последние 3 года?'
  $questionnaire[:lived_18_months_in_us] = 'Вы находились последние 18 месяцев в США, не беря во внимание коротких заграничных поездок?'
  $questionnaire[:criminal] = 'Вас когда нибудь судили или арестовывали на территории США?'
  $questionnaire[:english] = 'Можете ли вы читать и писать по-английски на базовом уровне?'
  $questionnaire[:history] = 'Можете ли вы запомнить и быть готовым ответить на 100 вопросов об истории и устройстве США на английском языке?'
  $questionnaire[:been_in_military] = 'Служили ли вы в Вооруженных Силах США?'
  $questionnaire[:deserted_from_military] = 'Дезертировали ли вы со службы в Вооруженных Силах США?'
  $questionnaire[:discharged_from_military] = 'Отстраняли ли вас от службы в Вооруженных Силах США?'
  $questionnaire[:fight_if_needed] = 'Согласны ли вы идти на военную или гражданскую службу, если того потребует закон?'
  $questionnaire[:support_constitution] = 'Поддерживаете ли вы конституцию США?'

  $questions = ['What is a supreme law of the land?',
                'What does the Constitution do?',
                'The idea of self-government is in the first three words of the Constitution. What are these words?',
                'What is an amendment?',
                'What do we call first ten amendments to the Constitution?',
                'What is <i><u>one</u></i> right or freedom from the First Amendment?',
                'How many amendments does the Constitution have?',
                'What did the Declaration of Independence do?',
                'What are <i><u>two</u></i> rights in the Declaration of Independence?',
                'What is freedom of religion?',
                'What is the economic system in the United States?',
                'What is the "rule of law"?',
                'Name <i><u>one</u></i> branch or part of the government.',
                'What stops one branch of government from becoming too powerful?'

  ]

  $answers = Hash.new
  $answers[$questions[0]] = 'the Constitution'
  $answers[$questions[1]] = ['sets up the government', 'defines the government', 'protects basic rights of Americans']
  $answers[$questions[2]] = 'We the People'
  $answers[$questions[3]] = ['a change', 'an addition']
  $answers[$questions[4]] = 'the Bill of Rights'
  $answers[$questions[5]] = ['speech', 'religion', 'assembly', 'press', 'petition the government']
  $answers[$questions[6]] = 'twenty seven'
  $answers[$questions[7]] = ['announced our independence', 'declared out independence', 'said that the United States is free']
  $answers[$questions[8]] = ['life', 'liberty', 'pursuit of happiness']
  $answers[$questions[9]] = 'you can practice any religion, or not practice a religion'
  $answers[$questions[10]] = ['capitalist economy', 'market economy']
  $answers[$questions[11]] = ['everyone must follow the law', 'leaders must obey the law', 'government must obey the law',
                              'no one is above the law']
  $answers[$questions[12]] = ['Congress', 'legislative', 'President', 'executive', 'the courts', 'judicial']
  $answers[$questions[13]] = ['checks and balances', 'separation of powers']



  def trainer
    @title = 'Проверим, как хорошо вы готовы к тесту на гражданство'
    @intro = true
    @index = @percent = 0
    @current_question = $questions[0]
    @correct_answer = $answers[$questions[@index]]

    unless params.blank?
      case params['commit']
        # when 'Назад'
        #   redirect_to :back
        when 'Ответить'
          index = params[:index].to_i
          correct_answer = $answers[$questions[index]]

          if $answers[$questions[index]].class == Array
            user_answer_array = params[:answer].split(', ')

            if user_answer_array.all? {|answer| correct_answer.include?(answer)}
              @index = index + 1
              @percent = @index * 10
            else
              @index = index
              @percent = @index * 10
              @wrong_answer = true
            end
          else
            if params[:answer] == correct_answer
              @index = index + 1
              @percent = @index * 10
            else
              @index = index
              @percent = @index * 10
              @wrong_answer = true
            end
          end
          @correct_answer = $answers[$questions[@index]]
          @correct_answer = @correct_answer.map {|each| each.to_s}.join(', ') if @correct_answer.class == Array
          @current_question = $questions[@index]
          @intro = false
      end
    end

  end

  def questionnaire
    @eligible = nil
    @form_completed = nil
    @title = 'Проверим, можете те ли вы подать на гражданство США:'
    @current_question = :over_18
    @info_link = nil
    @percent = 0
    total_steps = 10

    unless params.blank?
      case params['commit']
        # when 'Назад'
        #   redirect_to :back
        when 'Далее'
          if params[:over_18]
            if params[:over_18] == 'true'
              @eligible = @more_to_ask = true
              @current_question = :gc_5_years
              @percent = 1*100/total_steps
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вам необходимо быть старше 18 лет. Но вы можете стать гражданином, если: а) ваши родители стали гражданами до того, как вам исполнилось 18 лет и у вас была грин карта; б) если вы в данный момент служите в вооруженных силах США. Обратитесь к нам в офис для рассмотрения вашей ситуации.'
            end
          end

          if params[:gc_5_years]
            if params[:gc_5_years] == 'true'
              @eligible = @more_to_ask = true
              @current_question = :lived_30_months_in_us
              @percent = 2*100/total_steps
            else
              @eligible = true
              @more_to_ask = true
              @current_question = :gc_3_years
              @percent = 2*100/total_steps
            end
          end

          if params[:lived_30_months_in_us]
            if params[:lived_30_months_in_us] == 'true'
              @eligible = @more_to_ask = true
              @current_question = :last_3_months_in_us
              @percent = 3*100/total_steps
            else
              @eligible = @more_to_ask = false
              @alert = 'Вам необходимо обратится к нам в офис для детального рассмотрения вашей ситуации.'
            end
          end

          if params[:gc_3_years]
            if params[:gc_3_years] == 'true'
              @eligible = @more_to_ask = true
              @current_question = :married
              @percent = 2.3*100/total_steps
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вам необходимо иметь грин карту 3 года, если она получена на основании брака с гражданином США, и 5 лет во всех остальных случаях.'
            end
          end

          if params[:married]
            if params[:married] == 'true'
              @eligible = @more_to_ask = true
              @current_question = :married_for_3_years
              @percent = 2.6*100/total_steps
            else
              @eligible = @more_to_ask = false
              @alert = 'Вам необходимо дождаться 5 лет со времени получения вами грин карты.'
            end
          end

          if params[:married_for_3_years]
            if params[:married_for_3_years] == 'true'
              @eligible = @more_to_ask = true
              @current_question = :lived_18_months_in_us
              @percent = 2.9*100/total_steps
            else
              @eligible = @more_to_ask = false
              @alert = 'Вам необходимо обратится к нам в офис для детального рассмотрения вашей ситуации.'
            end
          end

          if params[:lived_18_months_in_us]
            if params[:lived_18_months_in_us] == 'true'
              @eligible = @more_to_ask = true
              @current_question = :last_3_months_in_us
              @percent = 3*100/total_steps
            else
              @eligible = @more_to_ask = false
              @alert = 'Вам необходимо обратится к нам в офис для детального рассмотрения вашей ситуации.'
            end
          end

          if params[:last_3_months_in_us]
            if params[:last_3_months_in_us] == 'true'
              @eligible = @more_to_ask = true
              @current_question = :criminal
              @percent = 4*100/total_steps
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вам необходимо проживать последние 3 месяца в штате, из которого вы подаете на гражданство.'
            end
          end

          if params[:criminal]
            if params[:criminal] == 'false'
              @eligible = @more_to_ask = true
              @current_question = :english
              @percent = 5*100/total_steps
            else
              @eligible = @more_to_ask = false
              @alert = 'Вам необходимо обратиться к нам в офис для детального рассмотрения вашей ситуации.'
            end
          end

          if params[:english]
            if params[:english] == 'true'
              @eligible = @more_to_ask = true
              @current_question = :history
              @info_link_title = 'Ссылка на вопросы'
              @info_link = 'https://www.uscis.gov/sites/default/files/USCIS/Office%20of%20Citizenship/Citizenship%20Resource%20Center%20Site/Publications/100q.pdf'
              @percent = 6*100/total_steps
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вам необходимо уметь читать и писать на базовом английском.'
            end
          end

          if params[:history]
            if params[:history] == 'true'
              @eligible = @more_to_ask = true
              @current_question = :been_in_military
              @percent = 7*100/total_steps
            else
              @eligible = @more_to_ask = false
              @alert = 'Для подачи на гражданство вам необходимо выучить и быть готовым ответить на 100 вопросов по истории и устройству США на английском языке.'
            end
          end

          if params[:been_in_military]
            if params[:been_in_military] == 'true'
              @eligible = @more_to_ask = true
              @current_question = :deserted_from_military
              @percent = 8*100/total_steps
            else
              @eligible = true
              @more_to_ask = true
              @current_question = :fight_if_needed
              @percent = 8*100/total_steps
            end
          end

          if params[:deserted_from_military]
            if params[:deserted_from_military] == 'false'
              @eligible = @more_to_ask = true
              @current_question = :discharged_from_military
              @percent = 8.3*100/total_steps
            else
              @eligible = @more_to_ask = false
              @alert = 'Вам необходимо обратиться к нам в офис для детального рассмотрения вашей ситуации.'
            end
          end

          if params[:discharged_from_military]
            if params[:discharged_from_military] == 'false'
              @eligible = @more_to_ask = true
              @current_question = :fight_if_needed
              @percent = 8.6*100/total_steps
            else
              @eligible = @more_to_ask = false
              @alert = 'Вам необходимо обратиться к нам в офис для детального рассмотрения вашей ситуации.'
            end
          end

          if params[:fight_if_needed]
            if params[:fight_if_needed] == 'true'
              @eligible = @more_to_ask = true
              @current_question = :support_constitution
              @percent = 9*100/total_steps
            else
              @eligible = @more_to_ask = false
              @alert = 'Вам необходимо обратиться к нам в офис для детального рассмотрения вашей ситуации.'
            end
          end

          if params[:support_constitution]
            if params[:support_constitution] == 'true'
              @eligible = true
              @more_to_ask = false
              @percent = 10*100/total_steps
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
