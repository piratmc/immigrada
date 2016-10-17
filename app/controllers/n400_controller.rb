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
                "The idea of self-government is in the first three words of the Constitution.\nWhat are these words?",
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
                'What stops one branch of government from becoming too powerful?',
                'Who is in charge of the executive branch?',
                'Who makes the federal laws?',
                'What are the <i><u>two</u></i> parts of the U.S. Congress?',
                'How many U.S. Senators are there?',
                'We elect a U.S. Senator for how many years?',
                'Who is <i><u>one</u></i> of your state\'s U.S. Senators now?',
                'The House of Representatives has how many voting members?',
                'We elect a U.S. Representative for how many years?',
                'Name your U.S. Representative.',
                'Who does a U.S. Senator represent?',
                'Why do some states have more Representatives than other states?',
                'We elect President for how many years?',
                'In what month do we vote for President?',
                'What is a name of the President of the United States now?',
                'What is the name of the Vice President of the United States now?',
                'If the President can no longer serve, who becomes President?',
                'If the President and the Vice President can no longer serve, who becomes President?',
                'Who is the Commander in  Chief of the military?',
                'Who signs bills to become laws?',
                'Who vetoes bills?',
                'What does the President\'s Cabinet do?',
                'What are <i><u>two</u></i> Cabinet-level positions?',
                'What does judicial branch do?',
                'What is the highest court in the United States?',
                'How many justices are on the Supreme Court?',
                'Who is the Chief Justice of the United States now?',
                "Under our Constitution, some powers belong to the federal government.\nWhat is <i><u>one</u></i> power of the federal government?",
                "Under our Constitution, some powers belong to the states.\nWhat is <i><u>one</u></i> power of the states?",
                'Who is the Governor of your state now?',
                'What is the capital of your state?',
                'What are <i><u>two</u></i> major political parties in the Unites States?',
                'What is a political party of the President now?',
                'What is the name of the Speaker of the House of Representatives now?',
                "There are four amendments to the Constitution about who can vote.\nDescribe <i><u>one</u></i> of them.",
                'What is <i><u>one</u></i> responsibility that is only for United States citizens?',
                'Name <i><u>one</u></i> right only for United States citizens.',
                'What are <i><u>two</u></i> rights of everyone living in the United States?',
                'What do we show loyalty to when we say the Pledge of Allegiance?',
                'What is <i><u>one</u></i> promise you make when you become a United States citizen?',
                'How old do citizens have to be to vote for President?',
                'What are <i><u>two</u></i> ways that Americans can participate in their democracy?',
                'When is the last day you can send in federal income tax forms?',
                'When must all men register for Selective Service?',
                'What is <i><u>one</u></i> reason colonists came to America?',
                'Who lived in America before the Europeans arrived?',
                'What group of people was taken to America and sold as slaves?',
                'Why did the colonists fight the British?',
                'Who wrote the Declaration of Independence?',
                'When was the Declaration of Independence adopted?',
                "There were 13 original states.\nName <i><u>three</u></i>.",
                'What happened at the Constitutional Convention?',
                'When was the Constitution written?',
                "The Federalist Papers supported the passage of the U.S. Constitution.\nName <i><u>one</u></i> of the writers",
                'What is <i><u>one</u></i> thing Benjamin Franklin is famous for?',
                'Who is the \"Father of Our Country\"?',
                'Who was the first President?',
                'What territory did the United States buy from France in 1803?',
                'Name <i><u>one</u></i> war fought by United States in the 1800s.',
                'Name the U.S. war between the North and the South.',
                'Name <i><u>one</u></i> problem that led to Civil War.',
                'What was <i><u>one</u></i> important thing that Abraham Lincoln did?',
                'What did that in Emancipation Proclamation do?',
                'What did Susan B. Anthony do?',
                'Name <i><u>one</u></i> war fought by the United States in the 1900s.',
                'Who was President during World War I?',
                'Who was President during the Great Depression and World War II?',
                'Who did the United States fight in World War II?',
                'Before he was President, Eisenhower was a general. What war was he in?',
                'During the Cold War, what was the main concern of the United States?',
                'What movement tried to end racial discrimination?',
                'What did Martin Luther King Jr. do?',
                'What major event happened on September 11, 2001, in the United States?',
                'Name <i><u>one</u></i> American Indian tribe in the United States.',
                'Name <i><u>one</u></i> of the two longest rivers in United States.',
                'What ocean is on the West Coast of United States?',
                'What ocean is on the East Coast of United States?',
                'Name <i><u>one</u></i> U.S. territory.',
                'Name <i><u>one</u></i> state that borders Canada.',
                'Name <i><u>one</u></i> state that borders Mexico.',
                'What is the capital of the United States?',
                'Where is the Statue of Liberty?',
                'Why does the flag have 13 stripes?',
                'Why does the flag have 50 stars?',
                'What is the name of the national anthem?',
                'When do we celebrate Independence Day?',
                'Name <i><u>two</u></i> national US holidays.'
  ]

  $answers = ['the Constitution',
              ['sets up the government', 'defines the government', 'protects basic rights of Americans'],
              'We the People',
              ['a change', 'an addition'],
              'the Bill of Rights',
              ['speech', 'religion', 'assembly', 'press', 'petition the government'],
              'twenty seven',
              ['announced our independence', 'declared our independence', 'said that the United States is free'],
              ['life', 'liberty', 'pursuit of happiness'],
              'you can practice any religion, or not practice a religion',
              ['capitalist economy', 'market economy'],
              ['everyone must follow the law', 'leaders must obey the law', 'government must obey the law',
               'no one is above the law'],
              ['Congress', 'legislative', 'President', 'executive', 'the courts', 'judicial'],
              ['checks and balances', 'separation of powers'],
              'the President',
              ['Congress', 'Senate and House', 'legislature'],
              'the Senate and the House',
              'one hundred',
              'six',
              ['Alexander, Lamar - TN',
               'Ayotte, Kelly - NH',
               'Baldwin, Tammy - WI',
               'Barrasso, John - WY',
               'Bennet, Michael F. - CO',
               'Blumenthal, Richard - CT',
               'Blunt, Roy - MO',
               'Booker, Cory A. - NJ',
               'Boozman, John - AR',
               'Boxer, Barbara - CA',
               'Brown, Sherrod - OH',
               'Burr, Richard - NC',
               'Cantwell, Maria - WA',
               'Capito, Shelley Moore - WV',
               'Cardin, Benjamin L. - MD',
               'Carper, Thomas R. - DE',
               'Casey, Robert P., Jr. - PA',
               'Cassidy, Bill - LA',
               'Coats, Daniel - IN',
               'Cochran, Thad - MS',
               'Collins, Susan M. - ME',
               'Coons, Christopher A. - DE',
               'Corker, Bob - TN',
               'Cornyn, John - TX',
               'Cotton, Tom - AR',
               'Crapo, Mike - ID',
               'Cruz, Ted - TX',
               'Daines, Steve - MT',
               'Donnelly, Joe - IN',
               'Durbin, Richard J. - IL',
               'Enzi, Michael B. - WY',
               'Ernst, Joni - IA',
               'Feinstein, Dianne - CA',
               'Fischer, Deb - NE',
               'Flake, Jeff - AZ',
               'Franken, Al -  MN',
               'Gardner, Cory - CO',
               'Gillibrand, Kirsten E. - NY',
               'Graham, Lindsey - SC',
               'Grassley, Chuck - IA',
               'Hatch, Orrin G. - UT',
               'Heinrich, Martin - NM',
               'Heitkamp, Heidi - ND',
               'Heller, Dean - NV',
               'Hirono, Mazie K. - HI',
               'Hoeven, John - ND',
               'Inhofe, James M. - OK',
               'Isakson, Johnny - GA',
               'Johnson, Ron - WI',
               'Kaine, Tim - VA',
               'King, Angus S., Jr. - ME',
               'Kirk, Mark - IL',
               'Klobuchar, Amy - MN',
               'Lankford, James - OK',
               'Leahy, Patrick J. - VT',
               'Lee, Mike - UT',
               'Manchin, Joe, III - WV',
               'Markey, Edward J. - MA',
               'McCain, John - AZ',
               'McCaskill, Claire - MO',
               'McConnell, Mitch - KY',
               'Menendez, Robert - NJ',
               'Merkley, Jeff - OR',
               'Mikulski, Barbara A. - MD',
               'Moran, Jerry - KS',
               'Murkowski, Lisa - AK',
               'Murphy, Christopher - CT',
               'Murray, Patty - WA',
               'Nelson, Bill - FL',
               'Paul, Rand - KY',
               'Perdue, David - GA',
               'Peters, Gary C. - MI',
               'Portman, Rob - OH',
               'Reed, Jack - RI',
               'Reid, Harry - NV',
               'Risch, James E. - ID',
               'Roberts, Pat - KS',
               'Rounds, Mike - SD',
               'Rubio, Marco - FL',
               'Sanders, Bernard - VT',
               'Sasse, Ben - NE',
               'Schatz, Brian - HI',
               'Schumer, Charles E. - NY',
               'Scott, Tim - SC',
               'Sessions, Jeff - AL',
               'Shaheen, Jeanne - NH',
               'Shelby, Richard C. - AL',
               'Stabenow, Debbie - MI',
               'Sullivan, Daniel - AK',
               'Tester, Jon - MT',
               'Thune, John - SD',
               'Tillis, Thom - NC',
               'Toomey, Patrick J. - PA',
               'Udall, Tom - NM',
               'Vitter, David - LA',
               'Warner, Mark R. - VA',
               'Warren, Elizabeth - MA',
               'Whitehouse, Sheldon - RI',
               'Wicker, Roger F. - MS',
               'Wyden, Ron - OR'],
              'four hundred thirty five',
              'two',
              'вам нужно поискать ответ в интернете',
              'all people of the state',
              ['the state\'s population', 'they have more people', 'some states have more people'],
              'four',
              'November',
              ['Barack Obama', 'Obama'],
              ['Joseph R. Biden, Jr.', 'Joe Biden', 'Biden'],
              'the Vice President',
              'the Speaker of the House',
              'the President',
              'the President',
              'the President',
              'advises the President',
              ['Secretary of Agriculture', 'Secretary of Commerce', 'Secretary of Defence', 'Secretary of Education',
               'Secretary of Energy', 'Secretary of Health and Human Services', 'Secretary of Homeland Security',
               'Secretary of Housing and Urban Development', 'Secretary of the Interior', 'Secretary of Labour',
               'Secretary of State', 'Secretary of Transportation', 'Secretary of the Treasury',
               'Secretary of Veterans Affairs', 'Attorney General', 'Vice President'],
              ['reviews laws', 'explains laws', 'resolves disputes', 'decides if the law goes against the Constitution'],
              'the Supreme Court',
              'nine',
              'John Roberts',
              ['to print money', 'to declare war', 'to create an army', 'to make treaties'],
              ['provide schooling and education', 'provide protection', 'provide safety', 'give a driver\'s license', 'approve zoning and land use'],
              'вам нужно поискать ответ в интернете',
              ['Montgomery AL', 'Juneau AK', 'Phoenix	AZ', 'Little Rock AR', 'Sacramento CA', 'Denver CO', 'Hartford CT',
               'Dover DE', 'Tallahassee	FL', 'Atlanta GA', 'Honolulu HI', 'Boise ID', 'Springfield IL', 'Indianapolis IN',
               'Des Moines IA', 'Topeka	KS', 'Frankfort	KY', 'Baton Rouge	LA', 'Augusta	ME', 'Annapolis	MD', 'Boston MA',
               'Lansing	MI', 'Saint Paul	MN', 'Jackson	MS', 'Jefferson City MO', 'Helena MT', 'Lincoln	NE', 'Carson City	NV',
               'Concord	NH', 'Trenton	NJ', 'Santa Fe NM', 'Albany NY', 'Raleigh	NC', 'Bismarck ND', 'Columbus OH',
               'Oklahoma City	OK', 'Salem	OR', 'Harrisburg PA', 'Providence RI', 'Columbia SC', 'Pierre SD',
               'Nashville	TN', 'Austin TX', 'Salt Lake City UT', 'Montpelier VT', 'Richmond VA', 'Olympia	WA',
               'Charleston WV', 'Madison	WI', 'Cheyenne WY'],
              'Democratic and Republican',
              'Democratic',
              ['Paul D. Ryan', 'Paul Ryan', 'Ryan'],
              ['citizens eighteen and older', 'you don\'t have to pay to vote', 'any citizen can vote', 'a male citizen of any race'],
              ['serve on a jury', 'vote in a federal election'],
              ['vote in a federal election', 'run for federal office'],
              ['freedom of expression', 'freedom of speech', 'freedom of assembly', 'freedom to petition the government',
               'freedom of religion', 'the right to bear arms'],
              ['the United States', 'the flag'],
              ['give up loyalty to other countries', 'defend the Constitution and laws of the United States',
               'obey the laws of the United States', 'serve in U.S. military (if needed)', 'serve (do important work for) the nation (if needed)',
               'be loyal to the United States'],
              'eighteen and older',
              ['vote', 'join a political party', 'help with a campaign', 'join a civic group', 'join a community group',
               'give an elected official your opinion on an issue', 'call Senators and Representatives',
               'publicly support or oppose an issue or policy', 'run for office', 'wright to a newspaper'],
              'April 15',
              ['at age eighteen', 'between eighteen and twenty six'],
              ['freedom', 'political liberty', 'religious freedom', 'economic opportunity', 'practice their religion', 'escape persecution'],
              ['American Indians', 'Native Americans'],
              ['Africans', 'people from Africa'],
              ['because of high taxes', 'because the British army stayed in their houses', 'because they didn\'t have self-government'],
              'Thomas Jefferson',
              'July 4, 1776',
              ['New Hampshire', 'Massachusetts', 'Rhode Island', 'Connecticut', 'New York', 'New Jersey ', 'Pennsylvania',
               'Delaware', 'Maryland', 'Virginia', 'North Carolina', 'South Carolina', 'Georgia'],
              ['the Constitution was written', 'the Founding Fathers wrote the Constitution'],
              '1787',
              ['James Madison', 'Alexander Hamilton', 'John Jay', 'Publius'],
              ['U.S. diplomat', 'oldest member of the constitutional convention', 'first Postmaster General on the United States',
               'writer of Poor Richard\'s Almanac', 'started the first free libraries'],
              'George Washington',
              'George Washington',
              ['the Louisiana Territory', 'Louisiana'],
              ['War of 1812', 'Mexican-American War', 'Civil War', 'Spanish-American War'],
              ['the Civil War', 'the War between the States'],
              ['slavery', 'economic reasons', 'states\' rights'],
              ['freed the slaves', 'saved the Union', 'led the United States during the Civil War'],
              ['freed the slaves', 'freed slaves in the Confederacy', 'freed slaves in the Confederate states',
               'freed slaves in most Southern states'],
              ['fought for woman\'s rights', 'fought for civil rights'],
              ['First World War', 'Second World War', 'Korean War', 'Vietnam War', 'Golf War'],
              'Woodrow Wilson',
              'Franklin Roosevelt',
              'Japan, Germany, Italy',
              'Second World War',
              'Communism',
              'civil rights',
              ['fought for civil rights', 'worked for equality for all Americans'],
              'terrorists attacked the United States',
              %w(Cherokee Navajo Siuox Chippewa Choctaw Pueblo Apache Iroquois Creek Blackfeet Seminole Cheyenne Arawak Shawanee Mohegan Huron Oneida Lakota Crow Teton Hopi Inuit),
              %w(Missouri Mississippi),
              'Pacific',
              'Atlantic',
              ['Puerto Rico', 'U.S. Virgin Islands', 'American Samoa', 'Northam Marshall Islands', 'Guam'],
              ['Main', 'New Hampshire', 'Vermont', 'New York', 'Pennsylvania', 'Ohio', 'Michigan', 'Minnesota', 'North Dakota', 'Montana', 'Idaho', 'Washington', 'Alaska'],
              ['California', 'Arizona', 'New Mexico', 'Texas'],
              'Washington, D.C.',
              ['New York', 'Liberty Island'],
              ['because there were thirteen original colonies', 'because the stripes represent the original colonies'],
              ['because there is one star for each state', 'because each star represents estate', 'because there are fifty states'],
              'the Star-Spangled Banner',
              'July 4',
              ['New Year\'s Day', 'Martin Luther King Jr. Day', 'Presidents\' Day', 'Memorial Day',
               'Independence Day', 'Labor Day', 'Columbus Day', 'Veterans Day', 'Thanksgiving', 'Christmas']
  ]

  def next_question_index(asked_array)
    index = rand(0...$questions.length)
    while asked_array.include?(index)
      index = rand(0...$questions.length)
    end

    return index
  end

  def trainer
    if params['commit'] == 'Ответить' or params['commit'] == 'Пропустить'

      @asked = params[:asked].gsub('[', '').gsub(']', '').split(' ').collect { |each| each.to_i }
      @answered = params[:answered].to_i

      case params['commit']
        when 'Ответить'
          @index = params[:index].to_i
          correct_answer = $answers[@index]

          if correct_answer.class == Array
            user_answer_array = params[:answer].split(', ')

            if user_answer_array.all? { |answer| correct_answer.include?(answer) }
              @index = next_question_index(@asked)
              @asked << @index
              @answered += 1
            else
              @wrong_answer = true
            end

          else
            if params[:answer] == correct_answer
              @index = next_question_index(@asked)
              @asked << @index
              @answered += 1
            else
              @wrong_answer = true
            end
          end
        when 'Пропустить'
          @asked.pop
          @index = next_question_index(@asked)
          @asked << @index
      end
      @current_question = $questions[@index]
      @correct_answer = $answers[@index]
      @correct_answer = @correct_answer.map { |each| each.to_s }.join(', ') if @correct_answer.class == Array
      @intro = false
      @answered.nil? ? @percent = 0 : @percent = @answered * 10
    else
      @title = 'Проверим, как хорошо вы готовы к тесту на гражданство'
      @intro = true
      @asked = []
      @answered = @percent= 0
      @index = next_question_index(@asked)
      @asked << @index
      @current_question = $questions[@index]
      @correct_answer = $answers[@index]
      @correct_answer = @correct_answer.map { |each| each.to_s }.join(', ') if @correct_answer.class == Array
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
