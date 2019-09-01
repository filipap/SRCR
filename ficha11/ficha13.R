# instalar pacote "neuralnet" caso ainda não esteja instalado
# install.packages(neuralnet)
library(neuralnet)

# ler dataset de treino de um CSV, separado por "," e casa decimal representada por "."
dados <- read.csv("C:\\Users\\Filipa Parente\\Desktop\\SRCR\\creditset\\creditset.csv")

# definição da formula de treino
formulaRNA <- clientid ~ income+age+loan+LTI+default10yr
h <- head(formulaRNA)

# treinar rede neuronal chamada "creditnet" com 5 nodos intermédios
creditnet <- neuralnet(formulaRNA, h, hidden = c(5), threshold = 0.1)
creditnet <- neuralnet(formulaRNA, h, hidden = c(6,4,2), lifesign = "full", threshold = 0.01)


# imprimir resultados
print(creditnet)
print(creditnet$call)
# ...
creditnet$model.list


# desenhar rede neuronal
plot(creditnet)
matplot(creditnet$covariate[,1],creditnet$response,type="o")
matplot(creditnet$covariate[,1],creditnet$response,type="p")

# criar dataframe para os casos de teste
test <- data.frame(income=1000000,age=45,loan=8000,LTI=0.12,default10yr=1)
# test[2,] <- data.frame(Vencimento=0.7,Habitacao=0.4,Automovel=0.55,Cartao=0.1)

# testar novos casos na rede neuronal
creditnet.results <- compute(creditnet, test)

# imprimir o resultado final (uso da função round como auxiliar para arredondar o resultado final)
print(round(creditnet.results$net.result))
print(round(creditnet.results$net.result,digits=1))

# testar a RNA com os casos usados para treino
teste <- subset(trainset, select = c("Vencimento","Habitacao","Automovel","Cartao"))
creditnet.results <- compute(creditnet, teste)
print(round(creditnet.results$net.result,digits=0))