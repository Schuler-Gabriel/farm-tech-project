# Ler dados do CSV
dados <- read.csv("todas_areas.csv", header = TRUE, sep = ",")

# Converter para numérico
dados$Area <- as.numeric(dados$Area)

# Verificar se há valores inválidos
if (any(is.na(dados$Area))) {
  cat("Erro: A coluna 'Area' contém valores inválidos ou não numéricos.\n")
  quit(status = 1)
}

# Obter culturas únicas
culturas <- unique(dados$Cultura)

cat("\n===== Estatísticas das Áreas por Cultura =====\n")

# Criar dataframe para gráfico
estatisticas <- data.frame(Cultura = character(), Media = numeric(), Desvio = numeric())

# Loop por cultura
for (cultura in culturas) {
  cat("\nCultura:", cultura, "\n")
  dados_filtrados <- subset(dados, Cultura == cultura)
  
  if (nrow(dados_filtrados) > 0) {
    media <- mean(dados_filtrados$Area, na.rm = TRUE)
    desvio <- sd(dados_filtrados$Area, na.rm = TRUE)
    maior <- max(dados_filtrados$Area, na.rm = TRUE)
    menor <- min(dados_filtrados$Area, na.rm = TRUE)
    total <- nrow(dados_filtrados)
    
    # cat para fazer o terminal ficar visualmente mais bonito
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

# Verificar se há dados para o gráfico
if (nrow(estatisticas) > 0) {
  cat("Cheque o gráfico gerado no arquivo Rplot.pdf.\n")
  
  # Gerar gráfico com barras e desvios padrão
  bar_centers <- barplot(
    estatisticas$Media,
    names.arg = estatisticas$Cultura,
    col = rainbow(length(estatisticas$Cultura)),
    main = "Média da Área por Cultura (com Desvio Padrão)",
    xlab = "Cultura",
    ylab = "Área média (m²)",
    ylim = c(0, max(estatisticas$Media + estatisticas$Desvio, na.rm = TRUE) * 1.2) # Ajustar o limite do eixo Y
  )
  
  # Adicionar barras de erro (desvio padrão)
  arrows(
    x0 = bar_centers, 
    y0 = estatisticas$Media - estatisticas$Desvio, 
    x1 = bar_centers, 
    y1 = estatisticas$Media + estatisticas$Desvio, 
    angle = 90, 
    code = 3, 
    length = 0.1, 
    col = "black"
  )
} else {
  cat("Nenhum dado disponível para gerar o gráfico.\n")
  quit(status = 1)
}