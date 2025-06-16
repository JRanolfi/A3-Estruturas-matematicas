using LinearAlgebra
# Matrizes
M = [
    0.7 0.1 0.1 0.1
    0.7 0.2 0.0 0.1
    0.0 0.8 0.1 0.1
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

P = [
    0.7 0.2 0.1
    0.8 0.1 0.1
    0.6 0.3 0.1
]


# Funcao para descobrir a disstribuicao estacionária das matrizes
function distribuicao_extracionaria(matriz::Matrix{Float64})
    n_estados = size(matriz, 1) # Numeros de estados de transicao
    m_identidade = Matrix(1.0I, n_estados, n_estados) # Definicao da matriz identidade
    coeficientes_sistema = matriz' - m_identidade  # Matriz transposta - a matriz identidade

    coeficientes_sistema[end, :] .= 1

    vetor_independente = zeros(n_estados)
    vetor_independente[end] = 1

    π = coeficientes_sistema \ vetor_independente
    π = round.(π * 100, digits=2)

    # Criar nomes para os estados
    nomes = String[]
    push!(nomes, "Funcionando")
    push!(nomes, "Manutenção")
    push!(nomes, "Quebrado")
    for i in 4:n_estados
        push!(nomes, "Outro $(i - 3)")
    end

    # Exibir resultados
    println("\nDistribuição estacionária para a matriz:")
    Base.show(stdout, MIME"text/plain"(), matriz)
    println("\n")

    for i in 1:n_estados
        println(rpad(nomes[i] * ":", 15), round(π[i]; digits=2), "%")
    end

    return π
end

# Aqui seria um exemplo de amostragem que se seuguisse a transição da matriz saberia os gastos 
function previsao_futura(matriz::Matrix{Float64}, dias::Int)
    println("\nPrevisao futura da maquina de matriz de transição:\n")
    Base.show(stdout, MIME"text/plain"(), matriz)
    n_estados = size(matriz, 1)
    estado = [1.0; zeros(n_estados-1)]'
    dias_em_cada_estado = zeros(n_estados)

    for _ in 1:dias
        dias_em_cada_estado += vec(estado)
        estado = estado * matriz
    end

    lucro_funcionamento = round(dias_em_cada_estado[1] * 700, digits=2)
    prejuizo_manutencao = round(dias_em_cada_estado[2] * 1000, digits=2)
    prejuizo_quebrada = round(dias_em_cada_estado[3] * 1000, digits=2)
    lucro_liquido = round(lucro_funcionamento - prejuizo_manutencao - prejuizo_quebrada, digits=2)

    prejuizo_outros = 0.0
    for i in 4:length(dias_em_cada_estado)
        prejuizo = round(dias_em_cada_estado[i] * 1000, digits=2)
        prejuizo_outros += prejuizo
    end

    println("\n\nLucro obtido por funcionamento: R\$", lucro_funcionamento)
    println("Prejuízo por manutenção: R\$", prejuizo_manutencao)
    println("Prejuízo por quebra: R\$", prejuizo_quebrada)
    if length(dias_em_cada_estado) > 3
        println("Prejuízo por outros estados: R\$", prejuizo_outros)
    end
    println("Lucro líquido no período: R\$", lucro_liquido)
end

distribuicao_extracionaria(M)
previsao_futura(M, 365)

# distribuicao_extracionaria(O)
# previsao_futura(O, 365)

