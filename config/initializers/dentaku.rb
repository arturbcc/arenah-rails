# require_relative '../function'

Dentaku::AST::Function.register(:floor, :numeric, ->(numeric, precision=0) {
  tens = 10.0**precision
  result = (numeric * tens).floor / tens
  precision <= 0 ? result.to_i : result
})

Dentaku::AST::Function.register(:ceil, :numeric, ->(numeric, precision=0) {
  tens = 10.0**precision
  result = (numeric * tens).ceil / tens
  precision <= 0 ? result.to_i : result
})
