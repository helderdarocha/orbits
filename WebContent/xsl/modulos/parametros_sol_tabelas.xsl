<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:import href="valores_de_referencia.xsl"/>

    <!-- 
         Parametros que podem ser configurados para uso na folha de estilos sol_tabelas.xsl 
    -->
 
    <xsl:param name="urlImagens"><![CDATA[/Users/helder/Docs/Astronomy/sol_2010_2.2/data/img/]]></xsl:param>
 
    <!-- Colunas a mostrar - todos os objetos -->
    <xsl:param name="afelioUA"></xsl:param>
    <xsl:param name="anoDescobrimento"></xsl:param>
    <xsl:param name="anomaliaMedia"></xsl:param>
    <xsl:param name="argumentoPerielio"></xsl:param>
    <xsl:param name="categoria"></xsl:param>
    <xsl:param name="descobertoPor"></xsl:param>
    <xsl:param name="diametrokm"></xsl:param>
    <xsl:param name="excentricidade"></xsl:param>
    <xsl:param name="id"></xsl:param>
    <xsl:param name="inclinacao"></xsl:param>
    <xsl:param name="longitudeNoAscendente"></xsl:param>
    <xsl:param name="nome"></xsl:param>
    <xsl:param name="perielioUA"></xsl:param>
    <xsl:param name="periodoOrbitalD"></xsl:param>
    <xsl:param name="raioMedUA"></xsl:param>
 
    <!-- Colunas a mostrar (dependendo do tipo) -->
    <xsl:param name="massaGM"></xsl:param> <!-- exceto cometas -->
    <xsl:param name="massaKg"></xsl:param> <!-- exceto cometas -->
    <xsl:param name="numero"></xsl:param> <!-- exceto planetas e planetas-anao -->
    <xsl:param name="densidade"></xsl:param> <!-- so planetas e planetas-anao -->
    <xsl:param name="gravidadeEquatorial"></xsl:param>   <!-- so planetas e planetas-anao -->
    <xsl:param name="inclinacaoAxial"></xsl:param>   <!-- so planetas e planetas-anao -->
    <xsl:param name="volume"></xsl:param>   <!-- so planetas e planetas-anao -->
    <xsl:param name="periodoRotacaoSideralH"></xsl:param> <!-- so planetas -->
    <xsl:param name="designacao"></xsl:param> <!-- so asteroides e objetos -->
    <xsl:param name="raioMedOrbitakm"></xsl:param> <!-- so satelites -->
    
    <!-- O que incluir: deixe VAZIO o que quiser omitir-->
    <xsl:param name="planeta"></xsl:param>
    <xsl:param name="cometa"></xsl:param>
    <xsl:param name="estrela"></xsl:param>
    <xsl:param name="planetaAnao"></xsl:param>
    <xsl:param name="asteroide"></xsl:param>
    <xsl:param name="centauro"></xsl:param>
    <xsl:param name="tno"></xsl:param>
    <xsl:param name="satelite"></xsl:param>
 
    <xsl:param name="titulo">Sistema Solar</xsl:param>
    <xsl:param name="subtitulo"></xsl:param> <!-- opcional - se estiver vazio, sera usado default -->
    
    <!-- Orbitas e diametros para filtrar resultados -->
    <xsl:param name="maxDiametro"><xsl:value-of select="$diametroDoSol" /></xsl:param>
    <xsl:param name="minDiametro">0</xsl:param>
    <xsl:param name="maxOrbita">1200000</xsl:param> <!-- aprox 20 anos-luz -->
    <xsl:param name="minOrbita">0</xsl:param>
    <xsl:param name="minMassaKg">0</xsl:param>
    <xsl:param name="maxMassaKg"><xsl:value-of select="$massaDoSol"/></xsl:param>
    <xsl:param name="minMassaGM">0</xsl:param>
    <xsl:param name="maxMassaGM"><xsl:value-of select="$massaDoSolGM"/></xsl:param>
    
    <!-- Parametros de estilo -->
    <xsl:param name="corDoTexto">rgb(0,0,0)</xsl:param>
    <xsl:param name="corDeFundo">rgb(255,255,255)</xsl:param>
    <xsl:param name="tamFonte">10</xsl:param>
    <xsl:param name="exibirImagens"></xsl:param>
     
     <xsl:param name="corPlaneta">rgb(225,225,100)</xsl:param> 
     <xsl:param name="corAsteroide">rgb(200,255,200)</xsl:param>
     <xsl:param name="corPlanetaAnao">rgb(225,255,150)</xsl:param>
     <xsl:param name="corCometa">rgb(255,200,150)</xsl:param>
     <xsl:param name="corCentauro">rgb(200,200,255)</xsl:param>
     <xsl:param name="corObjeto">rgb(100,255,255)</xsl:param>
     <xsl:param name="corEstrela">rgb(255,255,0)</xsl:param>
     <xsl:param name="corSatelite">rgb(255,255,180)</xsl:param>
     
     <xsl:param name="corTextoPlaneta">rgb(0,0,0)</xsl:param> 
     <xsl:param name="corTextoAsteroide">rgb(0,0,0)</xsl:param>
     <xsl:param name="corTextoPlanetaAnao">rgb(0,0,0)</xsl:param>
     <xsl:param name="corTextoCometa">rgb(0,0,0)</xsl:param>
     <xsl:param name="corTextoCentauro">rgb(0,0,0)</xsl:param>
     <xsl:param name="corTextoObjeto">rgb(0,0,0)</xsl:param>
     <xsl:param name="corTextoEstrela">rgb(0,0,0)</xsl:param>
     <xsl:param name="corTextoSatelite">rgb(0,0,0)</xsl:param>
    
</xsl:stylesheet>