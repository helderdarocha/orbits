<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:import href="valores_de_referencia.xsl"/>

    <!-- 
         Parametros que podem ser configurados para uso na folha de estilos sol_orbitas.xsl 
         Para passar parametros via Java ou pelo Xalan / Saxon, faca atraves da folha de estilos
         sol_orbitas.xsl
    -->
    
    <!-- O que incluir: deixe VAZIO o que quiser omitir-->
    <xsl:param name="planeta"></xsl:param>
    <xsl:param name="cometa"></xsl:param>
    <xsl:param name="estrela"></xsl:param>
    <xsl:param name="planetaAnao"></xsl:param>
    <xsl:param name="asteroide"></xsl:param>
    <xsl:param name="centauro"></xsl:param>
    <xsl:param name="tno"></xsl:param>
 
    <!-- Destacar um objeto especifico pelo @nome. Ex: Terra -->
    <xsl:param name="destaque"></xsl:param>

    <xsl:param name="titulo">Sistema Solar</xsl:param>
    <xsl:param name="subtitulo"></xsl:param> <!-- opcional - se estiver vazio, sera usado default -->
    <xsl:param name="mostrarLegenda"></xsl:param>
    <xsl:param name="textoLegendaDestaque"></xsl:param>
    
    <!-- Orbitas e diametros para filtrar resultados -->
    <xsl:param name="maxDiametro"><xsl:value-of select="$diametroDeJupiter" /></xsl:param>
    <xsl:param name="minDiametro">0</xsl:param>
    <xsl:param name="maxOrbita"><xsl:value-of select="$orbitaDeSedna"/></xsl:param> <!-- em UA - usa afelio como referencia -->
    <xsl:param name="minOrbita">0</xsl:param>
    
    <!-- Massa para filtrar (nao implementado) -->
    <xsl:param name="minMassa">0</xsl:param>
    
    <!-- Tempo de animacao da orbita minima -->
    <xsl:param name="segundosOrbitaMaxima">60</xsl:param>
    
    <!-- Concessoes para melhorar performance -->
    <xsl:param name="naoConsiderarInclinacao"></xsl:param>
    <xsl:param name="velocidadeOrbitalConstante"></xsl:param>
    <xsl:param name="graficoEstatico"></xsl:param>
 
    <!-- Compatibilidade -->
    <xsl:param name="usarAnimacaoScript"></xsl:param>
    
    <!-- Parametros de estilo -->
    <xsl:param name="altura">900px</xsl:param>
    <xsl:param name="largura">1000px</xsl:param>
    <xsl:param name="alturaViewBox">900</xsl:param>
    <xsl:param name="larguraViewBox">1000</xsl:param>
    <xsl:param name="alturaCabecalho">150</xsl:param>
    <xsl:param name="margemLateral">20</xsl:param>
    <xsl:param name="margemSuperior">10</xsl:param>    
    <xsl:param name="alturaLegenda">50</xsl:param>
     
     <xsl:param name="linhaPlaneta">0.5</xsl:param>
     <xsl:param name="linhaCometa">0.5</xsl:param>
     <xsl:param name="linhaPlanetaAnao">0.5</xsl:param>
     <xsl:param name="linhaAsteroide">0.5</xsl:param>
     <xsl:param name="linhaCentauro">0.5</xsl:param>
     <xsl:param name="linhaTNO">0.5</xsl:param>
     <xsl:param name="linhaDestaque">2.0</xsl:param>
     
     <xsl:param name="circuloPlaneta">2</xsl:param>
     <xsl:param name="circuloCometa">2</xsl:param>
     <xsl:param name="circuloPlanetaAnao">2</xsl:param>
     <xsl:param name="circuloAsteroide">2</xsl:param>
     <xsl:param name="circuloCentauro">2</xsl:param>
     <xsl:param name="circuloTNO">2</xsl:param>
     <xsl:param name="circuloDestaque">4.0</xsl:param>
     
     <xsl:param name="mostrarNomePlaneta"></xsl:param>
     <xsl:param name="mostrarNomeCometa"></xsl:param>
     <xsl:param name="mostrarNomePlanetaAnao"></xsl:param>
     <xsl:param name="mostrarNomeAsteroide"></xsl:param>
     <xsl:param name="mostrarNomeCentauro"></xsl:param>
     <xsl:param name="mostrarNomeTNO"></xsl:param>
     <xsl:param name="mostrarNomeDestaque"></xsl:param>
     
     <xsl:param name="corPlaneta">rgb(255,255,100)</xsl:param> <!-- ex: red, #fff, #FF0000, rgb(150,0,100) -->
    <xsl:param name="corAsteroide">rgb(100,255,100)</xsl:param>
    <xsl:param name="corPlanetaAnao">rgb(255,100,255)</xsl:param>
    <xsl:param name="corCometa">rgb(255,50,50)</xsl:param>
    <xsl:param name="corCentauro">rgb(50,0,255)</xsl:param>
    <xsl:param name="corTNO">rgb(0,255,255)</xsl:param>
     
     <xsl:param name="corEstrela">rgb(255,180,50)</xsl:param>
     <xsl:param name="corDestaque">rgb(255,255,180)</xsl:param>
     
    <xsl:param name="corDoTexto">rgb(255,255,255)</xsl:param>
    <xsl:param name="corDeFundo">rgb(50,50,50)</xsl:param>
     
    <!-- para browsers que suportam filtros -->
    <xsl:param name="brilhoSol"></xsl:param>
     
    <xsl:param name="tamFonte">10</xsl:param>
    <xsl:param name="tamFonteDestaque">14</xsl:param>
 
    <xsl:param name="maisX">0</xsl:param>
    <xsl:param name="maisY">0</xsl:param>
    <xsl:param name="escala">1.0</xsl:param>
    
</xsl:stylesheet>