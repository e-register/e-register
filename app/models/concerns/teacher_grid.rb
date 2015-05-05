class TeacherGrid
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
    return @data, @count if @data

    prepare
    populate
    pad
    # TODO: align the evaluations of the same class test
    return @data, @count
  end

  private

  def prepare
    @data = {}
    @count = {}

    @students.each do |stud|
      @data[stud.id] = {}
      @types.each do |type|
        @data[stud.id][type.id] = []
      end
    end
  end

  def populate
    @teacher.evaluations.includes(:score).each do |eval|
      @data[eval.student_id][eval.evaluation_type_id] << eval

      @count[eval.evaluation_type_id] = [
          @count[eval.evaluation_type_id] || 0,
          @data[eval.student_id][eval.evaluation_type_id].length
      ].max
    end
  end

  def pad
    @data.each do |stud, types|
      types.each do |type, evals|
        @data[stud][type].fill(nil, evals.length, @count[type]-evals.length)
      end
    end
  end
end
