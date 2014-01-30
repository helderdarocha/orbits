<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:import href="valores_de_referencia.xsl"/>
    
    <!-- Parametros que podem ser passados para de selecao de dados -->
    
    <!-- URL do diretorio onde estao as imagens (sem a / no final) - Eh necessario configurar este caminho para exibir imagens -->
    <!-- ALGUNS BROWSERS NAO FUNCIONARAO COM CAMINHOS RELATIVOS LOCAIS - USE file:///... ou use caminho relativo somente no servidor WEB
        Ex: file:///Users/helder/Cursos/Exemplos/X500/imagens -->
    <xsl:param name="urlImagens"><![CDATA[]]></xsl:param>
    
    <xsl:param name="arquivoDeCores">cores.xml</xsl:param>
    
    <!-- O que incluir: deixe VAZIO para omitir ou passe parametro com string vazio -->
    <xsl:param name="planeta">1</xsl:param>
    <xsl:param name="estrela">1</xsl:param>
    <xsl:param name="planetaAnao"></xsl:param>
    <xsl:param name="asteroide"></xsl:param>
    <xsl:param name="tno"></xsl:param>
    <xsl:param name="centauro"></xsl:param>
    <xsl:param name="cometa"></xsl:param>
    <xsl:param name="satelitePlaneta"></xsl:param>
    <xsl:param name="satelitePlanetaAnao"></xsl:param>
    <xsl:param name="sateliteAsteroide"></xsl:param>
    <xsl:param name="sateliteObjeto"></xsl:param>
    <xsl:param name="titulo">Sistema solar</xsl:param>
    <xsl:param name="subtitulo">Distribuicao de Diametros</xsl:param> <!-- opcional - se estiver vazio, sera usado default -->
    
    <!-- Orbitas e diametros para filtrar resultados -->
    <xsl:param name="maxMassaKg"><xsl:value-of select="$massaDoSol" /></xsl:param>
    <xsl:param name="minMassaKg">0</xsl:param>
    <xsl:param name="maxMassaGM"><xsl:value-of select="$massaDoSolGM" /></xsl:param>
    <xsl:param name="minMassaGM">0</xsl:param>
    <xsl:param name="maxDiametro"><xsl:value-of select="$diametroDoSol" /></xsl:param>
    <xsl:param name="minDiametro">0</xsl:param>
    <xsl:param name="maxOrbita"><xsl:value-of select="$maiorOrbita"/></xsl:param> <!-- em UA - usa afelio como referencia -->
    <xsl:param name="minOrbita">0</xsl:param>
    
    <!-- Percentagem minima para que valor tenha uma fatia individual -->
    <xsl:param name="percentMenorFatia">1.0</xsl:param>
    <xsl:param name="textoOutros">Outros</xsl:param>
    
    <!-- Parametros de estilo -->
    <xsl:param name="altura">900px</xsl:param>
    <xsl:param name="largura">1000px</xsl:param>
    <xsl:param name="alturaViewBox">900</xsl:param>
    <xsl:param name="larguraViewBox">1000</xsl:param>
    <xsl:param name="larguraNome">110</xsl:param>
    <xsl:param name="larguraValor">100</xsl:param>
    <xsl:param name="espacoEntreItens">10</xsl:param>
    <xsl:param name="alturaCabecalho">90</xsl:param>
    <xsl:param name="alturaLegenda">0</xsl:param>
    <xsl:param name="margemLateral">20</xsl:param>
    <xsl:param name="margemSuperior">10</xsl:param>    
    
    <!-- Ajustes -->
    <!-- Fonte alternativa - caso a fonte usada apresente problemas: pode ser uma lista de nomes de fonte. ex: helvetica, arial, 'trebuchet ms'-->
    <xsl:param name="fonteAlternativa"></xsl:param>
    <xsl:param name="tamFonte">10</xsl:param>
    <xsl:param name="maisX">0</xsl:param>
    <xsl:param name="maisY">0</xsl:param>
    <xsl:param name="escala">1.0</xsl:param>
    
    <xsl:param name="corDoSol">rgb(255,180,0)</xsl:param> <!-- Se Sol aparecer no grafico, sera desta cor -->
    <xsl:param name="corOutros">rgb(150,150,150)</xsl:param> <!-- Outros sao somatoria dos que tem menos de $percentMenorFatia -->
    
    <!-- Template que devolve uma cor -->
    <xsl:template name="cores">
        <xsl:param name="i"/>
        <xsl:variable name="cores" select="document($arquivoDeCores)/cores/cor" />
        <xsl:value-of select="$cores[position() = $i mod count($cores) + 1]"/>
    </xsl:template>
    
</xsl:stylesheet>