class TeacherEvaluationsGrid
  attr_reader :teacher
  attr_reader :students
  attr_reader :types
  attr_reader :evaluations

  def initialize(teacher, students, types, evaluations)
    @teacher = teacher
    @students = students
    @types = types
    @evaluations = evaluations
  end

  def data
    return @data if @data

    prepare   # prepare the instance variables, alloc the matrix
    populate  # insert the data into the @data variable
    align     # align the class tests vertically

    @data
  end

  private

  def prepare
    @data = {}

    @students.each do |stud|
      @data[stud.id] = {}
      @types.each do |type|
        @data[stud.id][type.id] = []
      end
    end
  end

  def populate
    @evaluations.each do |eval|
      student_id = eval.student_id
      type_id = eval.evaluation_type_id

      @data[student_id][type_id] << eval
    end
  end

  def align
    # align each types individually
    @types.each { |t| align_type(t.id) }
  end

  def align_type(type_id)
    # fetch the tests of the selected type
    klass_tests = fetch_klass_tests(type_id)

    # align each of them
    klass_tests.each { |klass_test| align_klass_test(type_id, klass_test) }
  end

  def align_klass_test(type_id, klass_test)
    # if the tests has not a date, the alignment cannot be done
    return unless klass_test.date

    Rails.logger.debug "Working on #{klass_test.id}"

    # compute the position of the column
    column = find_column(type_id, klass_test)

    pad_evaluations(type_id, klass_test, column)
  end

  def find_column(type_id, klass_test)
    column = -1

    @data.each do |_, types|
      evals = types[type_id]

      # search an eval of the class test
      target = evals.index { |e| e && e.klass_test == klass_test }
      # if not found search the first with date greater than the test one
      target = evals.index { |e| e && e.date > klass_test.date && !e.klass_test } unless target
      # if not found do nothing
      target = -1 unless target

      Rails.logger.debug "Found target: #{evals[target].try(:id)}"

      column = [column, target].max
      Rails.logger.debug "Current column = #{column}"
    end

    column
  end

  def pad_evaluations(type_id, klass_test, offset)
    @data.each do |student_id, types|
      evals = types[type_id]

      # search the eval of the test
      target = evals.index { |e| e && e.klass_test == klass_test }
      # if not found fall back to the date
      target = evals.index { |e| e && e.date > klass_test.date && !e.klass_test } unless target

      # if no evaluation was found don't pad
      next unless target

      Rails.logger.debug "Working on student #{student_id} that starts at #{target.inspect}"

      # the padding to add
      to_add = offset-target
      # if the evaluation found is not in the test add another space
      to_add += 1 if evals[target].klass_test != klass_test

      # if there aren't spaces to add
      next if to_add <= 0

      Rails.logger.debug "Add padding of #{to_add}"
      # insert some nil values before the evaluation
      @data[student_id][type_id].insert(target, *[nil]*to_add)
    end
  end

  def fetch_klass_tests(type_id)
    klass_tests = []
    @data.each_value do |types|
      evals = types[type_id] || []
      klass_tests.concat(evals.map(&:klass_test).compact)
    end

    klass_tests.uniq
  end
end
