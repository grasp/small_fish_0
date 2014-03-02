html_report=File.new("report.html","w+")

   html_report<< "<html>" 
     html_report<< "<head>"
   # html_report<<  "<link href='http://cdn.bootcss.com/bootstrap/3.1.1/css/bootstrap.min.css' rel='stylesheet'>\n"

   html_report<< "</head>\n"
   html_report<< "<table class='table'>\n"

   report_array.each do |line|
      html_report<< "<tr>\n"
    result= line.split("#")
    result.each_index do |index|
       if index==4 || index==5
        if result[index].to_f>0
         html_report<<"<td bgcolor='red'>\n"   
        else
          html_report<<"<td bgcolor='green'>\n"   
        end  
       else
        html_report<<"<td>\n"   
       end 
       html_report<< "#{result[index]}" 
       html_report<<"</td>\n"
    end

        html_report<< "</tr>\n"
    end
  html_report<< "</table>\n"
   html_report<< "</html>" 
    html_report.close