<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- 
         Desenha elipses com as orbitas dos planetas 
         Para configurar, use o arquivo parametros_sol_orbitas.xsl
         As orbitas nao levam em consideracao a projecao da inclinacao
         sobre o plano de referencia da terra.
         
         @author Helder da Rocha (helder.darocha@gmail.com)
         @version 0.2 2010-12-23
    -->

    <xsl:import href="modulos/geometria.xsl"/>
    <xsl:import href="modulos/couthures_trig.xsl"/>
    <xsl:import href="modulos/defaults.xsl"/>
    <xsl:import href="modulos/parametros_sol_orbitas_2.xsl"/>


    <!-- Selecao dos dados escolhidos para exibicao -->
    <xsl:variable name="objetosEscolhidos"
        select="//estrela [$estrela] | 
        //planetas/planeta-anao[$planetaAnao] | 
        //trans-netunianos/objeto [$tno] | 
        //cometas/cometa [$cometa] | 
        //centauros/objeto [$centauro] | 
        //asteroides/asteroide[$asteroide] |
        //planetas/planeta[$planeta] | //*[@nome = $destaque]"/>

    <!-- DIMENSOES ABSOLUTAS (UA) -->
    <!-- Calculo das dimensoes das orbitas escolhidas -->
    <xsl:variable name="itensMostrados"
        select="$objetosEscolhidos[(@periodoOrbitalD) and (@afelioUA &gt; $minOrbita) and (@afelioUA &lt;= $maxOrbita) and (@diametrokm &gt;= $minDiametro or self::cometa) and (@diametrokm &lt;= $maxDiametro) or (@nome = $destaque)]"/>
    <!-- [@massaKg &gt; $minMassa] -->

    <xsl:variable name="objetoMaiorAfelio"
        select="$itensMostrados[@afelioUA][not((@afelioUA) &lt; $itensMostrados/@afelioUA)]"/>
    <xsl:variable name="objetoMaiorPerielio"
        select="$itensMostrados[@perielioUA][not((@perielioUA) &lt; $itensMostrados/@perielioUA)]"/>
    <xsl:variable name="objetoMenorAfelio"
        select="$itensMostrados[@afelioUA][not((@afelioUA) &gt; $itensMostrados/@afelioUA)]"/>
    <xsl:variable name="objetoMenorPerielio"
        select="$itensMostrados[@perielioUA][not((@perielioUA) &gt; $itensMostrados/@perielioUA)]"/>

    <!-- Maior orbita sera considerada por afelio ou perielio? Altere para exibicoes diferentes -->
    <xsl:variable name="objetoMaiorOrbita" select="$objetoMaiorAfelio"/>
    <xsl:variable name="objetoMenorOrbita" select="$objetoMenorAfelio"/>

    <!-- <xsl:variable name="objetoMaiorOrbita" select="$objetoMaiorPerielio" /> -->
    <xsl:variable name="maiorSemiEixoMaior"
        select="($objetoMaiorOrbita/@afelioUA + $objetoMaiorOrbita/@perielioUA) div 2"/>
    <!-- semi-eixo maior do elipse -->
    <xsl:variable name="menorSemiEixoMaior"
        select="($objetoMenorOrbita/@afelioUA + $objetoMenorOrbita/@perielioUA) div 2"/>
    <!-- semi-eixo maior do elipse -->
    <xsl:variable name="maiorPeriodoOrbital"
        select="$itensMostrados[@periodoOrbitalD][not(@periodoOrbitalD &lt; $itensMostrados/@periodoOrbitalD)]/@periodoOrbitalD"/>

    <xsl:variable name="dfmax">
        <!-- distancia focal da maior orbita a mostrar -->
        <xsl:call-template name="calcularDistanciaFocal">
            <!-- Veja geometria.xsl -->
            <xsl:with-param name="afelio" select="$objetoMaiorOrbita/@afelioUA"/>
            <xsl:with-param name="perielio" select="$objetoMaiorOrbita/@perielioUA"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="maiorSemiEixoMenor">
        <xsl:call-template name="calcularSemiEixoMenor">
            <!-- Veja geometria.xsl -->
            <xsl:with-param name="distanciaFocal" select="$dfmax"/>
            <xsl:with-param name="semiEixoMaior" select="$maiorSemiEixoMaior"/>
        </xsl:call-template>
    </xsl:variable>

    <!-- DIMENSOES DO GRAFICO (pixels) -->
    <!-- Calculo das dimensoes em pixels do grafico -->
    <xsl:variable name="alturaGrafico" select="$alturaViewBox - ($alturaCabecalho + $alturaLegenda)"/>
    <xsl:variable name="larguraGrafico" select="$larguraViewBox - $margemLateral * 2"/>
    <!-- Margem lateral de 30 pixels de cada lado -->

    <!-- Centro do grafico -->
    <xsl:variable name="cx" select="$larguraGrafico div 2"/>
    <xsl:variable name="cy" select="$alturaGrafico div 2"/>

    <!-- Fator para converter os valores em pixels -->
    <xsl:variable name="fatorPx" select="$cx div $maiorSemiEixoMaior"/>

    <!-- Variaveis do grafico -->
    <xsl:variable name="dx0" select="($dfmax div 2) * $fatorPx"/>
    <!-- deslocamento do centro pixels no eixo x -->
    <xsl:variable name="fx2" select="$cx + $dx0"/>
    <!-- segundo foco do elipse - onde sera desenhado o sol -->

    <!-- Fatores para reduzir o grafico para que caiba no espaco e centralizar se necessario -->
    <xsl:variable name="redutor">
        <xsl:choose>
            <xsl:when test="$maiorSemiEixoMenor * 2 * $fatorPx &gt; $alturaGrafico">
                <xsl:value-of select="$alturaGrafico div ($maiorSemiEixoMenor * $fatorPx * 2)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="centralizador">
        <xsl:choose>
            <xsl:when test="$redutor != 1">
                <xsl:value-of
                    select="($larguraGrafico - ($maiorSemiEixoMaior * $redutor * $fatorPx * 2)) div 2"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- TEMPLATES -->
    <xsl:template match="/">

        <!-- mensagens de log -->
        <xsl:message>Diametro (km): max: <xsl:value-of select="$maxDiametro"/> min: <xsl:value-of
                select="$minDiametro"/>
        </xsl:message>
        <xsl:message>Afelio (UA): max: <xsl:value-of select="$maxOrbita"/> min: <xsl:value-of
                select="$minOrbita"/>
        </xsl:message>

        <svg height="{$altura}" width="{$largura}" viewBox="0 0 {$larguraViewBox} {$alturaViewBox}">
            <script><xsl:text disable-output-escaping="yes">
              var svg = document.documentElement;
              var svgns = 'http://www.w3.org/2000/svg';
              var xlinkns = 'http://www.w3.org/1999/xlink';
              
              var paused = false;
              
              function togglePause() {
                 if (paused) {
                    play();
                 } else {
                    pause();
                 }
              }
              function pause() {
                 svg.pauseAnimations();
                 paused = true;
                 document.getElementById("pauseButton").setAttribute("opacity","0");
                 document.getElementById("playButton").setAttribute("opacity","0.5");
              }
              function play() {
                 svg.unpauseAnimations();
                 paused = false;
                 document.getElementById("playButton").setAttribute("opacity","0");
                 document.getElementById("pauseButton").setAttribute("opacity","0.5");
              }
            </xsl:text></script>
            
            <xsl:if test="$usarAnimacaoScript">
                 <script><xsl:text disable-output-escaping="yes"><![CDATA[
                   function getCoords(objId, duration, offset) {
                    if (!paused) {
                      var obj   = document.getElementById(objId);
     
                      var currTime = new Date().getTime() - obj.startTime;
                      if (currTime >= duration) { // BAD
                         obj.startTime = new Date().getTime();
                      }
             
                      var position = (obj.path.length) * (currTime / duration) + offset;
                      if (position >= obj.path.length) {
                         obj.startTime = new Date().getTime();
                         offset = 0;
                      }
             
                      var point = obj.path.getPointAtLength(position);                
                      obj.graph.setAttributeNS(null, "transform", "translate("+point.x+","+point.y+")");
                       //graph.transform.baseVal.setTranslate(point.x, point.y);
                     }
                   }
                   
                   function animate(objId, duration, offset) {
                      var obj = document.getElementById(objId);
                      obj.startTime = new Date().getTime();
                      obj.path      = document.getElementById(objId + "-path");
                      obj.graph     = document.getElementById(objId + "-object");
                      obj.id        = objId;
                      obj.path.length = obj.path.getTotalLength();
                      setInterval('getCoords("'+objId+'",'+duration*1000+','+offset+')', 30);
                   }
                ]]></xsl:text></script>
           </xsl:if>

            <style type="text/css">
                text {
                    font-family: calibri, sans-serif;
                }</style>
            <title>
                <xsl:value-of select="$titulo"/>
            </title>
            <defs>
                <filter id="raios" filterUnits="userSpaceOnUse" x="0" y="0" width="100%"
                    height="100%">
                    <feGaussianBlur stdDeviation="6"/>
                </filter>
                <rect id="fundo" fill="{$corDeFundo}" height="{$alturaViewBox}"
                    width="{$larguraViewBox}"/>
                <rect id="tipoBarra" height="15" width="15"/>
                <g id="legenda" style="font-size:12pt" fill="{$corDoTexto}">
                    <text y="13" font-weight="bold" textLength="110">LEGENDA</text>
                    <use xlink:href="#tipoBarra" x="135" fill="{$corPlaneta}"/>
                    <text x="160" y="13">Planeta</text>
                    <use xlink:href="#tipoBarra" x="235" fill="{$corPlanetaAnao}"/>
                    <text x="260" y="13">Planeta-Anão</text>
                    <use xlink:href="#tipoBarra" x="375" fill="{$corAsteroide}"/>
                    <text x="400" y="13">Asteroide</text>
                    <use xlink:href="#tipoBarra" x="495" fill="{$corTNO}"/>
                    <text x="520" y="13">Objeto Trans-Netuniano</text>
                    <use xlink:href="#tipoBarra" x="695" fill="{$corCometa}"/>
                    <text x="720" y="13">Cometa</text>
                    <use xlink:href="#tipoBarra" x="795" fill="{$corCentauro}"/>
                    <text x="820" y="13">Centauro</text>
                    <xsl:if test="$textoLegendaDestaque">
                        <use xlink:href="#tipoBarra" x="895" fill="{$corDestaque}"/>
                        <text x="920" y="13"><xsl:value-of select="$textoLegendaDestaque"/></text>
                    </xsl:if>
                </g>
                <g id="titulo" fill="{$corDoTexto}">
                    <text y="30" font-size="24pt">
                        <xsl:value-of select="$titulo"/>
                    </text>
                    <xsl:choose>
                        <xsl:when test="not($subtitulo)">
                            <text y="50" x="2" font-size="12pt">Orbitas entre <xsl:value-of
                                    select="format-number($menorSemiEixoMaior,'###.##0,###')"/> e
                                    <xsl:value-of
                                    select="format-number($maiorSemiEixoMaior,'###.##0,###')"/>
                                UA</text>
                            <text y="70" x="2" font-size="12pt">
                                <xsl:text>Exibindo </xsl:text>
                                <xsl:value-of select="count($itensMostrados)"/>
                                <xsl:text> objetos</xsl:text>
                                <xsl:if test="$minDiametro &gt; 0">
                                    <xsl:text> com diametro maior que </xsl:text>
                                    <xsl:value-of select="format-number($minDiametro,'###.###,###')"/>
                                    <xsl:text> km</xsl:text>
                                    <xsl:if test="$maxDiametro &lt; $diametroDeJupiter">
                                        <xsl:text> e menor que </xsl:text>
                                        <xsl:value-of
                                            select="format-number($maxDiametro,'###.###,###')"/>
                                        <xsl:text> km</xsl:text>
                                    </xsl:if>
                                </xsl:if>
                                <xsl:text>.</xsl:text>
                            </text>
                        </xsl:when>
                        <xsl:otherwise>
                            <text y="50" font-size="12pt">
                                <xsl:value-of select="$subtitulo"/>
                            </text>
                        </xsl:otherwise>
                    </xsl:choose>
                </g>
                <g id="grafico"
                    transform="scale({$redutor * $escala}) translate({$centralizador + $maisX}, {$maisY})">
                    <xsl:apply-templates/>
                </g>
                <g id="controles" onclick="togglePause()">
                    <g id="pauseButton" opacity="0.5">
                        <circle r="15" cx="15" cy="15" fill="navy" stroke="yellow" stroke-width="3"><title>Clique no gráfico para pausar a animação</title></circle>
                        <rect width="5" height="15" x="9" y="7.5" fill="yellow" />
                        <rect width="5" height="15" x="16" y="7.5" fill="yellow" />
                    </g>
                    <g id="playButton" opacity="0">
                        <circle r="15" cx="15" cy="15" fill="navy" stroke="yellow" stroke-width="3"><title>Clique no gráfico para reiniciar a animação</title></circle>
                        <polygon points="10,6 24,15 10,24" fill="yellow"></polygon>
                    </g>
                </g>
            </defs>
            <use xlink:href="#fundo"/>
            <use xlink:href="#grafico"
                transform="translate({$margemLateral},{$alturaCabecalho + $margemSuperior})"/>
            <use xlink:href="#titulo" transform="translate({$margemLateral},{$margemSuperior})"/>
            <xsl:if test="$mostrarLegenda">
                <use xlink:href="#legenda"
                    transform="translate({$margemLateral},{$alturaGrafico + $alturaCabecalho + $margemSuperior}) scale(0.8) "
                />
            </xsl:if>
            <xsl:if test="not($graficoEstatico)">
                <use xlink:href="#controles"
                    transform="translate({$larguraGrafico},{$margemSuperior})"
                />
            </xsl:if>
        </svg>
    </xsl:template>

    <xsl:template match="sistemaSolar">
        <xsl:for-each select="$itensMostrados">
            <xsl:sort select="@diametrokm" data-type="number" /> <!-- objetos maiores sao desenhados em cima -->

            <!-- VARIAVEIS DA ITERACAO - mudam para cada objeto da lista. -->
            <!-- 1. Calculo do elipse plano (sem considerar inclinacao): semi-eixos (raios do elipse) -->
            <xsl:variable name="semiEixoMaior" select="(@afelioUA + @perielioUA) div 2"/>
            <xsl:variable name="dFocal">
                <xsl:call-template name="calcularDistanciaFocal">
                    <!-- Veja geometria.xsl -->
                    <xsl:with-param name="afelio" select="@afelioUA"/>
                    <xsl:with-param name="perielio" select="@perielioUA"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="semiEixoMenor">
                <xsl:call-template name="calcularSemiEixoMenor">
                    <!-- Veja geometria.xsl -->
                    <xsl:with-param name="distanciaFocal" select="$dFocal"/>
                    <xsl:with-param name="semiEixoMaior" select="$semiEixoMaior"/>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="redutorInclinacao">
                <xsl:call-template name="cos">
                    <xsl:with-param name="x" select="$pi * @inclinacao div 180.0" />
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="fatorInc">
                <xsl:choose>
                    <xsl:when test="not($naoConsiderarInclinacao)">
                        <xsl:variable name="inclinacao">
                            <xsl:choose>
                                <xsl:when test="@inclinacao &gt; 90 and @inclinacao &lt; 270">
                                    <xsl:value-of select="@inclinacao - 180"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@inclinacao"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="fatorInc">
                            <xsl:call-template name="cos">
                                <xsl:with-param name="x" select="$pi * ($inclinacao) div 180.0" />
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="$fatorInc"/>
                    </xsl:when>
                    <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="girarOrbita">
                <xsl:choose>
                    <xsl:when test="@argumentoPerielio">
                        <xsl:choose>
                            <xsl:when test="$redutorInclinacao &gt; 0"> <!-- i < 90 or i > 270 -->
                                <xsl:value-of select="@argumentoPerielio"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@argumentoPerielio - 180"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="sentidoOrbita">
                <xsl:choose>
                    <xsl:when test="@inclinacao and not($graficoEstatico)">
                        <xsl:choose>
                            <xsl:when test="$redutorInclinacao &gt; 0"> <!-- i < 90 or i > 270 -->
                                <xsl:text>0</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>1</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>0</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <!-- 2. Calculo do elipse para desenhar -->
            <xsl:variable name="rx" select="$semiEixoMaior  * $fatorPx"/>
            <xsl:variable name="ry" select="$semiEixoMenor  * $fatorPx * $fatorInc"/>
            <xsl:variable name="dx" select="($dFocal div 2) * $fatorPx"/>
            <!-- centro gravitacional -->
            <xsl:variable name="x0" select="$fx2 - ($rx + $dx)"/>
            <xsl:variable name="x1" select="$fx2 + ($rx - $dx)"/>
            <xsl:variable name="periodoOrbital"
                select="(@periodoOrbitalD div $maiorPeriodoOrbital)*$segundosOrbitaMaxima"/>

            <!-- cor do objeto -->
            <xsl:variable name="cor">
                <xsl:choose>
                    <xsl:when test="@nome = $destaque">
                        <xsl:value-of select="$corDestaque"/>
                    </xsl:when>
                    <xsl:when test="self::planeta">
                        <xsl:value-of select="$corPlaneta"/>
                    </xsl:when>
                    <xsl:when test="self::asteroide[ancestor::asteroides]">
                        <xsl:value-of select="$corAsteroide"/>
                    </xsl:when>
                    <xsl:when test="self::planeta-anao">
                        <xsl:value-of select="$corPlanetaAnao"/>
                    </xsl:when>
                    <xsl:when test="self::objeto[ancestor::trans-netunianos]">
                        <xsl:value-of select="$corTNO"/>
                    </xsl:when>
                    <xsl:when test="self::objeto[ancestor::centauros]">
                        <xsl:value-of select="$corCentauro"/>
                    </xsl:when>
                    <xsl:when test="self::cometa[ancestor::cometas]">
                        <xsl:value-of select="$corCometa"/>
                    </xsl:when>
                    <xsl:otherwise> white </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <!-- espessura da linha da orbita -->
            <xsl:variable name="linha">
                <xsl:choose>
                    <xsl:when test="@nome = $destaque">
                        <xsl:value-of select="$linhaDestaque"/>
                    </xsl:when>
                    <xsl:when test="self::planeta">
                        <xsl:value-of select="$linhaPlaneta"/>
                    </xsl:when>
                    <xsl:when test="self::asteroide[ancestor::asteroides]">
                        <xsl:value-of select="$linhaAsteroide"/>
                    </xsl:when>
                    <xsl:when test="self::planeta-anao">
                        <xsl:value-of select="$linhaPlanetaAnao"/>
                    </xsl:when>
                    <xsl:when test="self::objeto[ancestor::trans-netunianos]">
                        <xsl:value-of select="$linhaTNO"/>
                    </xsl:when>
                    <xsl:when test="self::objeto[ancestor::centauros]">
                        <xsl:value-of select="$linhaCentauro"/>
                    </xsl:when>
                    <xsl:when test="self::cometa[ancestor::cometas]">
                        <xsl:value-of select="$linhaCometa"/>
                    </xsl:when>
                    <xsl:otherwise> 0.5 </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <!-- raio do circulo do objeto animado -->
            <xsl:variable name="circulo">
                <xsl:choose>
                    <xsl:when test="@nome = $destaque">
                        <xsl:value-of select="$circuloDestaque"/>
                    </xsl:when>
                    <xsl:when test="self::planeta">
                        <xsl:value-of select="$circuloPlaneta"/>
                    </xsl:when>
                    <xsl:when test="self::asteroide[ancestor::asteroides]">
                        <xsl:value-of select="$circuloAsteroide"/>
                    </xsl:when>
                    <xsl:when test="self::planeta-anao">
                        <xsl:value-of select="$circuloPlanetaAnao"/>
                    </xsl:when>
                    <xsl:when test="self::objeto[ancestor::trans-netunianos]">
                        <xsl:value-of select="$circuloTNO"/>
                    </xsl:when>
                    <xsl:when test="self::objeto[ancestor::centauros]">
                        <xsl:value-of select="$circuloCentauro"/>
                    </xsl:when>
                    <xsl:when test="self::cometa[ancestor::cometas]">
                        <xsl:value-of select="$circuloCometa"/>
                    </xsl:when>
                    <xsl:otherwise> 2 </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <!-- raio do circulo do objeto animado -->
            <xsl:variable name="mostrarNome">
                <xsl:choose>
                    <xsl:when test="@nome = $destaque">
                        <xsl:value-of select="$mostrarNomeDestaque"/>
                    </xsl:when>
                    <xsl:when test="self::planeta">
                        <xsl:value-of select="$mostrarNomePlaneta"/>
                    </xsl:when>
                    <xsl:when test="self::asteroide[ancestor::asteroides]">
                        <xsl:value-of select="$mostrarNomeAsteroide"/>
                    </xsl:when>
                    <xsl:when test="self::planeta-anao">
                        <xsl:value-of select="$mostrarNomePlanetaAnao"/>
                    </xsl:when>
                    <xsl:when test="self::objeto[ancestor::trans-netunianos]">
                        <xsl:value-of select="$mostrarNomeTNO"/>
                    </xsl:when>
                    <xsl:when test="self::objeto[ancestor::centauros]">
                        <xsl:value-of select="$mostrarNomeCentauro"/>
                    </xsl:when>
                    <xsl:when test="self::cometa[ancestor::cometas]">
                        <xsl:value-of select="$mostrarNomeCometa"/>
                    </xsl:when>
                    <xsl:otherwise> 1 </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <!-- 
                Falta compensar a inclinacao: descobrir o semieixo
                perpendicular, e multiplicar pelo cos(i)
            -->

            <xsl:variable name="tamFonte">
                <xsl:choose>
                    <xsl:when test="@nome = $destaque">
                        <xsl:value-of select="$tamFonteDestaque"/> 
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$tamFonte"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <!-- DADOS A EXIBIR EM CADA ITERACAO DO FOR-EACH -->
            <g id="{@id}" transform="rotate({translate(format-number($girarOrbita,'0,##'),',','.')},{translate(format-number($fx2,'0,##'),',','.')},{translate(format-number($cy,'0,##'),',','.')}) ">
                <xsl:if test="$usarAnimacaoScript and not($graficoEstatico)">
                    <xsl:attribute name="onload">
                        <xsl:text>animate(this.id, </xsl:text>
                        <xsl:value-of select="translate(format-number($periodoOrbital,'0,##'),',','.')"/>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="0"/> <!-- offset - not implemented yet -->
                        <xsl:text>)</xsl:text>
                    </xsl:attribute>
                </xsl:if>
                <path id="{@id}-path"  stroke="{$cor}" stroke-width="{$linha}" stroke-opacity="0.5" fill="none" d="M {translate(format-number($x0,'0,##'),',','.')},{translate(format-number($cy,'0,##'),',','.')} A {translate(format-number($rx,'0,##'),',','.')},{translate(format-number($ry,'0,##'),',','.')} 0 1,{$sentidoOrbita} {translate(format-number($x1,'0,##'),',','.')},{translate(format-number($cy,'0,##'),',','.')} A {translate(format-number($rx,'0,##'),',','.')},{translate(format-number($ry,'0,##'),',','.')} 0 0,{$sentidoOrbita} {translate(format-number($x0,'0,##'),',','.')},{translate(format-number($cy,'0,##'),',','.')}"/>
                <g fill="{$cor}" id="{@id}-object">
                    <xsl:if test="$circulo and $circulo != 0 or $mostrarNome = 1"> <!-- Se circulo do objeto tiver raio zero, e nome for omitido, nao tem o que animar-->
                        <xsl:if test="not($graficoEstatico) and not($usarAnimacaoScript)">
                            <animateMotion dur="{translate(format-number($periodoOrbital,'0,##'),',','.')}s" repeatCount="indefinite" rotate="none">
                                <xsl:if test="not($velocidadeOrbitalConstante)">
                                    <xsl:attribute name="calcMode"><xsl:text>spline</xsl:text></xsl:attribute>
                                    <xsl:attribute name="keyTimes"><xsl:text>0;1</xsl:text></xsl:attribute>
                                    <xsl:attribute name="keyPoints"><xsl:text>0;1</xsl:text></xsl:attribute>
                                    <xsl:attribute name="keySplines">
                                        <xsl:value-of select="$rx div ($rx + $ry)"/>
                                        <xsl:text>,</xsl:text>
                                        <xsl:value-of select="$ry div ($rx + $ry)"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="$ry div ($rx + $ry)"/>
                                        <xsl:text>,</xsl:text>
                                        <xsl:value-of select="$rx div ($rx + $ry)"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <mpath xlink:href="#{@id}-path"/>
                            </animateMotion>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="$graficoEstatico">
                                <circle cx="{translate(format-number($x0,'0,##'),',','.')}" cy="{translate(format-number($cy,'0,##'),',','.')}" r="{$circulo}">
                                    <title><xsl:value-of select="@nome"/> (<xsl:value-of select="name()"/><xsl:if test="@categoria">, </xsl:if><xsl:value-of select="@categoria"/>)</title>
                                </circle>
                                <xsl:if test="$mostrarNome = 1">
                                    <text x="{translate(format-number($x0,'0,##'),',','.') + $tamFonte div 2 + 2}" y="{translate(format-number($cy,'0,##'),',','.') + $tamFonte div 2 - 2}" font-size="{$tamFonte}" transform="rotate({-translate(format-number($girarOrbita,'0,##'),',','.')}, {translate(format-number($x0,'0,##'),',','.')}, {translate(format-number($cy,'0,##'),',','.')})">
                                        <xsl:value-of select="@nome"/>
                                    </text>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <circle cx="0" cy="0" r="{$circulo}">
                                    <title><xsl:value-of select="@nome"/> (<xsl:value-of select="name()"/>, <xsl:value-of select="@categoria"/>)</title>
                                </circle>
                                <xsl:if test="$mostrarNome = 1">
                                    <text x="{$tamFonte div 2 + 2}" y="{$tamFonte div 2}" font-size="{$tamFonte}" transform="rotate({-translate(format-number($girarOrbita,'0,##'),',','.')})">
                                        <xsl:value-of select="@nome"/>
                                    </text>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </g>
            </g>
        </xsl:for-each>
        
        <!-- desenho do sol -->
        <xsl:if test="$brilhoSol">
            <circle fill="yellow" filter="url(#raios)" r="10" cx="{$fx2}" cy="{$cy}"/>
            <!-- raios do sol -->
        </xsl:if>
        <circle fill="white" r="2.5" cx="{$fx2}" cy="{$cy}"/>
        
    </xsl:template>
</xsl:stylesheet>
