#
# Routes constraints for Ad routes
#
class AdConstraint
  def matches?(request)
    params = request.path_parameters

    return false unless valid_page?(params[:page])

    return false unless valid_combination?(params[:type], params[:status])

    true
  end

  private

  def valid_combination?(type, status)
    [
      [nil, nil],
      ['want', nil],
      ['give', nil],
      %w(give available),
      %w(give booked),
      %w(give delivered)
    ].include?([type, status])
  end

  def valid_page?(page)
    page.nil? || positive_integer?(page)
  end

  def positive_integer?(str)
    Integer(str).positive?
  rescue
    false
  end
end
