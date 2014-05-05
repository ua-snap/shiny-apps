output$Update_JSON_Defaults <- renderUI({
	checkboxInput("update_json_defaults", "Save Sen/Ign as new defaults", FALSE)
})

output$SkipAlf <- renderUI({
	checkboxInput("skipAlf", "Skip Alfresco/Rerun R", FALSE)
})

output$JSON_FireSensitivity <- renderUI({
	numericInput("FireSensitivity", "Fire Sensitivity", value=default_Fire.Sensitivity, min=1, max=100000)
})

output$JSON_IgnitionFactor <- renderUI({
	numericInput("IgnitionFactor", "Fire Ignition Factor", value=default_Fire.IgnitionFactor, min=0.00001, max=0.1)
})

# Fire return period inputs
output$FRP_pts <- renderUI({
	selectInput("frp_pts", "Fire Return Period locations", c("", list.files("pts", pattern=".csv$")))
})

output$FRP_buffers <- renderUI({
	textInput("frp_buffers", "Fire Return Period buffers", value="0,10,25,50,100")
})

output$JSON_Lines <- renderUI({ JSON_lines() })

output$Obs_UpdateFiles <- renderUI({ Obs_updateFiles() })
