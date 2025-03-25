# Análise Estatística - FarmTech Solutions
# Gera estatísticas e gráficos das áreas por cultura
# Versão: 1.0

# Leitura de dados
dados <- read.csv("todas_areas.csv", header = TRUE, sep = ",")

# Preparação dos dados
dados$Area <- as.numeric(dados$Area)

# Validações
if (any(is.na(dados$Area))) {
  cat("Erro: A coluna 'Area' contém valores inválidos ou não numéricos.\n")
  quit(status = 1)
}

if (nrow(dados) == 0) {
  cat("Erro: Não há dados no arquivo CSV.\n")
  quit(status = 1)
}

# Análise por cultura
culturas <- unique(dados$Cultura)

cat("\n===== Estatísticas das Áreas por Cultura =====\n")

# Preparação para visualização
estatisticas <- data.frame(Cultura = character(), Media = numeric(), Desvio = numeric())

# Cálculo de estatísticas
for (cultura in culturas) {
  cat("\nCultura:", cultura, "\n")
  dados_filtrados <- subset(dados, Cultura == cultura)
  
  if (nrow(dados_filtrados) > 0) {
    media <- mean(dados_filtrados$Area, na.rm = TRUE)
    desvio <- sd(dados_filtrados$Area, na.rm = TRUE)
    if (is.na(desvio)) desvio <- 0  # Caso único valor
    maior <- max(dados_filtrados$Area, na.rm = TRUE)
    menor <- min(dados_filtrados$Area, na.rm = TRUE)
    total <- nrow(dados_filtrados)
    
    cat(" - Total de áreas:", total, "\n")
    cat(" - Média da área:", round(media, 2), "m²\n")
    cat(" - Desvio padrão:", round(desvio, 2), "m²\n")
    cat(" - Maior área:", round(maior, 2), "m²\n")
    cat(" - Menor área:", round(menor, 2), "m²\n")
    
    estatisticas <- rbind(estatisticas, data.frame(Cultura = cultura, Media = media, Desvio = desvio))
  } else {
    cat(" - Nenhum dado disponível para esta cultura.\n")
  }
}

# Geração do gráfico
if (nrow(estatisticas) > 0) {
  # Cálculo de limites
  max_value <- max(estatisticas$Media + estatisticas$Desvio)
  ylim_max <- if (is.finite(max_value)) max_value * 1.2 else max(estatisticas$Media) * 1.2
  
  # Plotagem
  bar_centers <- barplot(
    estatisticas$Media,
    names.arg = estatisticas$Cultura,
    col = rainbow(length(estatisticas$Cultura)),
    main = "Média da Área por Cultura (com Desvio Padrão)",
    xlab = "Cultura",
    ylab = "Área média (m²)",
    ylim = c(0, ylim_max)
  )
  
  # Barras de erro
  for (i in 1:length(bar_centers)) {
    if (estatisticas$Desvio[i] > 0) {
      arrows(
        x0 = bar_centers[i], 
        y0 = estatisticas$Media[i] - estatisticas$Desvio[i], 
        x1 = bar_centers[i], 
        y1 = estatisticas$Media[i] + estatisticas$Desvio[i], 
        angle = 90, 
        code = 3, 
        length = 0.1, 
        col = "black"
      )
    }
  }
  
  cat("\nGráfico gerado com sucesso em Rplots.pdf\n")
} else {
  cat("Nenhum dado disponível para gerar o gráfico.\n")
  quit(status = 1)
}