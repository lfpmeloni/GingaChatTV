-- ===================================
--utilizar ncl para delimitar a area da tela a ser utilizada (20% superior p.e.)
-- ===================================

local busca = require ( "busca" )

--Matriz vazia
tabela = {}          -- create the matrix
for i=1,7 do
    tabela[i] = {}     -- create a new row
    for j=1,7 do
       tabela[i][j] = " "
    end
end

qtde = 1
index = qtde

function changeTime(timeStamp)

end


--Utilizado para limpar o fundo
function drawBackGround()
	canvas:attrColor (125,125,125,125) --cinza com transparencia
	canvas:drawRect('fill', 0,0, 2000, 200)
	canvas:flush()
	drawMensagem(index)
end

--Utilizado para desenhar as mensagens
function drawMensagem(i)
	--Define a fonte e tamanho utilizado
	canvas:attrFont('Tiresias',26)

	print("DRAWMENSAGEM/Imprimindo registro "..i.." de "..qtde)
	--print(tabela[i][1])
	canvas:attrColor (255,204,0,0)
	canvas:drawText(10,30,tabela[i][1])
	--print(tabela[i][2])

	canvas:attrFont('Tiresias',26,'bold')

	canvas:attrColor (102,255,0,0)
	canvas:drawText(330,30,tabela[i][2])
	--print(tabela[i][3])
	canvas:attrColor ('white')
	canvas:drawText(10,60,tabela[i][3])

	canvas:flush()
end

--Funcao para quando chega novas mensagens para exibir sempre a mais atual
update = function()
	--obtem o tamanho da tabela
	qtde = #busca.tabelaFind
	--atualiza qual mensagem sera exibida
	index = qtde
	--armazena os valores em uma variavel para ser utilizado no print de mensagens
	tabela = busca.tabelaFind
	--joga valores nulos para as variaveis antigas
	busca.qtdeMatch = 0
	busca.tabelaFind = {}
	--desenha o fundo cinza
	drawBackGround()
	return nil	
end

--faz a busca e verifica se teve nova mensagem
function atualizar ()
	while 0 < 1 do
		busca.pesquisar(" ")
		if #busca.tabelaFind > qtde then
			update()
		end
		coroutine.yield()
	end
end

print("COROUTINE/create")
coAtualizar = coroutine.create(atualizar)

--funcao recorrente para busca
function refresh()
	print("COROUTINE/resume")
	--resume a corotina de atualizar as mensagens (busca na internet)
	coroutine.resume(coAtualizar)
	--a cada t (milisegundos) realiza a funcao novamente
	event.timer(2500, refresh)
end


--Define o tratamento de enventos NCLua
function tratador (evt)
	--No inicio do programa executa a funcao
	if evt.action == 'start' then
		print("EVT.ACTION/start of aplication")
		refresh()
	end	
end
event.register(tratador, 'ncl', 'presentation')


--Define o tratamento de eventos do tipo apertar um botao
function press(evt)
	if evt.type == 'press' then
	--print(evt.key)
		if evt.key=='CURSOR_UP' then
		--altera o posicionamento vertical
		--index de qual mensagem sendo exibida
			if index>1 then
				index=index-1
				drawBackGround()
			end
		elseif evt.key=='CURSOR_DOWN' then
			if index<qtde then
				index=index+1
				drawBackGround()
			end
		elseif evt.key=='CURSOR_LEFT' then

		elseif evt.key=='CURSOR_RIGHT' then

		elseif evt.key=='ENTER' then
			refresh()
		elseif evt.key=='BACK' then
		--nao funciona, trava o programa
		elseif evt.key=='RED' then
			refresh()
		elseif evt.key=='GREEN' then

		elseif evt.key=='YELLOW' then

		elseif evt.key=='BLUE' then
		
		end
	end
end

event.register(press,'key')
