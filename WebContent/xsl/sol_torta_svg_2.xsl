<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <!-- Distribuicao de diametro no sistema solar - demonstracao com grafico de torta -->
    
    <xsl:import href="modulos/defaults.xsl"/>
    <xsl:import href="modulos/couthures_trig.xsl"/>
    <xsl:import href="modulos/parametros_graficos_de_torta_2.xsl"/> 
    
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
        //objeto/satelite[$sateliteObjeto]" ></xsl:variable>
    
    <!-- Ajustes -->
    <xsl:variable name="otherFont">
        <xsl:choose>
            <xsl:when test="$fonteAlternativa">
                <xsl:value-of select="concat($fonteAlternativa, ',')"/> <!-- para o CSS -->
            </xsl:when>
            <xsl:otherwise></xsl:otherwise> <!-- Vazio -->
        </xsl:choose>
    </xsl:variable>

    <!-- Calculo das dimensoes do grafico -->
    <xsl:variable name="itensMostrados" select="$objetosEscolhidos[@diametrokm][@diametrokm &gt; $minDiametro][@diametrokm &lt;= $maxDiametro][ancestor-or-self::node()/@afelioUA &gt;= $minOrbita or self::estrela][ancestor-or-self::node()/@afelioUA &lt;= $maxOrbita or self::estrela or self::estrela]" />
    <xsl:variable name="numeroDeItens" select="count($itensMostrados)" />
    
    <xsl:variable name="somaDosDiametros" select="sum($itensMostrados/@diametrokm)" />
    
    <!-- DIMENSOES DO GRAFICO (pixels) -->
    <!-- Calculo das dimensoes em pixels do grafico -->
    <xsl:variable name="alturaGrafico" select="$alturaViewBox - ($alturaCabecalho + $alturaLegenda)" />
    <xsl:variable name="larguraGrafico" select="$larguraViewBox - $margemLateral * 2" />
    
    <!-- Centro do grafico -->
    <xsl:variable name="cx" select="$larguraGrafico div 2" />
    <xsl:variable name="cy" select="$alturaGrafico div 2" />
    <xsl:variable name="raio" select="$cy - $margemLateral" />
    
    <xsl:template match="/">
        
        <!-- mensagens de log -->
        <xsl:message>Soma dos diametros (km): <xsl:value-of select="$somaDosDiametros"/></xsl:message>
        <xsl:message>Diametro (km): max: <xsl:value-of select="$maxDiametro"/> min: <xsl:value-of select="$minDiametro"/> </xsl:message> <!-- so retorna valor em procs XSLT 2.0 -->
        <xsl:message>Afelio (UA):   max: <xsl:value-of select="$maxOrbita"/> min: <xsl:value-of select="$minOrbita"/> </xsl:message>
        
        <svg height="{$altura}" width="{$largura}" viewBox="0 0 {$larguraViewBox} {$alturaViewBox}">
            <style type="text/css">
                text {font-family: <xsl:value-of select="$otherFont" /> calibri, sans-serif;}
            </style>
            <title><xsl:value-of select="$titulo"/></title>
            <defs>
                <rect id="tipoBarra" height="20" width="20" />
                <g id="legenda" style="font-size:12pt">
                    <text y="15" font-weight="bold" textLength="110">LEGENDA</text>
                </g>
                <g id="titulo">
                    <text y="30" font-size="24pt"><xsl:value-of select="$titulo"/></text>
                    <xsl:choose>
                        <xsl:when test="not($subtitulo)">
                            <text y="50" font-size="12pt">Objetos com diametros entre <xsl:value-of select="format-number($maxDiametro,'###.###')"/> e <xsl:value-of select="format-number($minDiametro,'###.###')"/> km</text>
                        </xsl:when>
                        <xsl:otherwise>
                            <text y="50" font-size="12pt"><xsl:value-of select="$subtitulo"/></text>
                        </xsl:otherwise>
                    </xsl:choose>
                </g>
                <g id="grafico" transform="scale({$escala}) translate({$maisX - 50}, {$maisY - 50})"> 
                    <xsl:apply-templates />
                </g>

            </defs>
            
            <use xlink:href="#titulo"  transform="translate(20,10)"/>
            <use xlink:href="#grafico" transform="translate(20,{$alturaCabecalho + 10})"/>
            <use xlink:href="#legenda" transform="translate(20,{$alturaGrafico + $alturaCabecalho + 20})"/>
        </svg>
    </xsl:template>
    
    <xsl:template match="sistemaSolar">
        <xsl:variable name="fatia" select="$itensMostrados[not(@diametrokm &lt; $itensMostrados/@diametrokm)]" /> 
        <xsl:call-template name="desenharFatia">
            <xsl:with-param name="fracao" select="$fatia/@diametrokm div $somaDosDiametros" />
            <xsl:with-param name="texto" select="concat($fatia/@nome, ': ', format-number($fatia/@diametrokm, '###.###,00'), 'km')" />
            <xsl:with-param name="fatiasRestantes" select="$itensMostrados[@diametrokm &lt; $itensMostrados/@diametrokm]" /> <!-- fatias menores -->
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="desenharFatia">
        <xsl:param name="anguloInicial" select="0" />
        <xsl:param name="fatiasRestantes" />
        <xsl:param name="fracao" />
        <xsl:param name="texto" />
        
        <xsl:variable name="angulo">
            <xsl:value-of select="$fracao * 360.0"/>
        </xsl:variable>

        <xsl:variable name="x1">
            <xsl:variable name="cos_x">
                <xsl:call-template name="cos">
                    <xsl:with-param name="x" select="$pi * $angulo div 180.0" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$cos_x * $raio" />
        </xsl:variable>
        
        <xsl:variable name="y1">
            <xsl:variable name="sin_y">
                <xsl:call-template name="sin">
                    <xsl:with-param name="x" select="$pi * $angulo div 180.0" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$sin_y * $raio" />
        </xsl:variable>
        
        <xsl:variable name="largeArcFlag">
            <xsl:choose>
                <xsl:when test="$angulo &gt; 180">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <g transform="rotate({$anguloInicial}, {$cx}, {$cy})">
            <path id="fatia_{count($fatiasRestantes)}" d="M {$cx} {$cy}
                L {$cx + $raio} {$cy}
                A {$raio} {$raio}  0  {$largeArcFlag},1  {$x1 + $cx} {$y1 + $cy} Z" stroke-width="5" stroke="white" fill-opacity="0.9" stroke-linejoin="round" stroke-linecap="round">
                <xsl:attribute name="fill">
                    <xsl:choose>
                        <xsl:when test="starts-with($texto,'Sol')"> 
                            <xsl:value-of select="$corDoSol"/>
                        </xsl:when>
                        <xsl:when test="starts-with($texto,'Outros')"> 
                            <xsl:value-of select="$corOutros"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="cores">
                                <xsl:with-param name="i" select="count($fatiasRestantes)"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </path>
            <xsl:choose>
                <xsl:when test="$angulo &gt; 30">
                    <text font-size="{$tamFonte}pt" fill="black" x="0" y="0"> 
                        <textPath startOffset="{$raio + $tamFonte*2}" xlink:href="#fatia_{count($fatiasRestantes)}" >
                            <xsl:value-of select="$texto"/>
                        </textPath>
                    </text>
                </xsl:when>
                <xsl:otherwise>
                    <text font-size="{$tamFonte}pt" fill="black" x="{$raio}" y="{$tamFonte * 1.2}" transform="translate({$cx}, {$cy})">
                        <xsl:value-of select="$texto"/>
                    </text>
                </xsl:otherwise>
            </xsl:choose>
            
            
        </g>
        
        <xsl:if test="$fatiasRestantes">
            <xsl:variable name="proxFatia" select="$fatiasRestantes[not(@diametrokm &lt; $fatiasRestantes/@diametrokm)]" />
            <xsl:choose>
                <xsl:when test="($proxFatia/@diametrokm div $somaDosDiametros) &lt; ($percentMenorFatia * 0.01)"> 
                    <xsl:variable name="fracaoTotal" select="sum($fatiasRestantes/@diametrokm) div $somaDosDiametros" />
                    <xsl:call-template name="desenharFatia">
                        <xsl:with-param name="anguloInicial" select="$angulo + $anguloInicial" />
                        <xsl:with-param name="fracao" select="$fracaoTotal" />
                        <xsl:with-param name="texto" select="concat($textoOutros, ': ', format-number(sum($fatiasRestantes/@diametrokm), '###.##0,00'), ' km')" />
                        <xsl:with-param name="fatiasRestantes" select="0" /> <!-- fim das fatias -->
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="desenharFatia">
                        <xsl:with-param name="anguloInicial" select="$angulo + $anguloInicial" />
                        <xsl:with-param name="fracao" select="$proxFatia/@diametrokm div $somaDosDiametros" />
                        <xsl:with-param name="texto" select="concat($proxFatia/@nome, ': ', format-number($proxFatia/@diametrokm, '###.##0,00'), ' km')" />
                        <xsl:with-param name="fatiasRestantes" select="$fatiasRestantes[@diametrokm &lt; $fatiasRestantes/@diametrokm]" /> <!-- fatias menores -->
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
            
    </xsl:template>
    
</xsl:stylesheet>