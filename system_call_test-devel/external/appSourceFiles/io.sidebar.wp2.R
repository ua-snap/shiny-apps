# Alfresco .fif parameters
output$Update_fif_Defaults <- renderUI({
	checkboxInput("update_fif_defaults", "Save settings as new defaults", FALSE)
})

output$fif_FireSensitivity <- renderUI({
	numericInput("FireSensitivity", "Fire Sensitivity", value=default_Fire.Sensitivity, min=1, max=100000)
})

output$fif_IgnitionFactor <- renderUI({
	numericInput("IgnitionFactor", "Fire Ignition Factor", value=default_Fire.IgnitionFactor, min=0.00001, max=0.1)
})

output$goButton_fif <- renderUI({ actionButton("goButton_fif","Save .fif / run Alfresco") })

output$FIF_Lines <- renderUI({ fif_lines() })
