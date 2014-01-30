<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:import href="valores_de_referencia.xsl"/>
    
    <!-- Parametros que podem ser passados para de selecao de dados -->
    
    <!-- URL do diretorio onde estao as imagens (sem a / no final) - Eh necessario configurar este caminho para exibir imagens -->
    <!-- ALGUNS BROWSERS NAO FUNCIONARAO COM CAMINHOS RELATIVOS LOCAIS - USE file:///... ou use caminho relativo somente no servidor WEB
        Ex: file:///Users/helder/Desktop/Trabalho/Petrobras/Cursos/Exemplos/X500/Lab_Aula_11/imagens -->
    <xsl:param name="urlImagens"><![CDATA[]]></xsl:param>
    
    <!-- O que incluir: deixe VAZIO para omitir ou passe parametro com string vazio -->
    <xsl:param name="planeta">1</xsl:param>
    <xsl:param name="estrela"></xsl:param>
    <xsl:param name="planetaAnao">1</xsl:param>
    <xsl:param name="asteroide">1</xsl:param>
    <xsl:param name="centauro">1</xsl:param>
    <xsl:param name="cometa">1</xsl:param>
    <xsl:param name="tno">1</xsl:param>
    <xsl:param name="satelitePlaneta">1</xsl:param>
    <xsl:param name="satelitePlanetaAnao">1</xsl:param>
    <xsl:param name="sateliteAsteroide">1</xsl:param>
    <xsl:param name="sateliteObjeto">1</xsl:param>
    <xsl:param name="titulo">Sistema solar</xsl:param>
    <xsl:param name="subtitulo"></xsl:param> <!-- opcional - se estiver vazio, sera usado default -->
    
    <!-- Orbitas e diametros para filtrar resultados -->
    <xsl:param name="maxDiametro"><xsl:value-of select="$diametroDoSol" /></xsl:param>
    <xsl:param name="minDiametro">0</xsl:param>
    <xsl:param name="maxOrbita"><xsl:value-of select="$maiorOrbita"/></xsl:param> <!-- em UA - usa afelio como referencia -->
    <xsl:param name="minOrbita">0</xsl:param>
    
    <!-- Parametros de estilo -->
    <xsl:param name="altura">900px</xsl:param>
    <xsl:param name="largura">1000px</xsl:param>
    <xsl:param name="alturaViewBox">900</xsl:param>
    <xsl:param name="larguraViewBox">1000</xsl:param>
    <xsl:param name="larguraNome">110</xsl:param>
    <xsl:param name="larguraValor">100</xsl:param>
    <xsl:param name="espacoEntreItens">10</xsl:param>
    <xsl:param name="alturaCabecalho">90</xsl:param>
    <xsl:param name="alturaLegenda">50</xsl:param>
    
    <xsl:param name="corEstrela">rgb(255,180,50)</xsl:param>
    <xsl:param name="corPlaneta">rgb(100,100,255)</xsl:param> <!-- ex: red, #fff, #FF0000 -->
    <xsl:param name="corSatelite">rgb(255,50,50)</xsl:param>
    <xsl:param name="corAsteroide">rgb(0,200,0)</xsl:param>
    <xsl:param name="corPlanetaAnao">rgb(150,0,255)</xsl:param>
    <xsl:param name="corObjeto">rgb(0,100,120)</xsl:param>
    <xsl:param name="corCometa">rgb(0,200,200)</xsl:param>
    <xsl:param name="corCentauro">rgb(50,100,0)</xsl:param>
    <xsl:param name="corTNO">rgb(150,0,100)</xsl:param>
    
    <!-- Fonte alternativa - caso a fonte usada apresente problemas: pode ser uma lista de nomes de fonte. ex: helvetica, arial, 'trebuchet ms'-->
    <xsl:param name="fonteAlternativa"></xsl:param>
    
    <!-- Varie para ajustar o grafico caso as legendas nao caibam -->
    <xsl:param name="maisX">0</xsl:param>
    <xsl:param name="escalaHorizontal">1</xsl:param>
    
    <!-- Tamanho da imagem exibida no onmouseover quando houver imagem e recurso for suportado -->
    <xsl:param name="alturaImagem">300</xsl:param>
    <xsl:param name="larguraImagem">300</xsl:param>
    
</xsl:stylesheet>