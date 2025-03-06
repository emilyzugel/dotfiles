print("Searching for available networks...")

-- Executa o comando nmcli para listar as redes Wi-Fi disponíveis
local handle = io.popen("nmcli -t -f SSID dev wifi") -- 'io.popen' executa um comando no sistema e retorna um objeto para leitura
local networks = {} -- Cria uma tabela (array) para armazenar os nomes das redes

if handle then  -- Verifica se o comando foi executado corretamente
    for line in handle:lines() do  -- Lê cada linha da saída do comando
        if line ~= "" then  -- Ignora linhas vazias
            table.insert(networks, line) -- Adiciona o nome da rede à tabela 'networks'
        end
    end
    handle:close() -- Fecha o manipulador de comando para liberar memória
end

-- Se nenhuma rede for encontrada, exibe uma mensagem e encerra o programa
if #networks == 0 then
    print("No available network.")
    os.exit() -- Encerra o programa
end

-- Exibe a lista de redes disponíveis
print("Wi-Fi Networks Available :")
for i, ssid in ipairs(networks) do
    print(i .. ". " .. ssid) -- Mostra cada rede com um número para seleção
end

-- Solicita que o usuário escolha uma rede digitando um número
io.write("Choose the network: ")
local choice = tonumber(io.read()) -- Lê a entrada do usuário e converte para número

-- Se a escolha for inválida, exibe um erro e encerra o programa
if not choice or choice < 1 or choice > #networks then
    print("Invalid choice.")
    os.exit()
end

-- Obtém o nome da rede escolhida
local ssid = networks[choice]

-- Pede a senha da rede
io.write("Type the password for " .. ssid .. ": ")
local password = io.read() -- Lê a senha digitada pelo usuário

-- Monta o comando para conectar ao Wi-Fi usando nmcli
local command = string.format('nmcli device wifi connect "%s" password "%s"', ssid, password)

-- Executa o comando no terminal
os.execute(command)


