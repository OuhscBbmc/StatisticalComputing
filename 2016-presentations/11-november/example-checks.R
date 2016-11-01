#### Maleeha's Checks ########################################
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


#### Som's Checks ########################################
validation_check(
  name          = "home_01_non_pregnant",
  error_message = "`Non-pregnant or subjects with no children should skip this question.",
  priority      = 2L,
  passing_test  = function( d ) {
    ifelse((d$pregnant_current == 1 & d$cdemo_num_children == 1), !is.na(d$home_preg_index_child), FALSE)
  }
)

validation_check(
  name          = "home_01through11_missing",
  error_message = "These questions (home_01 through home_11) should not be missing if child is <= 36 months,but missing.",
  priority      = 2L,
  passing_test  = function( d ) {
    home_01through11_names <- c(paste0("home","_", "0", 1:9), paste0("home","_", 10:11))
    ifelse(
      d$cdemo_age_c01 < 36,
      apply(d[home_01through11_names], 1, function(x) sum(is.na(x))) == 0, 
      FALSE 
    )
  }
)

validation_check(
  name          = "home_12through18_missing",
  error_message = "These questions (home_12 through home_18) should not be asked if child is <= 36 months,but are asked.",
  priority      = 2L,
  passing_test  = function( d ) {
    home_12through18_names <- paste0("home","_", c(12:13,15:18))
    ifelse(
      d$cdemo_age_c01 < 36,
      apply(d[home_12through18_names], 1, function(x) sum(is.na(x))) == 0, 
      FALSE 
    )
  }
)


#### Geneva's Checks ########################################
validation_check(
  name          = "index_child_age_wave_2",
  error_message = "The age of the child at subsequent waves should be greater than 3 months",
  priority      = 2L,
  passing_test  = function( d ) {
    ifelse(d$wave %in% 2, d$cdemo_age_c01 >= 3, TRUE)
    }
)

#Would like to discuss the approach:
validation_check(
  name          = "index_child_consistent",
  error_message = "The date of birth should be the same on all waves",
  priority      = 2L,
  passing_test  = function( d ) {
    # "Group by the subject it, then in a mutate clause, make sure the values are (or aren't) constant. Both records should get flagged with this approach"
    #I don't know how to do this, but it's probably important.
  } 
)
