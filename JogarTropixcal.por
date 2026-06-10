programa
{
	/*DECLARAÇAO DAS BIBLIOTECAS*/
	inclua biblioteca Tipos --> tipo inclua biblioteca Matematica --> math inclua biblioteca Objetos --> o inclua biblioteca Util inclua biblioteca Teclado --> t inclua biblioteca Graficos --> g
	
		const	inteiro D_x = 960, D_y = 512, tamNav = 64
	
		const	logico  Debug = falso
		
				logico  Menu = verdadeiro, Spawnar = falso, Morto = falso, Animando, Respawnou = falso
	
				inteiro quantObjs = 0, navDelay = 0, X = D_x/2-tamNav/2, Y = D_y/2-tamNav/2, MS = 4, inimigos = 0, HP = 10, Opac = 255
	
	/*Sprites*/	inteiro navSprt, bolSprt, Gavi[3], Bacue[2] ,sard[3],Logo, CeuAlto[2],CeuInferior[2],Cervejas[3], Crayviota[2]

	/*PALHETA*/	inteiro CINZA = g.criar_cor(128, 128, 200)

	/*fps*/		inteiro tempo_inicio_fps = 0, tempo_fps = 0, frames = 0, fps = 0, espere = 10

	/*CEU*/		inteiro CeuCima[3], CeuBaixo[3],CeuCimaXY[3][2],CeuBaixoXY[3][2],CeuLarg = 480, Offset = 0

	/*Ondas*/		inteiro Onda = 0, EsperandoOnda = 0, tick = 0, Creditos = 0

	funcao carregarSprites(){
		navSprt = g.carregar_imagem("Sprites/1_Navio/Navio.png")
		bolSprt = g.carregar_imagem("Sprites/1_Navio/BolCanhao.png")
		
		para(inteiro i=0;i<2;i++)Bacue[i]	= g.carregar_imagem("Sprites/3_Bacue/Bacue"+(i+1)+".png")
		para(inteiro i=0;i<3;i++){
			sard[i]  = g.carregar_imagem("Sprites/2_Gaviota/Sardinhas/peixe"+(i+1)+".png")
			Gavi[i] 	= g.carregar_imagem("Sprites/2_Gaviota/Gaviota"+(i+1)+".png")
		}
		CeuAlto[0] = 		g.carregar_imagem("Sprites/4_Ceus/CeuAlto1.png")
		CeuAlto[1] = 		g.carregar_imagem("Sprites/4_Ceus/CeuAlto2.png")
		CeuInferior[0] = 	g.carregar_imagem("Sprites/4_Ceus/CeuBaixo1.png")
		CeuInferior[1] = 	g.carregar_imagem("Sprites/4_Ceus/CeuBaixo2.png")
		Cervejas[0] =		g.carregar_imagem("Sprites/GUI/Vida1.png")
		Cervejas[1] =		g.carregar_imagem("Sprites/GUI/Vida2.png")
		Cervejas[2] =		g.carregar_imagem("Sprites/GUI/Vida0.png")
		Crayviota[0]=		g.carregar_imagem("Sprites/2_Gaviota/GaviotaDoida1.png")
		Logo = g.carregar_imagem("Sprites/GUI/TROPIXCAL.png")
	}
	funcao Gamestart(){
		g.iniciar_modo_grafico(verdadeiro)
		g.definir_titulo_janela("Tropixcal")
		g.definir_dimensoes_janela(D_x, D_y)
		g.exibir_borda_janela()
		
		carregarSprites()
	}
	funcao KeysInFase(){
		se(X+1<D_x-tamNav	e (t.tecla_pressionada(t.TECLA_SETA_DIREITA) ou t.tecla_pressionada(t.TECLA_D))e nao(Morto))X+=MS
		se(X-1>=0 		e (t.tecla_pressionada(t.TECLA_SETA_ESQUERDA)ou t.tecla_pressionada(t.TECLA_A))e nao(Morto))X-=MS
		se(Y+1<D_y-tamNav	e (t.tecla_pressionada(t.TECLA_SETA_ABAIXO)	ou t.tecla_pressionada(t.TECLA_S))e nao(Morto))Y+=MS
		se(Y-1>=0 		e (t.tecla_pressionada(t.TECLA_SETA_ACIMA) 	ou t.tecla_pressionada(t.TECLA_W))e nao(Morto))Y-=MS
		/*ATIRAR*/
		se(t.tecla_pressionada(t.TECLA_ESPACO) e navDelay <= 0)tiroNavio()
		senao se(navDelay>0) navDelay--
	}
	funcao KeysInMenu(){
		se(t.tecla_pressionada(t.TECLA_ENTER))Menu = falso
	}
	funcao DebugUpdt(){
		se(t.tecla_pressionada(t.TECLA_5) e navDelay <= 0){
			//spawn da Gaviota
			spawnGaviota1((Util.sorteia(2,2*6))*32)
		}
		se(t.tecla_pressionada(t.TECLA_6) e navDelay <= 0){
			//spawn do Bacue
			spawnGaviotaDoida1(D_y/2)
		}
	}
	funcao KeysInGameOver(){
		se(t.tecla_pressionada(t.TECLA_ENTER)){
			Morto = falso
			HP = 10
			Spawnar = verdadeiro
		}
	}
	/*Linha Principal*/
	funcao inicio()
	{
		Gamestart()
		
		inicioMenu()
		faca{
			inicioFase()
	
			GameOverAnim()
	
			Restart()	
		}enquanto(verdadeiro)
	}
	/*MENU DO JOGO*/
	funcao inicioMenu(){
		faca{
			Ceus()
			Informacao(255)
			g.desenhar_imagem(D_x/2-240, D_y/3, Logo)
			
			g.definir_gradiente(g.GRADIENTE_ACIMA, CINZA, 0xAABBFF)
			g.definir_tamanho_texto(30.0)
			inteiro larg = g.largura_texto("APERTE ENTER")
			g.desenhar_retangulo((D_x-larg)/2-2, D_y/2+55, larg+2, 27, verdadeiro, falso)
			g.desenhar_texto((D_x-larg)/2, D_y/2+55, "APERTE ENTER")
			g.renderizar()
			KeysInMenu()
		}enquanto(Menu)
		inteiro Trans = 90, add = 55, Opac2 = 0
		cadeia texto = "APERTE ENTER"
		
		faca{
			Ceus()
			Informacao(Opac2)
			g.definir_gradiente(g.GRADIENTE_ACIMA, CINZA, 0xAABBFF)
			g.definir_tamanho_texto(30.0)
			inteiro larg = g.largura_texto(texto)
			g.desenhar_retangulo((D_x-larg)/2-2, D_y/2+add, larg+2, 27, verdadeiro, falso)
			g.desenhar_texto((D_x-larg)/2, D_y/2+add, texto)
			g.desenhar_imagem(X, Y, navSprt)
			inteiro imgLogo = g.carregar_imagem("Sprites/GUI/TropAlfa/Tropixcal-"+Trans/10+".png")
			g.desenhar_imagem(D_x/2-240, D_y/3, imgLogo)
			g.renderizar()
			g.liberar_imagem(imgLogo)
			se(Opac2<255)Opac2+=3
			Trans-=10
			add = add/2
			se		(Trans == 80)texto = "PERTE ENTE"
			senao se	(Trans == 70)texto = "ERTE ENT"
			senao se	(Trans == 60)texto = "RTE EN"
			senao se	(Trans == 50)texto = "TE E"
			senao se	(Trans == 40)texto = "E "
			senao se	(Trans == 30)texto = ""
			Util.aguarde(espere)
		}enquanto(Trans>0)
		escreva("Inicio")
		spawnGaviota1(D_y/2)
	}
	funcao inicioFase(){
		faca{
			Ceus()
			BarradeVida()
			KeysInFase()
			NovaOnda()
			Ondas()
			tickOnda()
			para(inteiro i = 0; i<quantObjs; i++){
				descarregarObj(i)
			}
			para(inteiro i = 0; i<quantObjs; i++){
				carregarObjeto(i)
			}
			g.desenhar_imagem(X, Y, navSprt)
			estabilizeFps()
			g.renderizar()
			GameOverCheck()
			Util.aguarde(espere)
		}enquanto(nao(Morto))
	}
	funcao GameOverAnim(){
		Animando = verdadeiro
		faca{
			Ceus()
			BarradeVida()
			para(inteiro i = 0; i<quantObjs; i++){
				descarregarObj(i)
			}
			para(inteiro i = 0; i<quantObjs; i++){
				carregarObjeto(i)
			}
			g.desenhar_imagem(X, Y, navSprt)
			estabilizeFps()
			se(Opac>0){
				Opac--
			}senao Animando = falso
			g.definir_opacidade(Opac)
			g.definir_cor(g.COR_PRETO)
			g.desenhar_retangulo(0, 0, D_x, D_y, falso, verdadeiro)
			g.renderizar()
			Util.aguarde(espere)
		}enquanto(Morto e Animando)
	}
	funcao Restart(){
		o.liberar()
		inimigos = 0
		quantObjs = 0
		faca{
			g.definir_cor(g.COR_PRETO)
			g.limpar()
			estabilizeFps()
			
			g.definir_tamanho_texto(64.0)
			g.definir_fonte_texto("Times New Roman")
			g.definir_cor(0xFFFFFF)
			g.definir_estilo_texto(verdadeiro, falso, falso)
			inteiro larg = g.largura_texto("Tentar denovo?")
			g.definir_opacidade(Opac)
			g.desenhar_texto(D_x/2-larg/2, D_y/2-g.altura_texto("Tentar denovo?")/2, "Tentar denovo?")
			g.definir_opacidade(255)
			g.renderizar()
			se(Opac<255)Opac++
			KeysInGameOver()
			Util.aguarde(espere)
		}enquanto(Morto)
		Spawnar = verdadeiro
		Respawnou = verdadeiro
		X = D_x/2-32
		Y = D_y/2-32
	}
	funcao carregarObjeto(inteiro i){
		escolha(o.obter_propriedade_tipo_inteiro(i, "Obj")){
			caso  3:			//Gaviota doida
				se(o.contem_propriedade(i, "Sor")){
					g.desenhar_imagem(o.obter_propriedade_tipo_inteiro(i, "X")+tipo.real_para_inteiro(o.obter_propriedade_tipo_real(i, "Sor")),o.obter_propriedade_tipo_inteiro(i, "Y"), Crayviota[0])
					o.atribuir_propriedade(i, "Sor", o.obter_propriedade_tipo_real(i, "Sor")/1.05)
				}senao{
					se(o.obter_propriedade_tipo_logico(i, "Cima?")){
						se (o.obter_propriedade_tipo_inteiro(i, "Y")+o.obter_propriedade_tipo_inteiro(i, "T")+2 < D_y)	o.atribuir_propriedade(i, "Y", o.obter_propriedade_tipo_inteiro(i, "Y")+2)
						senao o.atribuir_propriedade(i, "Cima?", falso)
					}senao se(o.obter_propriedade_tipo_inteiro(i, "Y")-2 > 0){
						o.atribuir_propriedade(i, "Y", o.obter_propriedade_tipo_inteiro(i, "Y")-2)
					}senao o.atribuir_propriedade(i, "Cima?", verdadeiro)
					se(o.obter_propriedade_tipo_logico(i, "Direita?")){
						se (o.obter_propriedade_tipo_inteiro(i, "X")+o.obter_propriedade_tipo_inteiro(i, "T")+4 < D_x)	o.atribuir_propriedade(i, "X", o.obter_propriedade_tipo_inteiro(i, "X")+4)
						senao o.atribuir_propriedade(i, "Direita?", falso)
					}senao se(o.obter_propriedade_tipo_inteiro(i, "X")-4 > 0){
						o.atribuir_propriedade(i, "X", o.obter_propriedade_tipo_inteiro(i, "X")-4)
					}senao o.atribuir_propriedade(i, "Direita?", verdadeiro)

					o.atribuir_propriedade(i, "Delay", o.obter_propriedade_tipo_inteiro(i, "Delay") - 1)
					g.definir_rotacao(OlharNavio(o.obter_propriedade_tipo_inteiro(i, "X")+o.obter_propriedade_tipo_inteiro(i, "T")/2, o.obter_propriedade_tipo_inteiro(i, "Y")+o.obter_propriedade_tipo_inteiro(i, "T")/2))
					g.desenhar_imagem(o.obter_propriedade_tipo_inteiro(i, "X"),o.obter_propriedade_tipo_inteiro(i, "Y"),Crayviota[0])
					g.definir_rotacao(0)
				}
			pare
			caso  2:			//BACUE
				se(o.contem_propriedade(i, "Sor")){
					g.definir_rotacao(-15)
					g.desenhar_imagem(o.obter_propriedade_tipo_inteiro(i, "X")+tipo.real_para_inteiro(o.obter_propriedade_tipo_real(i, "Sor")),o.obter_propriedade_tipo_inteiro(i, "Y"), Bacue[0])
					g.definir_rotacao(0)
					o.atribuir_propriedade(i, "Sor", o.obter_propriedade_tipo_real(i, "Sor")/1.05)
				}senao{
					se(o.contem_propriedade(i, "VelX")){
						o.atribuir_propriedade(i,  "X"  , o.obter_propriedade_tipo_inteiro(i, "X")+o.obter_propriedade_tipo_inteiro(i, "VelX"))
						o.atribuir_propriedade(i,  "Y"  , o.obter_propriedade_tipo_inteiro(i, "Y")+o.obter_propriedade_tipo_inteiro(i, "VelY"))
						g.definir_rotacao(o.obter_propriedade_tipo_inteiro(i, "Ang")-15)
						g.desenhar_imagem(o.obter_propriedade_tipo_inteiro(i, "X"),o.obter_propriedade_tipo_inteiro(i, "Y"),Bacue[1])
						g.definir_rotacao(0)
					}senao{
						se(o.obter_propriedade_tipo_inteiro(i, "Delay") <= 0){
							Normalize(i,12)
						}senao se(o.obter_propriedade_tipo_inteiro(i, "Delay") < 45){
							g.definir_rotacao(OlharNavio(o.obter_propriedade_tipo_inteiro(i, "X")+o.obter_propriedade_tipo_inteiro(i, "T")/2, o.obter_propriedade_tipo_inteiro(i, "Y")+o.obter_propriedade_tipo_inteiro(i, "T")/2)-15)
							g.desenhar_imagem(o.obter_propriedade_tipo_inteiro(i, "X"),o.obter_propriedade_tipo_inteiro(i, "Y"),Bacue[1])
							g.definir_rotacao(0)
							o.atribuir_propriedade(i, "Delay", o.obter_propriedade_tipo_inteiro(i, "Delay")-1)
						}senao{
							g.definir_rotacao(OlharNavio(o.obter_propriedade_tipo_inteiro(i, "X")+o.obter_propriedade_tipo_inteiro(i, "T")/2, o.obter_propriedade_tipo_inteiro(i, "Y")+o.obter_propriedade_tipo_inteiro(i, "T")/2)-15)
							g.desenhar_imagem(o.obter_propriedade_tipo_inteiro(i, "X"),o.obter_propriedade_tipo_inteiro(i, "Y"),Bacue[0])
							g.definir_rotacao(0)
							o.atribuir_propriedade(i, "Delay", o.obter_propriedade_tipo_inteiro(i, "Delay")-1)
						}
					}
				}
			pare
			caso  1:			//GAVIOTA
				se(o.contem_propriedade(i, "Sor")){
					g.desenhar_imagem(o.obter_propriedade_tipo_inteiro(i, "X")+tipo.real_para_inteiro(o.obter_propriedade_tipo_real(i, "Sor")),o.obter_propriedade_tipo_inteiro(i, "Y"), Gavi[1])
					o.atribuir_propriedade(i, "Sor", o.obter_propriedade_tipo_real(i, "Sor")/1.05)
				}senao{
					/*SISTEMA DE CIMA E BAIXO*/
					se(o.obter_propriedade_tipo_logico(i, "Cima?")){
						se (o.obter_propriedade_tipo_inteiro(i, "Y")+o.obter_propriedade_tipo_inteiro(i, "T")+2 < D_y)	o.atribuir_propriedade(i, "Y", o.obter_propriedade_tipo_inteiro(i, "Y")+2)
						senao o.atribuir_propriedade(i, "Cima?", falso)
					}senao se(o.obter_propriedade_tipo_inteiro(i, "Y")-2 > 0){
						o.atribuir_propriedade(i, "Y", o.obter_propriedade_tipo_inteiro(i, "Y")-2)
					}senao o.atribuir_propriedade(i, "Cima?", verdadeiro)

					o.atribuir_propriedade(i, "Delay", o.obter_propriedade_tipo_inteiro(i, "Delay") - 1)
					g.desenhar_imagem(o.obter_propriedade_tipo_inteiro(i, "X"),o.obter_propriedade_tipo_inteiro(i, "Y"), Gavi[tipo.logico_para_inteiro(o.obter_propriedade_tipo_logico(i,"Ati"))])
				}
			pare
			caso -1:			//TIRO DO NAVIO
				o.atribuir_propriedade(i, "X", o.obter_propriedade_tipo_inteiro(i, "X")+8)
				g.definir_cor(g.COR_AZUL)
				g.desenhar_imagem(o.obter_propriedade_tipo_inteiro(i, "X"),o.obter_propriedade_tipo_inteiro(i, "Y"), bolSprt)
				g.desenhar_elipse(o.obter_propriedade_tipo_inteiro(i, "X")-1,o.obter_propriedade_tipo_inteiro(i, "Y")-1,18,18, falso)
			pare
			caso -2:
				o.atribuir_propriedade(i, "X", o.obter_propriedade_tipo_inteiro(i, "X")-8)
				g.definir_cor(g.COR_AZUL)
				
				g.desenhar_elipse(o.obter_propriedade_tipo_inteiro(i, "X"),o.obter_propriedade_tipo_inteiro(i, "Y"), o.obter_propriedade_tipo_inteiro(i, "T"),o.obter_propriedade_tipo_inteiro(i, "T"), falso)
				g.desenhar_imagem(o.obter_propriedade_tipo_inteiro(i, "X"),o.obter_propriedade_tipo_inteiro(i, "Y"), sard[o.obter_propriedade_tipo_inteiro(i, "Spr")])
			pare
			caso -3:			//TIRO DA LOUCA
				se(o.contem_propriedade(i, "VelX")){
					o.atribuir_propriedade(i,  "X"  , o.obter_propriedade_tipo_inteiro(i, "X")+o.obter_propriedade_tipo_inteiro(i, "VelX"))
					o.atribuir_propriedade(i,  "Y"  , o.obter_propriedade_tipo_inteiro(i, "Y")+o.obter_propriedade_tipo_inteiro(i, "VelY"))
					g.desenhar_elipse(o.obter_propriedade_tipo_inteiro(i, "X"),o.obter_propriedade_tipo_inteiro(i, "Y"), o.obter_propriedade_tipo_inteiro(i, "T"),o.obter_propriedade_tipo_inteiro(i, "T"), falso)
					g.definir_rotacao(o.obter_propriedade_tipo_inteiro(i, "Ang"))
					g.desenhar_imagem(o.obter_propriedade_tipo_inteiro(i, "X"),o.obter_propriedade_tipo_inteiro(i, "Y"), sard[o.obter_propriedade_tipo_inteiro(i, "Spr")])
					g.definir_rotacao(0)
				}senao Normalize(i,4)
			pare
		}
	}
	funcao descarregarObj(inteiro i){
		escolha(o.obter_propriedade_tipo_inteiro(i, "Obj")){
			caso  3:
				se(o.contem_propriedade(i, "Sor")){
					se(o.obter_propriedade_tipo_real(i, "Sor")<1){
						spawnGaviotaDoida2(i)
						o.liberar_objeto(i)
					}
				}senao{
					/*ANIMAÇAO*/
					se(o.obter_propriedade_tipo_inteiro(i, "Delay") < 10 ou o.obter_propriedade_tipo_inteiro(i, "Delay") > 170){
						  o.atribuir_propriedade(i, "Ati" , verdadeiro)
					}senao o.atribuir_propriedade(i, "Ati" , falso)
					/*FIM ANIMAÇAO*/
					se(o.obter_propriedade_tipo_inteiro(i, "Hp") <= 0){
						quantObjs--
						inimigos--
						o.liberar_objeto(i)
					}senao se (o.obter_propriedade_tipo_inteiro(i, "Delay") <= 0){
						o.atribuir_propriedade(i, "Delay", 180)
						tiroGaviotaDoida(i)
					}
				}
			pare
			caso  2:
				se(o.contem_propriedade(i, "Sor")){
					se(o.obter_propriedade_tipo_real(i, "Sor")<1){
						spawnBacue2(i)
						o.liberar_objeto(i)
					}
				}senao se(o.obter_propriedade_tipo_inteiro(i, "X") > D_x ou o.obter_propriedade_tipo_inteiro(i, "X") < 0-o.obter_propriedade_tipo_inteiro(i, "T") ou o.obter_propriedade_tipo_inteiro(i, "Y") > D_y ou o.obter_propriedade_tipo_inteiro(i, "Y") < 0-o.obter_propriedade_tipo_inteiro(i, "T")){
					quantObjs--
					inimigos--
					o.liberar_objeto(i)
				}senao se(coliEntidadeNavio(i) e nao(o.contem_propriedade(i, "Hit"))){
					HP-= 2
					o.atribuir_propriedade(i, "Hit", verdadeiro)
				}
			pare
			caso  1:
			se(o.contem_propriedade(i, "Sor")){
				se(o.obter_propriedade_tipo_real(i, "Sor")<1){
					spawnGaviota2(i)
					o.liberar_objeto(i)
				}
			}senao{
				/*ANIMAÇAO*/
				se(o.obter_propriedade_tipo_inteiro(i, "Delay") < 10 ou o.obter_propriedade_tipo_inteiro(i, "Delay") > 170){
					  o.atribuir_propriedade(i, "Ati" , verdadeiro)
				}senao o.atribuir_propriedade(i, "Ati" , falso)
				/*FIM ANIMAÇAO*/
				se(o.obter_propriedade_tipo_inteiro(i, "Hp") <= 0){
					quantObjs--
					inimigos--
					o.liberar_objeto(i)
				}senao se (o.obter_propriedade_tipo_inteiro(i, "Delay") <= 0){
					o.atribuir_propriedade(i, "Delay", 180)
					tiroGaviota(i)
				}
			}
			pare
			caso -1:
				se(o.obter_propriedade_tipo_inteiro(i, "X") > D_x ou o.obter_propriedade_tipo_inteiro(i, "X") < 0-o.obter_propriedade_tipo_inteiro(i, "T") ou o.obter_propriedade_tipo_logico(i, "Hit")){
					quantObjs--
					o.liberar_objeto(i)
				}senao{
					para(inteiro j = 0 ; j < quantObjs ; j++){
						se((o.obter_propriedade_tipo_inteiro(j, "Obj") == 1 ou o.obter_propriedade_tipo_inteiro(j, "Obj") == 3)  e o.obter_propriedade_tipo_logico(i, "Hit") != verdadeiro e o.contem_propriedade(j, "Hp")){
							se (coliTiroEntidade(i,j)){
								o.atribuir_propriedade(i, "Hit", verdadeiro)
								o.atribuir_propriedade(j, "Hp", o.obter_propriedade_tipo_inteiro(j, "Hp")-2)
							}
						}
					}
				}
			pare
			caso -2:
				se(o.obter_propriedade_tipo_inteiro(i, "X") > D_x ou o.obter_propriedade_tipo_inteiro(i, "X") < 0-o.obter_propriedade_tipo_inteiro(i, "T") ou o.obter_propriedade_tipo_logico(i, "Hit")){
					quantObjs--
					o.liberar_objeto(i)
				}senao se(coliEntidadeNavio(i) e nao(o.obter_propriedade_tipo_logico(i, "Hit"))){
					o.atribuir_propriedade(i, "Hit", verdadeiro)
					HP-= 1
					quantObjs--
					o.liberar_objeto(i)
				}
			pare
			caso -3:
				se(o.obter_propriedade_tipo_inteiro(i, "X") > D_x ou o.obter_propriedade_tipo_inteiro(i, "X") < 0-o.obter_propriedade_tipo_inteiro(i, "T") ou o.obter_propriedade_tipo_inteiro(i, "Y") > D_y ou o.obter_propriedade_tipo_inteiro(i, "Y") < 0-o.obter_propriedade_tipo_inteiro(i, "T")){
					quantObjs--
					o.liberar_objeto(i)
				}senao se(coliEntidadeNavio(i) e nao(o.contem_propriedade(i, "Hit"))){
					HP-= 1
					o.atribuir_propriedade(i, "Hit", verdadeiro)
					quantObjs--
					o.liberar_objeto(i)
				}
			pare
		}
		
	}
	funcao estabilizeFps()
	{
		frames = frames + 1
		tempo_fps = Util.tempo_decorrido() - tempo_inicio_fps

		se (tempo_fps >= 1000)
		{
			fps = frames
			tempo_inicio_fps = Util.tempo_decorrido() - (tempo_fps - 1000)
			frames = 0
			se(fps<85 e espere>7)espere--
			senao se(fps>100 e espere<11)espere++
		}
		g.definir_tamanho_texto(12.0)
		g.definir_cor(0xFFFFFF)
		g.definir_estilo_texto(falso, verdadeiro, falso)
		g.desenhar_texto(25, 25, "FPS: " + fps)	
	}
	funcao BarradeVida(){
		para(inteiro i = 0; i <5; i++){
			inteiro j = (i*64)-128
			g.desenhar_imagem(D_x/2-32+j, D_y/10, Cervejas[2])
			se(HP>=(i+1)*2 ou HP == 10){
				g.desenhar_imagem(D_x/2-32+j, D_y/10, Cervejas[1])
			}senao se(HP == (i+1)*2-1){
				g.desenhar_imagem(D_x/2-32+j, D_y/10, Cervejas[0])
			}
		}
	}
	/*GAME OVER*/
	funcao GameOverCheck(){
		se(HP<1)Morto = verdadeiro
	}
	funcao Informacao(inteiro opac2){
		g.definir_opacidade(opac2)
		g.definir_tamanho_texto(32.0)
		g.definir_fonte_texto("Times New Roman")
		g.definir_cor(0xFFFFFF)
		g.definir_estilo_texto(verdadeiro, falso, falso)
		inteiro larg = g.largura_texto("Jogo feito por:")
		g.desenhar_texto(D_x/2-larg/2, D_y/16-g.altura_texto("Jogo feito por:")/2, "Jogo feito por:")
		larg = g.largura_texto("Thiago Henrique, Julia Bianchi e Ryan Oliveira")
		g.desenhar_texto(D_x/2-larg/2, D_y/8-g.altura_texto("Thiago Henrique, Julia Bianchi e Ryan Oliveira")/2, "Thiago Henrique, Julia Bianchi e Ryan Oliveira")
		g.definir_opacidade(255)
	}
	/*CEU*/
	funcao Ceus(){
		para(inteiro i = 0; i<3;i++){
			se(CeuCima[i]==0){
				CeuCima[i] = Util.sorteia(1, 2)
			}senao{
				inteiro x = i*CeuLarg-Offset
				g.desenhar_imagem(x, 0, CeuAlto[CeuCima[i]-1])
			}
			se(CeuBaixo[i]==0){
				CeuBaixo[i] = Util.sorteia(1, 2)
			}senao{
				inteiro x = i*CeuLarg-Offset
				g.desenhar_imagem(x, D_y/2, CeuInferior[CeuBaixo[i]-1])
			}
		}
		se(Offset<480)Offset++
		senao{
			Offset = 0
			CeuCima[0] = CeuCima[1]
			CeuCima[1] = CeuCima[2]
			CeuCima[2] = 0
			CeuBaixo[0] = CeuBaixo[1]
			CeuBaixo[1] = CeuBaixo[2]
			CeuBaixo[2] = 0
		}
	}
	/*FUNÇÕES SPAWN*/
	funcao spawnGaviota1(inteiro y){
		inteiro i = o.criar_objeto(), sort = (Util.sorteia(2,2*4))*32
		o.atribuir_propriedade(i,  "X"  , D_x-sort)
		o.atribuir_propriedade(i,  "Y"  , y-32)
		o.atribuir_propriedade(i, "Obj" , 1)
		o.atribuir_propriedade(i, "Sor" , tipo.inteiro_para_real(sort))

		inimigos++
		quantObjs++
	}
	funcao spawnGaviota2(inteiro j){
		inteiro i = o.criar_objeto()
		o.atribuir_propriedade(i,  "X"  , o.obter_propriedade_tipo_inteiro(j, "X"))
		o.atribuir_propriedade(i,  "Y"  , o.obter_propriedade_tipo_inteiro(j, "Y"))
		o.atribuir_propriedade(i,  "T"  , 64)
		o.atribuir_propriedade(i, "Ati" , falso)
		o.atribuir_propriedade(i,"Delay", 180)
		o.atribuir_propriedade(i, "Hp"  , 6)
		o.atribuir_propriedade(i, "Obj" , 1)
		o.atribuir_propriedade(i,"Cima?", tipo.inteiro_para_logico(Util.sorteia(0,1)))
	}
	funcao spawnBacue1(){
		inteiro i = o.criar_objeto(), sort = (Util.sorteia(2,2*4))*32
		o.atribuir_propriedade(i,  "X"  , D_x-sort)
		o.atribuir_propriedade(i,  "Y"  , (Util.sorteia(0,14))*32)
		o.atribuir_propriedade(i, "Obj" , 2)
		o.atribuir_propriedade(i, "Sor" , tipo.inteiro_para_real(sort))

		inimigos++
		quantObjs++
	}
	funcao spawnBacue2(inteiro j){
		inteiro i = o.criar_objeto()
		o.atribuir_propriedade(i,  "X"  , o.obter_propriedade_tipo_inteiro(j, "X"))
		o.atribuir_propriedade(i,  "Y"  , o.obter_propriedade_tipo_inteiro(j, "Y"))
		o.atribuir_propriedade(i,  "T"  , 64)
		o.atribuir_propriedade(i,"Delay", 180)
		o.atribuir_propriedade(i, "Obj" , 2)
	}
	funcao spawnGaviotaDoida1(inteiro y){
		inteiro i = o.criar_objeto(), sort = (Util.sorteia(2,2*4))*32
		o.atribuir_propriedade(i,  "X"  , D_x-sort)
		o.atribuir_propriedade(i,  "Y"  , y-32)
		o.atribuir_propriedade(i, "Obj" , 3)
		o.atribuir_propriedade(i, "Sor" , tipo.inteiro_para_real(sort))

		inimigos++
		quantObjs++
	}
	funcao spawnGaviotaDoida2(inteiro j){
		inteiro i = o.criar_objeto()
		o.atribuir_propriedade(i,  "X"  , o.obter_propriedade_tipo_inteiro(j, "X"))
		o.atribuir_propriedade(i,  "Y"  , o.obter_propriedade_tipo_inteiro(j, "Y"))
		o.atribuir_propriedade(i,  "T"  , 64)
		o.atribuir_propriedade(i, "Ati" , falso)
		o.atribuir_propriedade(i,"Delay", 180)
		o.atribuir_propriedade(i, "Hp"  , 10)
		o.atribuir_propriedade(i, "Obj" , 3)
		o.atribuir_propriedade(i,"Cima?", tipo.inteiro_para_logico(Util.sorteia(0,1)))
		o.atribuir_propriedade(i,"Direita?", verdadeiro)
	}
	/*FUNÇÕES TIRO*/
	funcao tiroNavio(){
		inteiro i = o.criar_objeto()
		o.atribuir_propriedade(i, "X" , X+tamNav-tamNav/4)
		o.atribuir_propriedade(i, "Y" , Y+tamNav-tamNav/4)
		o.atribuir_propriedade(i, "T" , 16)
		o.atribuir_propriedade(i,"Hit", falso)
		o.atribuir_propriedade(i,"Obj", -1)
		quantObjs++
		navDelay = 45
	}
	funcao tiroGaviota(inteiro j){
		inteiro i = o.criar_objeto()
		o.atribuir_propriedade(i, "X" , o.obter_propriedade_tipo_inteiro(j, "X"))
		o.atribuir_propriedade(i, "Y" , o.obter_propriedade_tipo_inteiro(j, "Y")+16)
		o.atribuir_propriedade(i, "T" , 32)                                   
		o.atribuir_propriedade(i,"Dmg", 1) // precisa mesmo?
		o.atribuir_propriedade(i,"Hit", falso)
		o.atribuir_propriedade(i,"Obj", -2)
		o.atribuir_propriedade(i,"Spr", Util.sorteia(0, 2))
		quantObjs++
	}
	funcao tiroGaviotaDoida(inteiro j){
		inteiro i = o.criar_objeto()
		o.atribuir_propriedade(i,  "X"  , o.obter_propriedade_tipo_inteiro(j, "X"))
		o.atribuir_propriedade(i,  "Y"  , o.obter_propriedade_tipo_inteiro(j, "Y"))
		o.atribuir_propriedade(i,  "T"  , 28)
		o.atribuir_propriedade(i, "Obj" , -3)
		o.atribuir_propriedade(i,"Spr", Util.sorteia(0, 2))
		quantObjs++
	}
	/*FUNÇOES ONDAS*/
	funcao NovaOnda(){
		se(inimigos <= 0 e nao(Spawnar ou Respawnou)){
			Onda++
			Spawnar = verdadeiro
			se(Onda == 6) EsperandoOnda = 255
			senao EsperandoOnda = 128
			HP = 10
		}senao se(Respawnou){
			Respawnou = falso
			Spawnar = verdadeiro
			EsperandoOnda = 128
		}
	}
	funcao Ondas(){
		se(Spawnar){
			se(EsperandoOnda>-127 e nao(Onda == 6)){
				EsperandoOnda--
				g.definir_tamanho_texto(64.0)
				g.definir_fonte_texto("Times New Roman")
				g.definir_cor(0xFFFFFF)
				g.definir_estilo_texto(verdadeiro, falso, falso)
				inteiro larg = g.largura_texto("Onda " + Onda)
				g.definir_opacidade(tipo.real_para_inteiro(255.0-math.valor_absoluto(tipo.inteiro_para_real(EsperandoOnda*2))))
				g.desenhar_texto(D_x/2-larg/2, D_y/2-g.altura_texto("Onda " + Onda)/2, "Onda " + Onda)
				g.definir_opacidade(255)
			}senao{
				escolha(Onda){
					caso 0:
						spawnGaviota1(D_y/2)
						Spawnar = falso
					pare
					caso 1:
						para(inteiro i=0;i<3;i++){
							spawnGaviota1((Util.sorteia(1,2*7))*32)
						}
						Spawnar = falso
					pare
					caso 2:
						para(inteiro i=0;i<5;i++)spawnBacue1()
						Spawnar = falso
					pare
					caso 3:
						para(inteiro i=0;i<4;i++){
							spawnGaviota1((Util.sorteia(1,2*7))*32)
						}
						Spawnar = falso
					pare
					caso 4:
						para(inteiro i=0;i<3;i++){
							spawnGaviota1((Util.sorteia(1,2*7))*32)
						}
						spawnGaviotaDoida1(D_y/2)
						Spawnar = falso
					pare
					caso 5:
						para(inteiro i=0;i<3;i++){
							spawnGaviota1((Util.sorteia(1,2*7))*32)
						}
						spawnGaviotaDoida1(D_y/6)
						spawnGaviotaDoida1(D_y-D_y/2)
						Spawnar = falso
					pare
				}
				se(Onda >= 6){
					g.definir_tamanho_texto(64.0)
					g.definir_fonte_texto("Times New Roman")
					g.definir_cor(0xFFFFFF)
					g.definir_estilo_texto(verdadeiro, falso, falso)
					inteiro larg = g.largura_texto("Parabens!")
					g.definir_opacidade(tipo.real_para_inteiro(255.0-EsperandoOnda))
					g.desenhar_texto(D_x/2-larg/2, D_y/2-g.altura_texto("Parabens!")/2, "Parabens!")
					g.definir_opacidade(255)
					se(EsperandoOnda>0)EsperandoOnda--
					senao{
						se(Creditos<255)Creditos++
						g.definir_opacidade(Creditos)
						g.definir_tamanho_texto(32.0)
						larg = g.largura_texto("Programado por Thiago Henrique do Rego")
						g.desenhar_texto(D_x/2-larg/2, D_y-D_y/3-g.altura_texto("Programado por Thiago Henrique do Rego")/2, "Programado por Thiago Henrique do Rego")
						larg = g.largura_texto("Desenhado por Julia Bianchi")
						g.desenhar_texto(D_x/2-larg/2, D_y-D_y/4-g.altura_texto("Desenhado por Julia Bianchi")/2, "Desenhado por Julia Bianchi")
						larg = g.largura_texto("Trabalho de STI, Fundação Bradesco Marilia")
						g.desenhar_texto(D_x/2-larg/2, D_y/16-g.altura_texto("Trabalho de STI, Fundação Bradesco Marilia")/2, "Trabalho de STI, Fundação Bradesco Marilia")
						g.definir_opacidade(255)
					}
				}
			}
		}
	}
	funcao tickOnda(){
		se(tick <= 0 e EsperandoOnda <-126){
			se (Onda>4){
				se (Util.sorteia(0,5) == 5){
					spawnBacue1()
				}
				tick = fps
			}senao se (Onda>2){
				se (Util.sorteia(0,10) == 10){
					spawnBacue1()
				}
				tick = fps
			}
		}senao{tick--}
	}
	/*FUNÇÕES MATEMATICAS*/
	funcao Normalize(inteiro i,inteiro vel){
		// x/|x|
		real xA = tipo.inteiro_para_real(X+32-(o.obter_propriedade_tipo_inteiro(i, "X")+o.obter_propriedade_tipo_inteiro(i, "T")/2))
		real yA = tipo.inteiro_para_real(Y+32-(o.obter_propriedade_tipo_inteiro(i, "Y")+o.obter_propriedade_tipo_inteiro(i, "T")/2))
		real div = math.raiz((xA*xA)+(yA*yA), 2.0)
		xA = (xA/div)*vel
		yA = (yA/div)*vel
		
		o.atribuir_propriedade(i, "VelX", tipo.real_para_inteiro(math.arredondar(xA, 0)))
		o.atribuir_propriedade(i, "VelY", tipo.real_para_inteiro(math.arredondar(yA, 0)))
		o.atribuir_propriedade(i, "Ang" , OlharNavio(o.obter_propriedade_tipo_inteiro(i, "X"), o.obter_propriedade_tipo_inteiro(i, "Y")))
	}
	funcao inteiro OlharNavio(inteiro x, inteiro y){
		// 	Isso daqui é arco tangente,bgl estranho mesmo.
		real CatetoOpo = tipo.inteiro_para_real(y)-tipo.inteiro_para_real(Y+32)
		real CatetoAdj = tipo.inteiro_para_real(x)-tipo.inteiro_para_real(X+32)
		real Tangente  = math.tangente(CatetoOpo/CatetoAdj)
		inteiro Angulo = Arctan(Tangente,CatetoAdj,CatetoOpo)
		/*	FAMILIA DO 30, FAMILIA DO 45, FAMILIA DO 60
			VALORES EXTRAS PRA CASOS COMO 90 E 270 GRAUS
			DESCOBRIR O QUADRANTE PARA FAZER O CALCULO DO ANGULO.*/
		se (CatetoOpo<0)Angulo = Angulo*-1
		se (CatetoAdj<0)Angulo = (Angulo+180)*-1
		retorne Angulo
	}
	funcao inteiro Arctan(real Tan, real Cadj, real Copo){
		real tan = math.valor_absoluto(Tan), Copo2 = math.valor_absoluto(Copo), Cadj2 = math.valor_absoluto(Cadj)
		
		se(Cadj2<Copo2/2.2 e Cadj2>-Copo2/2.2){
			retorne 90
		}senao{
			se(tan< 0.13)			retorne 0
			se(tan>=0.13 e tan<0.35)	retorne 15
			se(tan>=0.35 e tan<0.75)	retorne 30
			se(tan>=0.75 e tan<1.25)	retorne 45
			se(tan>=1.25)			retorne 60
		}
		
		retorne 0
	}
	funcao logico coliTiroEntidade(inteiro i,inteiro j){
		inteiro fix = o.obter_propriedade_tipo_inteiro(j, "T")/2-o.obter_propriedade_tipo_inteiro(i, "T")/2
		
		inteiro xA = o.obter_propriedade_tipo_inteiro(i, "X"), 	yA = o.obter_propriedade_tipo_inteiro(i, "Y"),	rA = o.obter_propriedade_tipo_inteiro(i, "T")/2
		inteiro xB = o.obter_propriedade_tipo_inteiro(j, "X"), 	yB = o.obter_propriedade_tipo_inteiro(j, "Y"),	rB = o.obter_propriedade_tipo_inteiro(j, "T")/2

		se(rA<rB){
			xA -= fix
			yA -= fix
		}senao se(rA>rB){
			xB += fix
			yB += fix
		}
		retorne ((xA-xB)*(xA-xB) + (yA-yB)*(yA-yB) < (rA+rB)*(rA+rB))
	}
	funcao logico coliEntidadeNavio(inteiro i){
		/*Vai ter documentação aqui pq isso vai ser mt dificil, basicamente vamos pegar a distancia como um triangulo.
		  dx = (x de tiro - x da outra hitbox)^2 ; dy = (y de tiro - y da outra hitbox)^2 
		  se dx + dy for menor ou igual a (raio do tiro + raio do colisor)^2 houve colisao */
		inteiro fix = 32-o.obter_propriedade_tipo_inteiro(i, "T")/2
		
		inteiro xA = o.obter_propriedade_tipo_inteiro(i, "X"), yA = o.obter_propriedade_tipo_inteiro(i,"Y"),rA = o.obter_propriedade_tipo_inteiro(i,"T")/2
		inteiro xB = X, 								yB = Y,								rB = 32
		
		se(rA<rB){
			xA -= fix
			yA -= fix
		}senao se(rA>rB){
			xB += fix
			yB += fix
		}
		retorne ((xA-xB)*(xA-xB) + (yA-yB)*(yA-yB) < (rA+rB)*(rA+rB)) // << isso retorna um valor logico, para sabermos se estao colidindo.
	}
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 318; 
 * @DOBRAMENTO-CODIGO = [209, 307, 426, 454, 481, 491, 502, 512, 520, 530, 543, 564];
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */