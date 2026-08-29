module InjuryReportsHelper
  def field_label_classes
    "mb-1.5 block text-sm font-semibold text-[#4C4682]"
  end

  def field_input_classes
    [
      "block w-full rounded-lg border border-[#EAEFFC] bg-white px-3.5 py-2.5",
      "text-sm font-medium text-[#2D2B4A] placeholder:text-[#8C87B3]",
      "shadow-[0_1px_2px_rgba(104,95,214,0.04)]",
      "transition-colors duration-200",
      "focus:border-[#685FD6] focus:outline-none focus:ring-2 focus:ring-[#685FD6]/20",
      "disabled:cursor-not-allowed disabled:bg-[#F0F2FC]"
    ].join(" ")
  end

  def severity_pill_classes(severity)
    case severity.to_s
    when "critical" then "bg-red-100 text-red-800 border-red-200"
    when "serious"  then "bg-orange-100 text-orange-800 border-orange-200"
    when "moderate" then "bg-[#EEF0FD] text-[#4C4682] border-[#C7D2FE]"
    when "minor"    then "bg-[#F0F2FC] text-[#4C4682] border-[#E0E3F6]"
    else "bg-[#F0F2FC] text-[#8C87B3] border-[#EAEFFC]"
    end
  end

  def location_option_label(location)
    location.try(:display_name).presence || begin
      company_name = location.company&.name
      company_name.present? ? "#{location.name} (#{company_name})" : location.name.to_s
    end
  end
end