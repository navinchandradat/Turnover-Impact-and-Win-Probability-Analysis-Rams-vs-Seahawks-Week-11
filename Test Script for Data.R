# ============================================================================
# TEST: Check if 2025 Season Data is Available
# Run this FIRST before proceeding with the full analysis
# ============================================================================

# Install packages if needed (run once)
# install.packages(c("nflreadr", "tidyverse"))

# Load libraries
library(nflreadr)
library(tidyverse)

# ============================================================================
# TEST 1: Try to load 2025 season data
# ============================================================================

cat("=== TESTING 2025 DATA AVAILABILITY ===\n\n")

cat("Attempting to load 2025 season data...\n")
tryCatch({
  pbp_2025 <- load_pbp(2025)
  cat("✓ SUCCESS: 2025 data loaded!\n")
  cat("Total plays in 2025 season:", nrow(pbp_2025), "\n\n")
}, error = function(e) {
  cat("✗ ERROR: Could not load 2025 data\n")
  cat("Error message:", conditionMessage(e), "\n\n")
  cat("Solution: The 2025 data may not be available yet in nflreadr.\n")
  cat("You have two options:\n")
  cat("1. Wait for nflreadr to update (usually within 24 hours of game)\n")
  cat("2. Use alternative data sources (see below)\n\n")
})

# ============================================================================
# TEST 2: Try to filter for our specific game
# ============================================================================

cat("=== TESTING RAMS-SEAHAWKS WEEK 11 GAME ===\n\n")

tryCatch({
  pbp_2025 <- load_pbp(2025)
  
  game_data <- pbp_2025 %>%
    filter(
      week == 11,
      home_team == "LA",
      away_team == "SEA"
    )
  
  if (nrow(game_data) > 0) {
    cat("✓ SUCCESS: Game data found!\n")
    cat("Total plays in game:", nrow(game_data), "\n")
    cat("Final Score - LA:", max(game_data$home_score, na.rm = TRUE), 
        "SEA:", max(game_data$away_score, na.rm = TRUE), "\n\n")
    
    # Quick check: How many turnovers?
    turnovers <- game_data %>%
      filter(interception == 1 | fumble_lost == 1)
    
    cat("Turnovers found:", nrow(turnovers), "\n")
    cat("Interceptions:", sum(turnovers$interception, na.rm = TRUE), "\n\n")
    
    cat("✓ DATA IS READY FOR ANALYSIS!\n")
    cat("You can proceed with the full analysis code.\n\n")
    
  } else {
    cat("✗ WARNING: No game data found for Week 11 LA vs SEA\n")
    cat("This might mean:\n")
    cat("- The game data hasn't been processed yet\n")
    cat("- The week or team abbreviations are wrong\n\n")
  }
  
}, error = function(e) {
  cat("✗ ERROR: Could not filter game data\n")
  cat("Error message:", conditionMessage(e), "\n\n")
})

# ============================================================================
# TEST 3: Check available weeks in 2025
# ============================================================================

cat("=== CHECKING AVAILABLE 2025 WEEKS ===\n\n")

tryCatch({
  pbp_2025 <- load_pbp(2025)
  
  available_weeks <- pbp_2025 %>%
    distinct(week) %>%
    arrange(week) %>%
    pull(week)
  
  cat("Available weeks in 2025 data:", paste(available_weeks, collapse = ", "), "\n")
  
  if (11 %in% available_weeks) {
    cat("✓ Week 11 data IS available\n\n")
  } else {
    cat("✗ Week 11 data IS NOT available yet\n")
    cat("Latest available week:", max(available_weeks), "\n\n")
  }
  
}, error = function(e) {
  cat("Could not check available weeks\n\n")
})

# ============================================================================
# ALTERNATIVE: Check schedule data
# ============================================================================

cat("=== CHECKING SCHEDULE DATA ===\n\n")

tryCatch({
  schedule_2025 <- load_schedules(2025)
  
  rams_seahawks <- schedule_2025 %>%
    filter(
      week == 11,
      home_team == "LA",
      away_team == "SEA"
    )
  
  if (nrow(rams_seahawks) > 0) {
    cat("✓ Game found in schedule:\n")
    print(rams_seahawks %>% select(week, gameday, home_team, away_team, 
                                   home_score, away_score, game_id))
  } else {
    cat("✗ Game not found in schedule\n")
  }
  
}, error = function(e) {
  cat("Could not load schedule data\n")
  cat("Error:", conditionMessage(e), "\n")
})

cat("\n=== TEST COMPLETE ===\n")
cat("If all tests passed, you're ready to proceed with the analysis!\n")
cat("If tests failed, see alternative data sources section below.\n")