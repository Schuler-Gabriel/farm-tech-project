# API Climatológica - FarmTech Solutions
# Coleta dados de temperatura para São Paulo
# Versão: 1.0

# Instalação de pacotes
install_if_missing <- function(packages) {
  for (pkg in packages) {
    tryCatch({
      if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
        cat(sprintf("Installing package: %s\n", pkg))
        install.packages(pkg, repos = "https://cloud.r-project.org/", quiet = TRUE)
        if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
          stop(sprintf("Failed to install package: %s", pkg))
        }
      }
    }, error = function(e) {
      cat(sprintf("Error handling package %s: %s\n", pkg, e$message))
    })
  }
}

# Carrega bibliotecas necessárias
install_if_missing(c("httr", "jsonlite", "lubridate"))

# Função para obter dados climáticos
get_weather_data <- function() {
  base_url <- "https://api.open-meteo.com/v1/forecast"
  
  # Requisição para coordenadas de São Paulo
  response <- GET(base_url, query = list(
    latitude = -23.5583,
    longitude = -46.6415,
    hourly = "temperature_2m",
    timezone = "America/Sao_Paulo"
  ))
  
  if (status_code(response) == 200) {
    weather_data <- fromJSON(content(response, "text", encoding = "UTF-8"))
    return(weather_data)
  } else {
    stop("Erro ao obter os dados climáticos.")
  }
}

# Processamento principal
tryCatch({
  # Coleta dados
  weather_data <- get_weather_data()
  
  # Configura fuso horário
  current_time_sp <- force_tz(Sys.time(), "America/Sao_Paulo")
  
  # Converte timestamps
  api_times <- ymd_hm(weather_data$hourly$time, tz = "America/Sao_Paulo")
  
  # Encontra hora mais próxima
  time_diffs <- abs(as.numeric(difftime(api_times, current_time_sp, units = "hours")))
  closest_index <- which.min(time_diffs)
  
  # Temperatura atual
  current_temp <- weather_data$hourly$temperature_2m[closest_index]
  
  # Calcula período do dia
  today_start <- as.POSIXct(format(current_time_sp, "%Y-%m-%d 00:00:00"), tz = "America/Sao_Paulo")
  today_end <- today_start + days(1) - seconds(1)
  
  # Temperaturas do dia
  today_indices <- which(api_times >= today_start & api_times <= today_end)
  today_temps <- weather_data$hourly$temperature_2m[today_indices]
  min_temp <- min(today_temps)
  max_temp <- max(today_temps)
  
  # Exibe resultados
  cat("\n===== Clima em São Paulo =====\n")
  cat("Data e Hora:", format(current_time_sp, "%d/%m/%Y %H:%M"), "\n")
  cat("Temperatura Atual:", round(current_temp, 1), "°C\n")
  cat("Temperatura Mínima Hoje:", round(min_temp, 1), "°C\n")
  cat("Temperatura Máxima Hoje:", round(max_temp, 1), "°C\n")
  
}, error = function(e) {
  cat("Erro:", e$message, "\n")
})