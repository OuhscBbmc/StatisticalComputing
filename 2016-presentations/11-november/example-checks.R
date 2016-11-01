#### Maleeha Examples ########################################
# validation test examples for ASQ-3
validation_check(
  name          = "was_asq_skipped",
  error_message = "ASQ-3 testing status was not documented.",
  priority      = 2L,
  passing_test  = function( d ) {
    !is.na(was_asq_skipped)
  } # Documentation status should be yes or no but not missing. Missing field indicates missing status
)

# For the following two checks, i am trying to say given variable field values should not be missing conditioned on certain other variables. I am not sure if i said it the right way?
validation_check(
  name           = "communication_score_asq3_02_month",
  error_message  = "Communication score on ASQ-3 for a 2-month old should not be  missing given age-range of 2-3 months.",
  priority       = 2L,
  passing_test   = function( d ) {
    #(!is.na(communication_score_asq3_02_month) | (d$cdemo_asq_age_c01 >=1 & d$cdemo_asq_age_c01 <3))
    ifelse(
      (d$cdemo_asq_age_c01 >=1 & d$cdemo_asq_age_c01 <3),
      !is.na(communication_score_asq3_02_month),
      TRUE
    )
  }
)

validation_check (
  name           = "lead_screening_utility_status_1",
  error_message  = "Lead Screening status should not be missing given the current pregnany status = 1,
                    number of children in the household > 1 and 2nd youngest child age < 72 months,",
  prority        = 2L,
  passing_test   =function( d ) {
    ifelse(
      d$pregnant_current & (d$cdemo_num_children >1) & (d$cdemo_age_c02 <72),
      !is.na(lead_screening_utility_status_1),
      TRUE
    )
  }
)
