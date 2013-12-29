require "./generate_win_lost2.rb"

def generate_daily_k_win_lost_history(target_folder,percent,duration_day)
  genereate_all_symbol_win_lost(target_folder,percent,duration_day)
end

if $0==__FILE__
	percent=3
	duration_day=7
	target_folder=File.expand_path("./percent_#{percent}_num_#{duration_day}/win_lost_history","#{AppSettings.daily_k_one_day_folder}")


end