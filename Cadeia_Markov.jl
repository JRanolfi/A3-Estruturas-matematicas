using LinearAlgebra
# Matrizes
M = [
    0.7 0.1 0.1 0.1
    0.7 0.3 0.0 0.1
    0.0 0.9 0.1 0.1
    0.4 0.1 0.3 0.2
]

N = [
    0.8 0.05 0.15
    0.75 0.25 0.0
    0.0 0.8 0.2
]

O = [
    0.79 0.05 0.16
    0.75 0.25 0.0
    0.0 0.8 0.2
]

# Funcao para descobrir a disstribuicao estacionária das matrizes
function distribuicao_extracionaria(matriz::Matrix{Float64})
    n_estados = size(matriz, 1)
    m_identidade = Matrix(1.0I, n_estados, n_estados)
    coeficientes_sistema = matriz'- m_identidade  # Matriz transposta - a matriz identidade

    coeficientes_sistema[end, :] .= 1

    vetor_independente = zeros(n_estados)
    vetor_independente[end] = 1

    π = coeficientes_sistema \ vetor_independente
    π = round.(π*100, digits=2)
    println("\n\nDistribuicao extracionária da matriz: ")
    Base.show(stdout, MIME"text/plain"(), matriz)
    println("\n\nFuncionando: ", π[1], "%")
    println("Manutencao: ", π[2], "%")
    println("Quebrado: ", π[3], "%")
    # Usar uma condicional para quando o π[>3] e marcar como outro assim como no comentário abaixo
    # println("Outro: ", π[4], "%") # Usado para demonstrar com 4 casos de transicao.
end

# Aqui seria um exemplo de amostragem que se seuguisse a transição da matriz saberia os gastos 
function previsao_futura(matriz::Matrix{Float64}, dias::Int)
    println("\nPrevisao futura da maquina de matriz de transição:\n")
    Base.show(stdout, MIME"text/plain"(), matriz)
    n_estados = size(matriz, 1)
    estado = [1.0 0.0 0.0] # Determina o estado inicial, que ao mudar a quantidade de transicoes deve-se alterar! Colocar uma condicional para que não precise trocar manualmente. E ter um print em outros gastos.
    dias_em_cada_estado = zeros(n_estados)

    for _ in 1:dias
        dias_em_cada_estado += vec(estado)
        estado = estado * matriz
    end

    lucro_funcionamento = round(dias_em_cada_estado[1]*700, digits=2)
    prejuizo_manutencao = round(dias_em_cada_estado[2]*1000, digits=2)
    prejuizo_quebrada = round(dias_em_cada_estado[3]*1000, digits=2)
    lucro_liquido = round(lucro_funcionamento - prejuizo_manutencao - prejuizo_quebrada, digits=2)

    println("\n\nTempo esperado em cada estado após $dias dias:")
    println("Funcionando: ", round(dias_em_cada_estado[1], digits=1), " dias, lucro otido(700 para cada dia funcionando): R\$", lucro_funcionamento)
    println("Manutenção: ", round(dias_em_cada_estado[2], digits=1), " dias, prejuizo(200 para cada dia em manutenacao): R\$", prejuizo_manutencao)
    println("Quebrado: ", round(dias_em_cada_estado[3], digits=1), " dias, prejuizo(1000 para cada dia quebrado): R\$", prejuizo_quebrada)
    println("Lucro liquido do periodo, R\$", lucro_liquido)
end

distribuicao_extracionaria(N)
previsao_futura(N, 365)

# distribuicao_extracionaria(O)
# previsao_futura(O, 365)

