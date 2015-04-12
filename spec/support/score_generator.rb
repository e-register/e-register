# create 19 score: 1, 1.5, 2, 2.5, ... 9, 9.5, 10
def generate_scores
  19.times { |n| create(:score, value: (n/2.0)+1, as_string: (n/2.0)+1) }
end
