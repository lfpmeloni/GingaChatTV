dofile("xml.lua")
dofile("handler.lua")

local client = require("socket")
local string = require("string")
local tabela = require("table")

--resp = "vazio"
tabela.qtdeMatch = 0
tabela.tabelaFind={}

function showItem(xmlhandler)
		
	xmlhandler2 = xmlhandler
	
	--passa por cada linha do arquivo obtendo os valores conforme estrutura
	--cada mensagem composta por TimeStamp, usuario e mensagem sao inseridos em uma coluna da
	--matriz
	for i=1, #xmlhandler2.root.CONVERSA.MENSAGEM do 
		tabela.tabelaFind[i] = {
			xmlhandler2.root.CONVERSA.MENSAGEM[i].TIME,
			xmlhandler2.root.CONVERSA.MENSAGEM[i].USR,
			xmlhandler2.root.CONVERSA.MENSAGEM[i].MSG,
		}
	end
	print("Quantidade de Mensagens encontradas: "..#xmlhandler2.root.CONVERSA.MENSAGEM)
end

tabela.pesquisar = function(params)
	--recebe params caso deseje fazer uma busca por algum conteúdo específico

	print ("SEARCH/begin_function")	

	-- Esse é o modo de utilzar o socket para dar um GET no XML via HTTP, 
        -- é a unica forma compatível com luaSocket 2.0.2 que roda no Astrobox, GingaPUC e Ginga.AR
	
	--cria uma conexao tcp
	local con = client.tcp()
	--define o endereco e porta para conexao
        con:connect("http://www.felipemeloni.xyz", 8080)
	if unexpected_condition then print('CONNECTION/Conection error.') end
	--con:connect("www.tv.unesp.br", 80)
	--print ("CONNECTION/connection_established")
	--requisição HTTP GET buscando o arquivo
	con:send("GET /gingachat/mensagens.txt  \n")
	--con:send("GET /arquivoxml.xml \n")
	--con:send("GET /webftp/geiza/chat/mensagens.txt  \n")
	print ("CONNECTION/get_ok")

	--a conexão irá ler linha por linha do arquivo até encontrar "nil"
	xml =" "	
	text = " "
	text = con:receive() -- primeira linha do xml(txt)
	while text ~= nil do	
		text = con:receive() 
		print("content: \n"..text)
		if(text ~= nil )then		
		xml = xml..text.."\n"
		end
	end

	--fecha a conexão
	con:close()
	--exibe no console o que foi encontrado
	print("xml \n"..xml)

	--realiza o parse da estrutura XML para valores 	
	print ("PARSER/xmlhandler_begin")

	local xmlhandler = simpleTreeHandler()
        local xmlparser = xmlParser(xmlhandler)
	
        xmlparser:parse(xml)
	
	--executa funcao definida no inicio do codigo
	showItem(xmlhandler)
		
	--print ("PARSER/xmlhandler_end")
end

return tabela
