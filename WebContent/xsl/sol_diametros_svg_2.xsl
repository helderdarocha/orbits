<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <!-- Folha de estilo atualizada para extrair diametros de sol_2010 
         Configure a aparencia no arquivo parametros_graficos_de_barra.xsl   
    -->
    
    <xsl:import href="modulos/defaults.xsl"/>
    <xsl:import href="modulos/parametros_graficos_de_barra_2.xsl"/>
    
    <!-- Selecao dos dados escolhidos -->
    <xsl:variable name="objetosEscolhidos" 
        select="//estrela [$estrela] | 
        //planeta-anao[$planetaAnao] | 
        //trans-netunianos/objeto [$tno] | 
        //cometas/cometa [$cometa] | 
        //centauros/objeto [$centauro] | 
        //asteroide[$asteroide] |
        //planeta[$planeta] | 
        //planeta/satelite[$satelitePlaneta] | 
        //asteroide/satelite[$sateliteAsteroide] |
        //planeta-anao/satelite[$satelitePlanetaAnao] |
        //objeto/satelite[$sateliteObjeto]" />
    
    <xsl:variable name="otherFont">
        <xsl:choose>
            <xsl:when test="$fonteAlternativa">
                <xsl:value-of select="concat($fonteAlternativa, ',')"/> <!-- para o CSS -->
            </xsl:when>
            <xsl:otherwise></xsl:otherwise> <!-- Vazio -->
        </xsl:choose>
    </xsl:variable>
    
    <!-- Calculo das dimensoes do grafico -->
    <xsl:variable name="itensMostrados" select="$objetosEscolhidos[@diametrokm &gt; $minDiametro][@diametrokm &lt;= $maxDiametro][ancestor-or-self::node()/@afelioUA &gt;= $minOrbita or self::estrela][ancestor-or-self::node()/@afelioUA &lt;= $maxOrbita or self::estrela or self::estrela]" />
    <xsl:variable name="maiorDiametroMostrado" select="$itensMostrados[@diametrokm][not(@diametrokm &lt; $itensMostrados/@diametrokm)]/@diametrokm" />
    <xsl:variable name="menorDiametroMostrado" select="$itensMostrados[@diametrokm][not(@diametrokm &gt; $itensMostrados/@diametrokm)]/@diametrokm" />
    <xsl:variable name="numeroDeItens" select="count($itensMostrados)" />
    <xsl:variable name="alturaGrafico" select="$alturaViewBox - ($alturaCabecalho + $alturaLegenda)" />
    <xsl:variable name="alturaBarra" select="$alturaGrafico div $numeroDeItens - $espacoEntreItens" />
    <xsl:variable name="alturaItem" select="$alturaBarra + $espacoEntreItens" />
    <xsl:variable name="maiorBarra" select="$larguraViewBox - ($larguraNome + $larguraValor + 20)" />
    
    <xsl:template match="/">
        
        <!-- mensagens de log -->
        <xsl:message>Diametro (km): max: <xsl:value-of select="$maxDiametro"/> min: <xsl:value-of select="$minDiametro"/> </xsl:message>
        <xsl:message>Afelio (UA):   max: <xsl:value-of select="$maxOrbita"/> min: <xsl:value-of select="$minOrbita"/> </xsl:message>
        
        <svg height="{$altura}" width="{$largura}" viewBox="0 0 {$larguraViewBox} {$alturaViewBox}">
            <style type="text/css">
                text {font-family: <xsl:value-of select="$otherFont" /> calibri, sans-serif;}
            </style>
            <title><xsl:value-of select="$titulo"/></title>
            <defs>
                <filter id="sombra">
                    <feGaussianBlur in="SourceGraphic" stdDeviation="7" />
                </filter>
                
                <rect id="tipoBarra" height="15" width="15" />
                <g id="legenda" style="font-size:12pt" fill="black">
                    <text y="13" font-weight="bold" textLength="110">LEGENDA</text>
                    <use xlink:href="#tipoBarra" x="135" fill="{$corPlaneta}" /><text x="160" y="13">Planeta</text>
                    <use xlink:href="#tipoBarra" x="235" fill="{$corPlanetaAnao}" /><text x="260" y="13">Planeta-Anão</text>
                    <use xlink:href="#tipoBarra" x="375" fill="{$corAsteroide}" /><text x="400" y="13">Asteroide</text>
                    <use xlink:href="#tipoBarra" x="495" fill="{$corTNO}" /><text x="520" y="13">Objeto Trans-Netuniano</text>
                    <use xlink:href="#tipoBarra" x="695" fill="{$corCometa}" /><text x="720" y="13">Cometa</text>
                    <use xlink:href="#tipoBarra" x="795" fill="{$corCentauro}" /><text x="820" y="13">Centauro</text>
                    <use xlink:href="#tipoBarra" x="895" fill="{$corSatelite}" /><text x="920" y="13">Satelite</text>
                </g>
                <g id="titulo">
                    <text y="30" font-size="24pt"><xsl:value-of select="$titulo"/></text>
                    <xsl:choose>
                        <xsl:when test="not($subtitulo)">
                            <text y="50" font-size="12pt">Objetos com diametros entre <xsl:value-of select="format-number($menorDiametroMostrado,'###.###')"/> e <xsl:value-of select="format-number($maiorDiametroMostrado,'###.###')"/> km</text>
                        </xsl:when>
                        <xsl:otherwise>
                            <text y="50" font-size="12pt"><xsl:value-of select="$subtitulo"/></text>
                        </xsl:otherwise>
                    </xsl:choose>
                </g>
                <g id="grafico">
                    <xsl:apply-templates />
                </g>
                <g id="imagens">
                    <xsl:apply-templates select="//imagem" />
                </g>
            </defs>
            
            <use xlink:href="#titulo"  transform="translate(20,10)"/>
            <use xlink:href="#grafico" transform="translate(20,{$alturaCabecalho + 10})"/>
            <use xlink:href="#legenda" transform="translate(20,{$alturaGrafico + $alturaCabecalho + 20}) scale(0.9)"/>
            <use xlink:href="#imagens" transform="translate({$larguraViewBox - ($larguraImagem + 10)},{$alturaViewBox - ($alturaImagem + $alturaLegenda + 10)})" />
        </svg>
    </xsl:template>
    
    <xsl:template match="sistemaSolar">
        <xsl:for-each select="$itensMostrados">
            <xsl:sort select="@diametrokm" order="descending" data-type="number"/>
            <g>
                <xsl:attribute name="id">
                    <xsl:choose>
                        <xsl:when test="imagem">
                            <xsl:value-of select="substring-before(imagem/@href, '.')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@id"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <title>
                    <xsl:if test="self::satelite">
                        <xsl:text>Satelite de </xsl:text><xsl:value-of select="../@nome"/>
                    </xsl:if>
                    <xsl:if test="self::planeta">
                        <xsl:value-of select="count(preceding-sibling::*) + 1"/><xsl:text>o. </xsl:text>
                        <xsl:text>planeta</xsl:text>
                    </xsl:if>
                </title>
                <desc>
                    <xsl:if test="self::planeta">
                        <xsl:text>Raio medio da orbita: </xsl:text><xsl:value-of select="../@raioMedUA"/><xsl:text> UA. </xsl:text>
                    </xsl:if>
                    <xsl:if test="self::planeta | self::objeto | self::planeta-anao | self::asteroide | self::cometa | self::centauro">
                        <xsl:text>Afelio: </xsl:text><xsl:value-of select="@afelioUA"/><xsl:text> UA. Perielio: </xsl:text><xsl:value-of select="@perielioUA"/><xsl:text> UA. Periodo orbital: </xsl:text><xsl:value-of select="@periodoOrbitalD div 365"/><xsl:text> anos. </xsl:text>
                    </xsl:if>
                    <xsl:if test="self::satelite">
                        <xsl:text>Raio medio da orbita: </xsl:text><xsl:value-of select="format-number(@raioMedOrbitakm,'###.###')"/><xsl:text> km. </xsl:text>
                    </xsl:if>
                    <xsl:if test="@anoDescobrimento">
                        <xsl:text>Descoberto em </xsl:text><xsl:value-of select="@anoDescobrimento"/><xsl:text> por </xsl:text><xsl:value-of select="@descobertoPor"/><xsl:text>.</xsl:text>
                    </xsl:if>
                </desc>
                <text font-size="12pt" x="0"   y="{$alturaItem div 2 + (position() - 1)*$alturaItem}"><xsl:value-of select="position()"/><xsl:text>. </xsl:text><xsl:value-of select="@nome"/></text>
                <rect x="{$larguraNome}" y="{(position() - 1) * $alturaItem}" width="{(@diametrokm div $maiorDiametroMostrado)*$maiorBarra}" height="{$alturaBarra}">
                    <xsl:attribute name="fill">
                        <xsl:if test="self::planeta"><xsl:value-of select="$corPlaneta"/></xsl:if>
                        <xsl:if test="self::asteroide"><xsl:value-of select="$corAsteroide"/></xsl:if>
                        <xsl:if test="self::satelite"><xsl:value-of select="$corSatelite"/></xsl:if>
                        <xsl:if test="self::estrela"><xsl:value-of select="$corEstrela"/></xsl:if>
                        <xsl:if test="self::planeta-anao"><xsl:value-of select="$corPlanetaAnao"/></xsl:if>
                        <xsl:if test="self::objeto[ancestor::trans-netunianos]"><xsl:value-of select="$corTNO"/></xsl:if>
                        <xsl:if test="self::cometa[ancestor::cometas]"><xsl:value-of select="$corCometa"/></xsl:if>
                        <xsl:if test="self::objeto[ancestor::centauros]"><xsl:value-of select="$corCentauro"/></xsl:if>
                    </xsl:attribute>
                </rect>
                <text font-size="12pt" x="{(@diametrokm div $maiorDiametroMostrado)*$maiorBarra + $larguraNome + 10}" y="{$alturaItem div 2 + (position() - 1)*$alturaItem}"><xsl:value-of select="format-number(@diametrokm,'###.###')"/> km</text>
            </g>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="imagem">
        <g opacity="0.0">
            <text x="0" y="-5" font-size="14pt" fill="black"><xsl:value-of select="../@nome"/></text>
            <rect x="-2" y="-2" height="{$alturaImagem+4}" width="{$larguraImagem+4}" fill="black" filter="url(#sombra)" />
            <image xlink:href="{concat($urlImagens, '/', @href)}" x="0" y="0" height="{$alturaImagem}" width="{$larguraImagem}" />
            <animate attributeName="opacity" from="0.0" to="1.0" begin="{substring-before(@href, '.')}.mouseover" dur="1s" fill="freeze"/>
            <animate attributeName="opacity" from="1.0" to="0.0" begin="{substring-before(@href, '.')}.mouseout"  dur="1s" fill="freeze"/>
        </g>
    </xsl:template>
</xsl:stylesheet>