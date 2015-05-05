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
    @evaluations.each do |eval|
      student_id = eval.student_id
      type_id = eval.evaluation_type_id

      @data[student_id][type_id] << eval

      @count[type_id] = [
          @count.fetch(type_id, 0),
          @data[student_id][type_id].length
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
