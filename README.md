
## Terraform Curso

Este documento faz parte do Guia prático do Curso de Desenvolvimento de Infraestrutura com Terraform.
O curso tem como objetivo mostrar para profissionais de Tecnologia da informação como a infraestrutura como código é útil e necessário atualmente e como o **Terraform** se tornou a principal ferramenta para provisionamento de ambientes. 

### Sumário

1. [Criando Ambiente](#ambiente)\
     1.1.  [Ferramentas para desenvolvimento](#ide)\
     1.2.  [Estrutura de Arquivos](#estrutura-arquivos)
2. [Módulo Básico](#basico)\
	2.1. [Providers - Provedores](#providers)\
	2.2. [Resources - Recursos](#resources)\
	2.3. [Comando - terraform init](#terraform-init)\
	2.4. [Comando - terraform plan](#terraform-plan)\
	2.5. [Comando - terraform apply](#terraform-apply)   
    2.6. [Comando - terraform destroy](#terraform-destroy)\
	2.7. [Comando - terraform validate](#terraform-validate) \
	2.8. [Comando - terraform fmt](#terraform-fmt)\
	2.9. [Comando - terraform graph](#terraform-graph)\
	2.10. [Comando - terraform import](#terraform-import)\
	2.11. [Comando - terraform console](#terraform-console)\
	2.12. [Comando - terraform graph](#terraform-graph)\
	2.13. [Comando - terraform import](#terraform-import)\
	2.14. [Comando - terraform console](#terraform-console)\
	2.15. [Variáveis de Entrada (Input)](#terraform-input)\
	2.16. [Variáveis de Saída (Output)](#terraform-output)\
	2.17. [Dependências explicitas](#dependencias-explicitas)\
	2.18. [Data Sources](#data-sources)
3. [Módulo Intermediário](#intermediario)\
	3.1. [Módulos locais](#modulos-locais)\
	3.2. [Módulos remotos](#modulos-remotos)\
	3.3. [Remote State](#state)\
	3.4. [Workspaces](#workspaces)\
	3.5. [Funções e tipos de variáveis](#-funcoes-variaveis)\
	3.6. [Terraform Backend](#backend)\
	3.7. [Terraform Cloud (Introdução)](#terraform-cloud)
	
***
### Criando Ambiente <a name="ambiente"></a>

Prepare seu ambiente para iniciar o desenvolvimento da sua infraestrutura utilizando Terraform.

#### IDE's - Ferramentas para desenvolvimento <a name="ide"></a>

- PyCharm
[https://www.jetbrains.com/pycharm/download](https://www.jetbrains.com/pycharm/download)
Plugins: HCL language support

- VSCode
[https://code.visualstudio.com/](https://code.visualstudio.com/)
Plugins: HashiCorp Terraform


####  Estrutura de Arquivos <a name="estrutura-arquivos"></a>

O desenvolvimento de infraestruturas utilizando **Terraform** pode ser realizada utilizado a organização de arquivos de várias formas, mas quando se trabalha com ambiente que serão colocados em produção e compartilhados com todo o time utilizar o padrão é utilizar uma estrutura baseada em subdiretórios.

**Exemplo Ambiente Único**
```
├── document-metadata
│   └── main.tf
├── document-translate
│   └── main.tf
└── modules
    ├── function
    │   ├── main.tf      // contains aws_iam_role, aws_lambda_function
    │   ├── outputs.tf
    │   └── variables.tf
    ├── queue
    │   ├── main.tf      // contains aws_sqs_queue
    │   ├── outputs.tf
    │   └── variables.tf
    └── vnet
        ├── main.tf      // contains aws_vpc, aws_subnet
        ├── outputs.tf
        └── variables.tf
```

**Exemplo Multi Ambiente**
```
├── modules
├── prod
│   ├── document-metadata
│   │   └── main.tf
│   └── document-translate
│       └── main.tf
└── staging
    ├── document-metadata
    │   └── main.tf
    └── document-translate
        └── main.tf
```
Organizar a estrutura arquivos do **Terraform** em módulos e separar vários ambientes em pastas distintas, é possível obter um isolamento de estado entre os ambientes e a reutilizamos dos módulos apenas quando necessário. Ainda é possível facilmente consumir e compartilhar os módulos com o Terraform Registry ou o Terraform Cloud Private Module Registry. 

[https://www.hashicorp.com/blog/structuring-hashicorp-terraform-configuration-for-production/](https://www.hashicorp.com/blog/structuring-hashicorp-terraform-configuration-for-production/)

***
##  Módulo básico <a name="basico"></a>
Conhecer os comandos e os principais elementos utilizados no **Terraform** é fundamental para gerenciar infraestruturas como código de forma eficiente.

###  Providers - Provedores <a name="providers"></a>
Os provedores são os responsáveis por receber as instruções enviadas pelo **Terraform core** e manipular os recursos de acordo com o que foi escrito em código pelo desenvolvedor, quando configuramos um provider em nosso código uma chamada de API (**_Application Programming_** **Interface**) é realizada diretamente com o provedor ou seja uma ponte segura entre o seu código e a sua conta no provedor.

[https://www.terraform.io/docs/providers/index.html](https://www.terraform.io/docs/providers/index.html)

###  Resources - Recursos <a name="resources"></a>

Os recursos são utilizados pelo **Terraform** para manipular e interagir com os recursos da nuvem escolhida para provisionamento conforme provider configurado.
Para criação de cada recurso é necessário saber as opções que estão disponíveis em cada provedor o que pode ser consultado na documentação oficial do **Terraform**.
[https://registry.terraform.io/providers/hashicorp/aws/latest/docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

###  Comando Terraform init <a name="terraform-init"></a>

O comando `terraform init`é utilizado para a inicializar um ambiente de trabalho do **Terraform** , nele é possível baixar módulos e plugins descritos no código criado e faz parte do comando inicial do fluxo de trabalho do **Terraform** 

**Exemplo:**

* Crie um arquivo chamado "main.tf"
 Crie um provedor aws neste arquivo utilizando o código abaixo:

```hcl
 provider "aws" {
   version = "~> 3.0"
   region  = "us-east-1"
 }
```
Agora no terminal acesse a pasta onde está localizado o arquivo e execute o comando `terraform init`.

>**Observe que o plugin do provider será baixado localmente no computador**

Consulte mais informações no site do **Terraform**
[https://www.terraform.io/docs/commands/init.html](https://www.terraform.io/docs/commands/init.html)

###  Comando Terraform plan <a name="terraform-plan"></a>
O comando `terraform plan`é utilizado para criar um plano de execução onde ele irá mostrar os passos necessários para atingir o estado do recurso a ser criado e quais as ações será necessário para isso.

**Exemplo:**

* Ainda no arquivo `main.tf`
 Vamos criar uma EC2 utilizando o código abaixo:

```hcl
resource "aws_instance" "instancia-curso" {
  ami 		    = "ami-2757f631"
  instance_type = "t2.micro"
}
```
Agora no terminal acesse a pasta onde está localizado o arquivo e execute o comando `terraform plan`.

No final do arquivo a linha `Plan: 1 to add, 0 to change, 0 to destroy.` mostra que o **Terraform** ira adicionar um recurso.

> **Observe que o Terraform irá se conectar ao provedor declarado em código e verificar o que será necessário para criar o recurso e quais as configurações aplicará por padrão**

###  Comando terraform apply <a name="terraform-apply"></a>

O comando `terraform apply` é utilizado para aplicar as alterações necessárias na infraestrutura para atingir o estado desejado de um conjunto de ações geradas que podem ser observadas no `terraform plan`. 

O comando **apply** verifica as configurações no diretório principal e as aplica no provedor, é possível realizar a aplicação das alterações de forma automática passando alguns parâmetros ao comando, mas primeiramente deve-se estar familiarizado com o uso antes de realizar as automações em produção o que veremos mais a frente.

**Exemplo:**

* Ainda utilizando o arquivo `main.tf`
Agora que já realizamos a inicialização e o plano de execução do **Terraform** vamos aplicar nossa infraestrutura no provedor.
Antes de aplicar será necessário gerar as chaves de autenticação da sua api na AWS, ou utilizar seu profile gerado após o comando `aws configure` .

[https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/id_credentials_access-keys.html](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/id_credentials_access-keys.html)
[https://docs.aws.amazon.com/pt_br/cli/latest/userguide/cli-configure-files.html](https://docs.aws.amazon.com/pt_br/cli/latest/userguide/cli-configure-files.html)

```hcl
provider "aws" {
  version =  "~> 3.0"
  region  = "us-east-1"
  profile =  "default"
}

resource "aws_instance" "instancia-curso" {
  ami 		    = "ami-2757f631"
  instance_type = "t2.micro"
}
```

Agora com as chaves geradas aplique as configurações a partir do mesmo diretório que o arquivo `main.tf` está localizado execute o comando `terraform apply`observe que o **Terraform** irá solicitar aprovação para continuar o processo e o mesmo ainda executa um plano de execução antes sendo possível visualizar novamente o que será alterado ou aplicado no provedor.
Consulte a documentação oficial para obter mais detalhes das opções do comando.
[https://www.terraform.io/docs/commands/apply.html](https://www.terraform.io/docs/commands/apply.html)

###  Comando terraform destroy <a name="terraform-destroy"></a>
Para remover ou deletar as alterações realizadas na sua infraestrutura você pode utilizar o comando `terraform destroy`que é responsável por destruir a infraestrutura criada com **Terraform**.

> O comando **terraform destroy** não deve ser utilizado para alterar ou remover recursos do provedor apenas toda a infraestrutura criada com **Terraform** para alterações ou exclusão de recursos deve-se utilizar o comando **terraform apply**.

**Exemplo:**
Agora vamos destruir tudo que aplicamos até o momento em nossa infraestrutura.
ainda na raiz do projeto onde temos o arquivo `main.tf`execute o comando `terraform destroy`. Observe que o comando irá solicitar confirmação antes de prosseguir.

Para saber mais sobre o comando consulte a documentação:
[https://www.terraform.io/docs/commands/destroy.html](https://www.terraform.io/docs/commands/destroy.html)

###  Comando terraform validate <a name="terraform-validate"></a>

O comando `terraform validate` valida os arquivos de configuração em um diretório, ele valida apenas as configurações não realiza nenhuma alteração ou chamadas das APIs do provider.
Este comando é útil para você validar se o desenvolvimento está correto, após salvar um trecho de código.

No diretório do que contem o arquivo `main.tf`copie o trecho de código abaixo:

```hcl
provider "aws" {
  version = "~> 3.0"
  region = "us-east-1"
  profile = "default"
}

resource "aws_insta" "instancia-curso" {
  ami = "ami-2757f631"
  instance_type = "t2.micro"
}
```

Você deverá receber o erro abaixo:
`Error: Invalid resource type`

Realize a correção no nome do tipo do resource (`"aws_insta" -> "aws_instance"`) e execute novamente e agora a sua saída é com sucesso:
`Success! The configuration is valid.`

> O comando `validate`é de extrema importancia quando se trabalha com automação no **Terraform** pois ele evita que códigos com erro sejá mergeado no trunk principal evitando erros no seu pipeline.

Consulte a documentação oficial no site do **Terraform** para saber mais.
[https://www.terraform.io/docs/commands/validate.html](https://www.terraform.io/docs/commands/validate.html)


###  Comando terraform fmt <a name="terraform-fmt"></a>

O comando `terraform fmt` é utilizado para realizar ajuste na formatação e estilo dos arquivos do **Terraform**.
A formatação de estilos do **Terraform** faz parte da conversão de estilos “Style Convention” que mantem os espaçamentos e tabulações do arquivo de acordo com as melhores praticas da linguagem, por mais que pareça desnecessário esta opção é muito importante para manter seu código legível e organizado além de ser cobrado no Exame Terraform Associete.

**Exemplo:**
Copie o código abaixo no seu arquivo `main.tf`:

```hcl
// Arquivo sem formatação
provider "aws"  {
version =  "~> 3.0"
 region= "us-east-1"
  profile =  "default"
}

resource "aws_instance"  "instancia-curso" {
 ami =  "ami-2757f631"
   instance_type = "t2.micro"
}
```

Agora execute o comando `terraform fmt` a saída deverá ser conforme o trecho de código abaixo:
`main.tf` e o seu arquivo será formatado automaticamente.

```hcl
// Arquivo formatado

provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
  profile = "default"
}

resource "aws_instance" "instancia-curso" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}
```
Observe que o espaçamento do trecho acima foi ajustado para manter o padrão.
Consulte a documentação do **Terraform** para saber mais sobre Style Convetion.
[https://www.terraform.io/docs/configuration/style.html](https://www.terraform.io/docs/configuration/style.html)

###  Comando terraform graph<a name="terraform-graph"></a>

O comando `terraform graph` é utilizado para criar uma representação visual das configurações do **Terraform**, este comando é útil para deixar documentado o plano de configurações desenvolvidos com Terraform.

A saída dos gráficos é gerada usando o comando `DOT` e pode ser convertido utilizando GraphViz um software utilizado para a criação de gráficos.
Mais informações sobre o software podem ser consultadas utilizando o link abaixo:

https://graphviz.org/

**Exemplo:**\
Com o arquivo `main.tf` configurado execute o comando

`terraform graph | dot -Tsvg > graph.svg` 

Observe que o arquivo `graph.svg` será criado na raiz do seu projeto no formato `*.svg` que pode ser aberto diretamente no Browser. 

<img src="assests/graph_1.svg"  
alt="Graph"  
style="float: left; margin-right: 10px;" />

**Para maiores informações consulte o site do Terraform:**
[https://www.terraform.io/docs/commands/graph.html](https://www.terraform.io/docs/commands/graph.html)

###  Comando terraform import<a name="terraform-output"></a>
O comando `terraform import` devemos utilizar quando precisamos que um recurso provisionado com outras ferramentas ou de forma manual seja gerenciado através do **Terraform**  ou seja importar um recurso já existente.

**Exemplo**
`terraform import aws_vpc.vpc-curso vpc-d772d0ad`

No exemplo acima estamos realizando a importação de uma VPC já criada no ambiente AWS.

`terraform import` - Comando principal do Terraform
`aws_vpc` - O tipo do recurso a ser importado no caso VPC
`.vpc-curso`- O nome que estamos dando para o recurso em nosso código Terraform
`vpc-d772d0ad`- O ID do recurso na AWS

Quando o comando é executado sem você criar o trecho no código você receberá um retorno no terminal conforme abaixo:

```ssh
Error: resource address "aws_vpc.vpc-curso" does not exist in the configuration.
Before importing this resource, please create its configuration in the root module. For example:

resource "aws_vpc" "vpc-curso" {
  # (resource arguments)
}
```
Observe que antes de importar o recurso você deve criar o trecho no seu código no arquivo `main.tf`para que o **Terraform** saiba onde endereçar e marcar no `tfstate`
Insira no arquivo `main.tf` o trecho conforme instruções fornecidas pelo Terraform.

```hcl
resource "aws_vpc" "vpc-curso" {

}
```
Agora execute novamente o comando: 
`terraform import aws_vpc.vpc-curso vpc-d772d0ad`
> Lembre-se de alterar o ID deste documento pelo ID da VPC da sua conta.

Você ira receber uma mensagem que o recurso foi importado com sucesso, agora todas as alterações podem ser feitas utilizando o **Terraform**.

```ssh
> terraform import aws_vpc.vpc-curso vpc-d772d0ad
aws_vpc.vpc-curso: Importing from ID "vpc-d772d0ad"...
aws_vpc.vpc-curso: Import prepared!
  Prepared aws_vpc for import
aws_vpc.vpc-curso: Refreshing state... [id=vpc-d772d0ad]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```

> A importação de recursos requer uma atenção especial em ambientes produtivos, uma vez que alguns valores são obrigatórios na hora da alteração. Na VPC por exemplo ao tentar incluir apenas uma nova TAG o trecho "cidr_block" deverá ser fornecido, insira o mesmo valor já configurado pois uma valor diferente do que já existe no recurso o **Terraform** irá alterar o seu bloco de IPs e você pode deixar toda sua infraestrutura indisponível.

###  Comando terraform console<a name="terraform-output"></a>
O comando `terraform console` oferece um terminal interativo para que validações de expressões e até mesmo consulta de recursos escritos no seu código seja validado ou consultado.

**Exemplo:**

Digite no terminal o comando abaixo:
```ssh
$ terraform console
> 
```
com isto você estará dentro do terminal interativo pronto para validar expressões funções outras consultas extremamente uteis.

Vamos validar o uso de algumas funções básicas.

Função `upper` assim como padrão da maioria das linguagens troca os valores passados para maiúsculo.

```ssh
> upper("Bem Vindo ao Curso de Terraform")
BEM VINDO AO CURSO DE TERRAFORM
```
Função `list` esta função lista valores separados por `virgula`.

```ssh
> list("Bem Vindo", "Curso", "Terraform")
[
  "Bem Vindo",
  "Curso",
  "Terraform",
]
```
Função `length` informa a quantidade de valores em uma lista.
```ssh
> length(list("Bem Vindo", "Curso", "Terraform"))
3
```
Função `lookup` retorna o valor do elemento solicitado assim como em um array.
```
> lookup(map("id", "10","Curso", "Terraform" ), "Curso")
Terraform
```
Para saber mais sobre as funções que podem ser usadas no **Terraform** e sobre o comando `terraform console`consulte os links abaixo:

[https://www.terraform.io/docs/configuration/functions/](https://www.terraform.io/docs/configuration/functions/)
[https://www.terraform.io/docs/commands/console.html](https://www.terraform.io/docs/commands/console.html)

###  Variáveis de Entrada (Input)<a name="terraform-input"></a>
As variáveis de entrada são parâmetros passados para nossos módulos no **Terraform** sem a necessidade de alterar o código fonte, isso permite que valores sejam alterados com segurança e permite que seja compartilhado com um ou mais módulos.

Primeiramente deve-se definir as variáveis, para isso crie um arquivo na raiz do seu projeto chamado `variables.tf`.
Vamos definir as variáveis ao nosso arquivo `main.tf`.

**trecho do arquivo `main.tf`**
```hcl
provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
  profile = "default"
}
...
```
Vamos definir uma variável para nossa região, no arquivo `variables.tf` inclua o trecho abaixo:

**trecho do arquivo `variable.tf`**
```hcl
variable "region" {
  default = "us-east-1"
}
```
Agora com a nossa variável já definida e vamos usa-la em uma configuração no arquivo `main.tf`

**usando nossa variável no arquivo `main.tf`**
```hcl
provider "aws" {
  version = "~> 3.0"
  region  = var.region
  profile = "default"
}
...
```
O uso de variáveis de entrada no **Terraform** dar-se-a de varias formas a mais simples e fácil de encontrar são as mostradas acima, porem você pode inserir variáveis também via linha de comando que devem ser passadas juntamente com os comandos `terraform plan`, `terraform apply` para passar as variáveis durante o uso dos comandos citados devera ser utilizado conforme mostrado abaixo:

```shell-session
terraform apply -var 'region=us-east-1'
```
Neste caso o comando ira priorizar o valor passado `variables.tf` e mesmo assim a variável deverá existir no arquivo.

Um outra forma de atribuir valores as variáveis é utilizando arquivos com a extensão `*.tfvars`  O **Terraform** carrega automaticamente todos os arquivos no diretório atual se tiver o nome  `terraform.tfvars`ou qualquer variação `*.auto.tfvars`. Se o arquivo tiver outro nome, você pode usar-lo com o parâmetro `-var-files=terraform.tfvars` ou especificar um nome de arquivo.
É possível passar vários arquivos utilizando o parâmetro `-var-files` conforme exemplo abaixo:

```shell-session
terraform apply -var-file="pass.tfvars" -var-file="prod.tfvars"
```
Outra forma de utilizar variáveis de entrada com **Terraform** são as variáveis de ambiente, é possível ler essas variáveis quando inseridas diretamente no sistema porem essa variável deve seguir alguns requisitos. 
Para definir a região diretamente na variável do sistema para ser utilizado pelo **Terraform** você precisará passar a variável utilizando a estrutura seguinte `TF_VAR_region` assim você definiu o valor **region** a ser utilizado pelo **Terraform** diretamente no Shell do seu sistema operacional, veja abaixo um exemplo completo:

```ssh
export TF_VAR_region=us-east-1
export TF_VAR_name=curso-terraform
```
Ao criar suas variáveis de entrada precisamos ficar atentos para não utilizar alguns nomes reservados conforme a lista abaixo:

- source
- version
- providers
- count
- for_each
- lifecycle
- depends_on
- locals

Esses nomes são reservados para argumentos em blocos de configuração dos módulo e não podem ser declarados como nomes de variáveis.

> Se você definir uma variável em seu código e o valor não estiver especificado em nenhum dos métodos mostrados acima o **Terraform** ira solicitar do usuário que o valor seja atribulado manualmente, mas para isso ela sempre deverá esta declarada no arquivo `variables.tf`.

Para saber mais sobre as variáveis de entrada consulta a documentação oficial:
[https://www.terraform.io/docs/configuration/variables.html](https://www.terraform.io/docs/configuration/variables.html)

###  Variáveis de Saída (Output)<a name="terraform-output"></a>
As variáveis de saída no **Terraform** são de extrema importância pois é com ela que você poderá utilizar o valor de um recurso criado em um módulo em outros módulos, exemplo pratico é se você criar um módulo de security groups e precisar usar nas suas instancias você precisará de uma variável de saída pra fazer isso.

**Exemplo:**
```hcl
resource "aws_vpc" "vpc-curso" {
  cidr_block = "172.31.0.0/16"
}
```
Caso precisarmos usar o ID da nossa VPC em outro recurso ou módulo você precisa definir uma variável de saída para ela usando o exemplo abaixo criando um arquivo chamado `output.tf`:

```hcl
output "vpc_id_vpc-curso" {
  value = aws_vpc.vpc-curso.id
}
```
Agora vamos realizar um teste se a nossa variável de saída esta retornando o ID da nossa VPC.

**Step by Step:**

`main.tf`
```hcl
provider "aws" {
  version = "~> 3.0"
  region  = var.region
  profile = "default"
}

resource "aws_instance" "instancia-curso" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}

resource "aws_vpc" "vpc-curso" {
  cidr_block  =  "172.31.0.0/16"
}
```
`output.tf`

```hcl
output "vpc_id_vpc-curso" {
  value = aws_vpc.vpc-curso.id
}
```

> Execute o comando `terraform refresh` 
```ssh
$ terraform refresh
aws_vpc.vpc-curso: Refreshing state... [id=vpc-d772d0ad]

Outputs:

vpc_id_vpc-curso = vpc-d772d0ad
```
> Observe que na saída do comando ele já identificou o nosso output como sendo a única coisa a ser sincronizada.

Você pode executar também o comando `terraform output` para listar suas variáveis de saída disponível.
```ssh
$ terraform output
vpc_id_vpc-curso = vpc-d772d0ad
```
Para saber mais sobre os outpus do **Terraform** consulte a documentação:
[https://www.terraform.io/docs/configuration/outputs.html](https://www.terraform.io/docs/configuration/outputs.html)


###  Dependências explicitas<a name="dependencias-explicitas"></a>

As dependências explicitas do **Terraform** são aquelas que você precisa declarar no seu código que ela ira existir, pois se você não declarar o **Terraform** ira executar a criação de recursos de forma paralela sem a necessidade de declararmos e podemos chama-las de dependências implícitas.

> #### Exemplos com implícito e explícito
>-   A informação está implícita, tem que ser interpretada.
>-   A informação está explícita, só não entende quem não quer.


**Exemplo:** 
Ainda no arquivo `main.tf`vamos criar novos recursos e declarar um dependência explicita conforme trecho do código abaixo:

Primeiro acrescente o recurso `aws_bucket" "bucket-curso"`.

```hcl
provider "aws" {
  version = "~> 3.0"
  region  = var.region
  profile = "default"
}

resource "aws_instance" "instancia-curso" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
  depends_on =  [aws_s3_bucket.bucket-curso]
}

resource "aws_vpc" "vpc-curso" {
  cidr_block  =  "172.31.0.0/16"
}

resource "aws_s3_bucket" "bucket-curso" {
  bucket = "curso-terraform"
  acl    = "private"
}
```
> Observe que agora a nossa instância depende explicitamente do recurso `"aws_s3_bucket" "bucket-curso"`.

Para saber mais sobre dependências no **Terraform** consulta a documentação oficial:
[https://www.terraform.io/docs/configuration/resources.html#depends_on-explicit-resource-dependencies](https://www.terraform.io/docs/configuration/resources.html#depends_on-explicit-resource-dependencies)

taorcsaamedatasorces/a uso de Fonte de Dados (Data Source) no **Terraform** é importante para buscar dados de outras fontes utilizando diversos parâmetros como filtros em uma query. Os `data sources`não são responsáveis por criar nenhum recurso na estrutura do **Terraform** e sim fornecer os dados a ser utilizados nos recursos criados em seu código.

**Exemplo:**
No exemplo abaixo vamos buscar uma imagem ami da aws especifica utilizando o data source.

```hcl
data "aws_ami" "curso_terraform" {
  most_recent = true
  filter {
    name   = "state"
    values = ["available"]
  }
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }
}
```

Agora vamos validar qual será o ID da imagem que este data source ira retornar.

**Step by Step**

- Execute o comando `terraform console` teste a chamada do data source:
 ```ssh
> data.aws_ami.curso_terraform.id
ami-09d8b5222f2b93bf0
 ```
- Agora para utilizar em nosso recurso EC2 a imagem retornada no data source utilize o código abaixo:
 ```hcl
resource "aws_instance" "curso-terraform-data-source" {
  ami           = data.aws_ami.curso_terraform.id
  instance_type = "t1.micro"
}
```  

> Existem outras formas de utilizar um data source como declarar arquivos e outros tipos de fonte de dados, conforme você for avançando no uso do **Terraform** com certeza você vai precisar utilizar os DataSources como meio para definir suas imagens e outros recursos:

Para saber mais consulte a Documentação Oficial do **Terraform**
[https://www.terraform.io/docs/configuration/data-sources.html](https://www.terraform.io/docs/configuration/data-sources.html)

**Conclusão do módulo básico:**
Para avançar no curso, você precisará da base acima que é o inicio de uso do **Terraform** agora nos próximos módulos vamos entrar em aulas um pouco mais complexas, por isso o básico aqui mostrado é essencial para avançar:

##  Módulo Intermediário <a name="intermediario"></a>

### Módulos do Terraform
Agora que já possuímos os conhecimentos básicos sobre o **Terraform** é hora de avançarmos e aprender praticas para estruturar melhor nossos códigos e tirar proveito de funcionalidades que nos dará agilidade e resiliência alem de aprender a manter nossos códigos limpos e reaproveita-los.
Ao utilizar o **Terraform** para gerenciar a sua infraestrutura você criará configurações cada vez mais complexas. Não existe um limite para criar todo seu código em um único arquivo ou diretório, mas com certeza você ira enfrentar diversos problemas para identificar erros e as chances de duplicidade de código é maior e para ajudar a solucionar este problema o **Terraform** permite a modularizar os recursos o que facilita o que codificação uma vez que você ira trabalhar recursos de forma isolada. 
Trabalhar com módulos no **Terraform** traz diversos benefícios como (Reutilização, compartilhamento entre times) abaixo podemos ver como a própria Hashicorp descreve para que server os módulos e os problemas que eles ajudam a resolver.

>O **Encapsulamento** serve para controlar o acesso aos atributos e métodos de uma classe. É uma forma eficiente de proteger os dados manipulados dentro da classe, além de determinar onde esta classe poderá ser manipulada.

>**Organizar as configurações**: Os módulos tornam mais fácil navegar, entender e atualizar as configurações e mantem as partes relacionadas de recursos e de sua configuração juntas. Mesmo uma infraestrutura de complexidade média pode exigir centenas ou milhares de linhas de configuração para ser implementada. Usando módulos, você pode organizar suas configurações em componentes lógicos.
>**Encapsular configurações**: Outro benefício de usar módulos é encapsular a configuração em componentes lógicos distintos. O encapsulamento pode ajudar a evitar consequências indesejadas, como uma alteração indesejada em uma infraestrutura errada, e reduz as chances de erros simples, como usar o mesmo nome para dois recursos diferentes.
>**Reutilizar configurações** - Gravar todas as configurações do zero pode ser demorado e sujeito a erros. O uso de módulos pode economizar tempo e reduzir erros, reutilizar configurações escritas por você ou outros membros de sua equipe até mesmo outros profissionais que publicaram módulos para você usar. Você também pode compartilhar módulos que escreveu com sua equipe ou o público em geral, dando a eles o benefício de seu trabalho árduo.

>*O texto acima possui ajustes para melhor compreensão em português. Consulte o site Oficial do **Terraform** para visualizar o texto original*. -  [Tutorial Módulos Terraform](https://learn.hashicorp.com/tutorials/terraform/module) 

###  Módulos Locais<a name="data-sources"></a>
O **Terraform** por padrão já possui um módulo chamado de módulo raiz, mas agora vamos aprender como criar nossos próprios módulos.
Ainda utilizando a estrutura inicial do curso agora você precisará de uma estrutura para os módulos locais. Então crie uma pasta chamada `modules`  e dentro desta pasta crie mais 3 pastas sendo com os nomes, `EC2, VPC, S3` e caso tenha duvidas sobre estrutura de pastas do **Terraform** consulta a secção   [Estrutura de Arquivos](#estrutura-arquivos) .

Para este exercício devemos ter uma estrutura conforme abaixo:
```
├── main.tf
├── variables.tf
├── output.tf
├── terraform.tfvars
└── modules
    ├── EC2
    │   ├── main.tf     
    │   ├── outputs.tf
    │   └── variables.tf
    ├── S3
    │   ├── main.tf     
    │   ├── outputs.tf
    │   └── variables.tf
    └── VPC
        ├── main.tf      
        ├── outputs.tf
        └── variables.tf

```
>Observe que por padrão precisamos dos 3 arquivos principais para compor um módulo no **Terraform** `main.tf, variables.tf. output.tf`.

**Módulo EC2**
O primeiro módulo que vamos criar será o módulo EC2, então acesse o arquivo `main.tf`na pasta e crie a estrutura abaixo:

```hcl
data "aws_ami" "curso_terraform" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }
}

resource "aws_instance" "curso-terraform-data-source" {
  ami           = data.aws_ami.curso_terraform.id
  instance_type = var.instance_type
}
```
No arquivo `variables.tf`vamos criar uma variável para passar o tipo da instancia a ser usado conforme código abaixo:
```hcl
variable "instance_type" {
    description = "Tipo da Instancia"
    default = "t1.micro"
}
```

**Módulo VPC**
Agora vamos criar um módulo para nossa VPC, então na pasta do módulo vamos criar o código abaixo:

```hcl
resource "aws_vpc" "main" {
  cidr_block = var.cidr
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet1
}
```
>Observe que agora criar uma Subnet para nossa VPC

No arquivo `variables.tf` cria as variáveis conforme código abaixo:

```hcl
variable "cidr" {
  description = ""
  default     = "172.31.0.0/16"
}

variable "subnet1" {
  description = ""
  default     = "172.31.1.0/24"
}
```
No arquivo `output.tf`vamos criar as variáveis de saída do nosso módulo VPC para uso posterior.

```hcl
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "The ID of the Subnet"
  value       = aws_subnet.subnet1.id
}
```

**Módulo S3**
Agora vamos criar nosso módulo S3, iniciando pelo arquivo `main.tf`crie o recurso conforme trecho de código abaixo:

```hcl
resource "aws_s3_bucket" "bucket-curso" {
  bucket = var.bucket-name
  acl    = "private"
}
```
Crie a variável de entrada para o nome do bucket utilizando o arquivo `variables.tf` conforme código abaixo:

```hcl
variable "bucket-name" {
    description = ""
    default = "curso-terraform"
}
```
Com a estrutura básica de nossos módulos locais criadas agora precisamos saber como utiliza-los de forma simultânea, para isso vá até a raiz do seu projeto e edite o arquivo `main.tf` utilizando o trecho de código abaixo:

```hcl
provider "aws" {
  version = "~> 3.0"
  region  = var.region
  profile = "default"
}

module "EC2" {
  source = "./modules/EC2"
}

module "VPC" {
  source = "./modules/VPC"
}

module "S3" {
  source = "./modules/S3"
}
```

>Observe que para realizar a chamada de módulos você precisa utilizar a função **`module`** do **Terraform** utilizando a estrutura 
>- `module` que é o tipo  
>- `EC2` que é o nome do módulo nomeado por você (Lembre-se que o **Terraform** possui nomes que não podem ser usados por ser de uso exclusivo do sistema.
>- `source` utilizado para especificar o caminho que o seu módulo esta localizado.

Agora precisamos realizar a inicialização dos módulos utilizando o comando `terraform init`
>A execução do comando `terraform init`é necessário para cada novo módulo que incluirmos em nosso código.

Durante a inicialização o **Terraform** irá mostrar uma saída com a inicialização dos módulos conforme abaixo:

```ssh
Initializing modules...
- EC2 in modules\EC2
- VPC in modules\VPC
- S3 in modules\S3

Initializing the backend...

Initializing provider plugins...

...
```
Agora vamos atribuir a Subnet para nossa instancia utilizando as variáveis de saída da nossa VPC e transformar-la em variáveis de entrada para nosso módulo EC2.

**Exemplo:**
No trecho do código que realizamos a chamada do módulo EC2, utilize as variáveis de saída da nossa VPC para informar qual a subnet que a instancia será criada, veja o trecho abaixo:
```hcl
module "EC2" {
  source = "./modules/EC2"
  subnet = "module.VPC.subnet_id" // output do módulo VPC
}
```
>Observe que usamos o caminho completo de onde a nossa variável de saída é realizada.

Para conseguirmos utilizar essa variável em nosso modulo EC2, você precisa especificar no arquivo `variables.tf`, do módulo conforme trecho abaixo:

```hcl
variable "subnet" {} // declaração da variável informada no arquivo raiz.

variable "instance_type" {
    description = "Tipo da Instancia"
    default = "t1.micro"
}
```
>Veja que a nossa variável agora não possui um valor default, isso porque já esta sendo passado no arquivo `main.tf`na raiz.

Agora você já pode inserir diretamente no recurso para atribuição correta, utilize o trecho de código abaixo no arquivo `main.tf`do módulo EC2.

```hcl
resource "aws_instance" "curso-terraform-data-source" {
  ami           = data.aws_ami.curso_terraform.id
  instance_type = var.instance_type
  subnet_id     = var.subnet
}
```
Agora vamos preparar nossos módulos para ser aplicado em nosso provedor.

**Step by Step**
- `terraform init`
- `terraform plan`
- `terraform apply`

Os recursos serão criados na sua infraestrutura com sucesso.
Caso encontre problemas habilite o Debug e tente encontrar onde esta o problema, em caso de cache feche o Editor e abra novamente que pode solucionar o problema.

Para maiores informações sobre módulos consulte a documentação oficial do **Terraform** no link abaixo:
[https://www.terraform.io/docs/configuration/modules.html](https://www.terraform.io/docs/configuration/modules.html)

###  Módulos Remotos<a name="data-sources"></a>
Agora que já sabemos como é extremamente útil a utilização de módulos locais quando você precisa reutilizar esses módulos você precisa versionar para poder compartilhar com seu time, mas como o **Terraform** hoje se tornou a principal ferramenta de provisionamento de infraestrutura como código a comunidade já avançou muito e hoje possuímos diversos repositórios com módulos prontos para ser consumidos e reutilizados.
Mas você também pode criar os seus módulos e compartilhar com a comunidade, para isso você deve seguir a estrutura recomendada pela **Hashicorp** seguindo o link [https://www.terraform.io/docs/modules/index.html](https://www.terraform.io/docs/modules/index.html), mas você poderá criar seus módulos personalizados e compartilhar com seu time ou até mesmo com a comunidade.
Para realizar o compartilhamento e versionamento de módulos você pode usar repositórios Git, S3 ou o repository registry que esta disponível no **Terraform Cloud**
Consulte a lista de fontes que você pode utilizar para versionar e compartilhar seus módulos no link [https://www.terraform.io/docs/modules/sources.html#modules-in-package-sub-directories](https://www.terraform.io/docs/modules/sources.html#modules-in-package-sub-directories).

#### Lista de repositórios de módulos do Terraform
Abaixo a lista com os repositórios e comunidades que posso dizer confiável e bastante madura.
- [https://registry.terraform.io/browse/modules](https://registry.terraform.io/browse/modules)
- [https://github.com/cloudposse](https://github.com/cloudposse)

Mas vamos criar nosso próprio repositório no Github para usar nossos módulos:
Crie um repositório no Github, copie a sua pasta de módulos que você criou local dentro do novo repositório.
Após realizar o versionamento para utilizar-los você precisa apenas alterar o source no seu arquivo `main.tf` conforme o trecho abaixo:

```hcl
provider "aws" {
  version = "~> 3.0"
  region  = var.region
  profile = "default"
}

module "EC2" {
  source = "git::https://github.com/devinfra-br/terraform-modules.git//modules/ec2"
  subnet = "module.VPC.subnet_id"
}

module "VPC" {
  source = "git::https://github.com/devinfra-br/terraform-modules.git//modules/vpc"
}

module "S3" {
  source = "git::https://github.com/devinfra-br/terraform-modules.git//modules/s3"
}
```
>Observe que a nossa estrutura permanece a mesma só alterando o source para nosso Git.

Realmente não existe segredos para utilizar módulos remotos no **Terraform**, mas os benefícios são muitos pois a reutilização e alteração dos módulos não afetam os ambientes já em execução.
>Lembre-se sempre de criar TAGS para versões dos seus módulos assim você consegue garantir que qualquer alteração nos módulos não afetara de verdade a sua infraestrutura de atualizações não planejadas.

Você pode incluir as tags de forma automática em pipelines ou gera-lá de forma manualmente e quando você declarar no source do seu módulo você deverá utilizar a estrutura abaixo:

```hcl
module "vpc" {
  source = "git::https://github.com/devinfra-br/terraform-modules.git//modules/s3?ref=v1.2.0"
}
```
> Importante saber como funciona essa trava a partir de versões, pois é exigido durante o exame **Terraform Associate**.

###  State File (Arquivo de estado)<a name="data-sources"></a>

Até agora já vimos que o **Terraform** é capaz de saber quais recursos já foram criados e o seu estado no provedor e como ele é capaz de fazer isso? Utilizando o **estado(state)**.
Por padrão sempre que você aplica ou destrói recursos na sua infraestrutura o Terraform cria um arquivo na raiz do seu projeto chamado `terraform.state`. Este arquivo possui um formato JSON e é capaz de registrar todas as alterações do comando para que na próxima execução ele determine e reconheça o que foi alterado ou deletado do seu código ou do seu provedor, esse processo ocorre como um `diff` entre o que está escrito em seu código local e o que está criado no seu provedor, por isso cada vez que você executar o comando `apply` o **Terraform** é capaz de identificar alterações mesmo que realizadas via console.
Outro ponto importante é que se você perder o arquivo `terraform.state` e executar o comando `apply` novamente o **Terraform** não será capaz de realizar o esse `diff` e ira recriar tudo novamente no seu provedor e se um outro membro do time der continuidade no desenvolvimento não saberá o que já foi aplicado na infraestrutura e o como foi aplicado, também não é recomendado que o arquivo de estado seja salvo em um repositório de versionamento ao menos que você seja o único a mexer neste arquivo caso contrário um verdadeiro desastre.
Para resolver e evitar este tipo de problema é possível realizar o versionamento do arquivo de estado utilizando **Remote State** que faz com que o **Terraform** salve o arquivo `terraform.state` em um repositório remoto(Backend) de forma automática e pode ser compartilhado com todo o time de desenvolvimento.
>Observe que quando o estado é alterado, um arquivo de backup é criado nomeado de `terraform.tfstate.backup`.

**Exemplo:**
Execute o comando `terraform apply` e observe que na raiz do projeto será criado um arquivo chamado `terraform.tfstate`.
```json
{
  "version": 4,
  "terraform_version": "0.12.26",
  "serial": 6,
  "lineage": "cc1fcf3a-b7ff-d841-b128-aea6aa93034d",
  "outputs": {},
  "resources": [
    {
      "module": "module.EC2",
      "mode": "data",
      "type": "aws_ami",
      "name": "curso_terraform",
      "provider": "provider.aws",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "architecture": "x86_64",
            "arn": "arn:aws:ec2:us-east-1::image/ami-09d8b5222f2b93bf0",
            "block_device_mappings": [
              {
                "device_name": "/dev/xvda",
                "ebs": {
                  "delete_on_termination": "true",
                  "encrypted": "false",
                  "iops": "0",
                  "snapshot_id": "snap-0ed3f0f331ab4cbc7",
                  "volume_size": "8",
                  "volume_type": "gp2"
                },
                "no_device": "",
                "virtual_name": ""
              }
            ],
            "creation_date": "2020-07-21T18:33:14.000Z",
            "description": "Amazon Linux AMI 2018.03.0.20200716.0 x86_64 HVM gp2",
            "executable_users": null,
            "filter": [
              {
                "name": "name",
                "values": [
                  "amzn-ami-hvm-*"
                ]
              },
              {
                "name": "state",
                "values": [
                  "available"
                ]
              }
            ],
...
```
Note que o arquivo é um JSON com os dados que foram aplicados no provedor.

###  Remote State e Backend<a name="data-sources"></a>

O **Terrraform** tem a capacidade de realizar o armazenamento do seu estado de forma remota e possui diversos tipos de Backends para isso. Você pode fracionar o que deseja armazenar ou armazenar 100% do estado pois algumas técnicas podem permitir delegação para times específicos.
Você não precisa ter iniciado o armazenamento do estado de forma remota, você pode migrar do seu ambiente local para o estado remoto a qualquer momento e vice e versa.
Em resumo o Remote state é capaz de recuperar o estado da sua infraestrutura de um backend e mesmo o estado ficando armazenado remotamente o **Terraform** é capaz de realizar as suas operações normalmente.
O **Terraform** suporta diversos tipos de versionamento do arquivo de estado as mais comuns são:
- Terraform Cloud
- HashiCorp Consul
- Amazon S3
- Alibaba Cloud OSS

Você pode consultar a lista de Remote States suportados na documentação do Provider no site do **Terraform**.
[https://www.terraform.io/docs/backends/types/index.html](https://www.terraform.io/docs/backends/types/index.html)


Agora vamos ver na prática como isso funciona. Neste exemplo nós iremos salvar o nosso arquivo de estado utilizando o S3 como nosso backend.

**Step by Step**
Na estrutura que já possuímos vamos migrar nosso arquivo `terraform.tfstate` de local para um Backend S3 na AWS.

Primeiramente precisamos criar os recursos na AWS e vamos fazer isso usando o **Terraform**.

No arquivo `main.tf` inclua o trecho de código abaixo:

```hcl
resource "aws_s3_bucket" "terraform-state-backend" {
  bucket = "curso-terraform-state" // Lembre-se de alterar o nome do bucket

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-state-lock-curso"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}
```
Observe que o Bucket S3 será o responsável por armazenar e versionar os arquivos `terraform.tfstate` e o Dynamodb será o responsável por armazenar os dados da origem de Bloqueio do arquivo, ou seja quando alguém estiver aplicando qualquer configuração é possível realizar a verificação de qual é o usuário e nome do computador que o comando esta sendo executado.

Execute o comando `terraform plan` e na sequencia `terraform init` os recursos para nosso arquivo de estado será criado.
Após criar esses 2(dois) recursos é possível configurar e inicializar nosso backend.

Crie um arquivo na raiz do seu projeto chamado `backend.tf` e copie o trecho abaixo:
```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-remote-state-s3-devinfra"
    dynamodb_table = "terraform-state-lock-dnm"
    key            = "curso/env/terraform.tfstate"
    region         = "us-east-1"
  }
}
```
Com o backend configurado seu arquivo `terraform.tfstate` estará seguro e versionado a cada alteração e ainda evitando que o mesmo seja alterado simultaneamente.
> Armazenar o arquivo `terraform.tfstate` em repositório VCS pode ser útil se você trabalha sozinho mas para utilizar em equipe ou mesmo já se preparar para seu time crescer com certeza o armazenamento via backend é a melhor opção.


###  Tipos de variáveis e Expressões<a name="data-sources"></a>
O **Terraform** permite se trabalhar com diversos tipos de variáveis e expressões para usar como referência, calcular valores dentro de uma configuração e ao criar nossas podemos definir o tipo de valor que será aceito.
Um exemplo é quando você cria um módulo e precisa restringir valores de entrada ou até mesmo formatar textos para padronizar o seu ambiente.

#### Tipos e Valores
O resultado de uma expressão é um valor . Todos os valores têm um tipo , que determina onde esse valor pode ser usado e quais transformações podem ser aplicadas a ele.
O **Terraform** aceita os valores abaixo:

* `string`
* `map`
* `list`
* `number`
* `null`


**Exemplos:**

**Listas** -  `list`
Ao declarar uma variável com o tipo list(Lista) você precisa utilizar os valores separados por virgula e entre colchetes:
**Exemplo**

```hcl
variable "az" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "security_group" {
  type = list(object({
    from_port = number
    to_port = number
    protocol = string
  }))
  ingress = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
    }
  ]
}
```
>Observe que é possível passar uma lista de objetos e definir o tipo do objeto em cada valor:

**Map** -  `map`
Ao declarar uma variável com o tipo map(Mapa) você precisa utilizar os valores separados por virgula e entre colchetes:

```hcl
variable "region_ami" {
  type = "map"
default = {
    eu-central-1   = "ami-0ad303949e19f897a"
    eu-north-1     = "ami-0d76cb8752ad73ab1"
    eu-west-1      = "ami-0f38cdec7da648424"
  }
}
```

Os tipos citados acima são os mais usados para conhecer a lista completa de tipos e valores acesse a documentação oficial do **Terraform** no link abaixo:
[https://www.terraform.io/docs/configuration/expressions.html](https://www.terraform.io/docs/configuration/expressions.html)

Com toda essa informação o melhor é mostrar alguns exemplos.

Realize teste com as suas expressões regulares e irregulares utilizando o comando `terraform console`.

**Expressões condicionais**
Observe como uma condição pode ser usada para validar um valor de entrada.
```hcl
//Variables
region_default = "us-west-2"
region_dev     = "sa-east-1"
region_qa      = "us-east-1"
region_prod    = "eu-central-1"

// Condição de Entrada 
var.region_qa != var.region_qa ? var.region_default : var.region_qa
```
Em nossa condição de entrada estamos forçando que o valor da região de QA seja único caso seja diferente podemos criar o recurso em uma região padrão.

Agora valide o resultado com `terraform console`

```ssh
terraform console
> "us-east-1" != "us-east-1" ? "us-west-2" : "us-east-1"
us-east-1
> "us-east-1" != "sa-east-1" ? "us-west-2" : "us-east-1"
us-west-2
```
> Com **Terraform** também é possível retornar uma mensagem de erro para o usuário usando validation, mas só a partir da versão 0.13.0
> ```hcl
> variable "ami_id" {
>   type = string
>   validation {
>     condition     = can(regex("^ami-", var.example))
>    error_message = "Must be an AMI id, starting with \"ami-\"."
>   }
> } 
> ```
[https://github.com/hashicorp/terraform/tree/guide-v0.13-beta](https://github.com/hashicorp/terraform/tree/guide-v0.13-beta)

**Funções**
O **Terraform** possui varias funções integradas e que você pode utilizar dentro de suas expressões para deixar suas validações ainda mais ricas.

-   [Numeric Functions](https://www.terraform.io/docs/configuration/functions.html#docs-funcs-numeric)
-   [String Functions](https://www.terraform.io/docs/configuration/functions.html#docs-funcs-string)
-   [Collection Functions](https://www.terraform.io/docs/configuration/functions.html#docs-funcs-collection)
-   [Encoding Functions](https://www.terraform.io/docs/configuration/functions.html#docs-funcs-encoding)
-   [Filesystem Functions](https://www.terraform.io/docs/configuration/functions.html#docs-funcs-file)
-   [Date and Time Functions](https://www.terraform.io/docs/configuration/functions.html#docs-funcs-datetime)
-   [Hash and Crypto Functions](https://www.terraform.io/docs/configuration/functions.html#docs-funcs-crypto)
-   [IP Network Functions](https://www.terraform.io/docs/configuration/functions.html#docs-funcs-ipnet)
-   [Type Conversion Functions](https://www.terraform.io/docs/configuration/functions.html#docs-funcs-conversion)

**Step by Step**

Vamos validar as operações e funções do terraform utilizando o `terraform console`.

função `min` e `max`.

```ssh
❯ terraform console
> min(55, 3453, 2)
2
> max(55, 3453, 2)
3453
>  
```
função `slice` extrai os elementos de acordo start index e o end index.\
`slice(["index-0", "index-1", "index-3", "index-4", "index-5"], indexstart, indexend)` agora execute o comando `terraform console` e vamos validar no console.

```
> slice(["index-0", "index-1", "index-3", "index-4", "index-5"], 0,2)
[
  "index-0",
  "index-1",
]
> slice(["index-0", "index-1", "index-3", "index-4", "index-5"], 3,5)
[
  "index-4",
  "index-5",
]
```
>Observe que o **Terraform** ira trazer o resultado dos indexes que estiverem entre o indexe inicial até o indexe final.

**Expressão`for`**
A expressão `for` será muito útil para realizar validações, pois ela é responsável por transformar e ou validar valores. Cada atributo do valor de entrada pode corresponder a 1 ou 0 valores no resultado, e você pode usar outras expressões ou funções para realizar validações uma verdadeira magica até a onde a nossa mente pode ir você poderá fazer com `for`.

Por exemplo, você pode colocar como regra que todas as tags do seu ambiente será maiúscula independente de como o desenvolvedor escreva, você pode usar a expressão for com a função upper.

**Step by Step**

Acesse o `terraform console` e valide as expressões abaixo:

```ssh
> [for s in ["Valor-1","vAlor-2","valOr-3"] : upper(s)]
[
  "VALOR-1",
  "VALOR-2",
  "VALOR-3",
]
```
Um outro exemplo é utilizando o `if` juntamente com `for` você pode realizar a validação de uma variável de entrada de um modulo ou recurso.

```ssh
> [for s in ["Valor-1","Valor-2","", "Valor-4"] : upper(s) if s != ""]
[
  "VALOR-1",
  "VALOR-2",
  "VALOR-4",
``` 
Acima pedimos para nos mostrar apenas os valores que são diferentes de vazio `!=`

```ssh
> [for s in ["Valor-1","Valor-2","", "Valor-4"] : upper(s) if s == ""]
[
  "",
]
```
Ou também mostrar somente os valores vazios.

São muitas as expressões e funções disponíveis no **Terraform** e você pode acessar a lista na documentação oficial.
[https://www.terraform.io/docs/configuration/expressions.html#function-calls](https://www.terraform.io/docs/configuration/expressions.html#function-calls)


### Trabalhando com Workspace 
O Terraform trabalha com um arquivo de estado por configuração, uma das formas de você poderá utilizar a mesma configuração em ambientes diferentes é utilizando os Workspaces. Quando você habilita o Terraform Workspace em sua configuração o terraform valida o backend associado ao espaço de trabalho em uso naquele momento.
Porem alguns cuidados dever ser levados em consideração ao se utilizar o Terraform Workspaces.
- Dificuldades em se trabalhar com módulos locais
- Você precisara fornecer validações para garantir que as configurações estão sendo aplicadas no ambiente correto.
- Erros de configurações em ambientes são mais fáceis de acontecer.

Agora se você optar em utilizar o Terraform Cloud o uso dos Workspaces são obrigatórios, porem o Terraform trata o Workspace como contas distintas e até mesmo código distintos. Então muito cuidado na utilização dos Workspaces sem um plano de trabalho ou fluxo bem definido.
Agora vamos ver na pratica como funciona. Quando iniciamos o uso do Terraform já estamos trabalhando com um Workspace chamado `default` para consultar qual o seu Workspace atual você deve utilizar o comando **`terraform workspace show`**.

Conhecendo o comando `terraform workspace`
Para uso do comando você deve fornecer um subcomando uma  opção e um argumento.

**Exemplo**
`terraform workspace <subcommand> [options] [args]`

**Subcomandos**
-  `terraform workspace list` (Lista os espaços de trabalho existentes)
-  `terraform workspace select` (Seleciona um espaço de trabalho)
 - `terraform workspace new` (Cria um novo espaço de trabalho)
 - `terraform workspace delete` (Deleta um espaço de trabalho)
 - `terraform workspace show` (Mostra o espaço de trabalho atual)

**Step by Step**
Observe como podemos criar uma configuração do **Terraform** para 2 ambientes distintos utilizando configurações Workspaces.
- Crie um arquivo main conforme abaixo

```hcl
provider "aws" {
  version = "~> 3.0"
  profile = lookup(local.profile, local.ambiente)
  region  = lookup(local.region, local.ambiente)
}

resource "aws_instance" "ec2_curso" {
  ami           = local.amis
  instance_type = local.instance_type
  count         = local.count
  tags          = local.common_tags
}
```
>Observe que em nosso aquivo `main.tf`nenhum valor esta sendo passado diretamente estamos usando apenas as variáveis.

- Crie uma arquivo chamado `variables.tf` e inclua as variáveis abaixo:


```hcl
locals {
  App_name = "Curso-Terraform"
  Empresa  = "Terraform Curso"
  Projeto  = "Aula Workspace"
}

locals {
  common_tags = {
    App_Name = local.App_name
    Empresa  = local.Empresa
    Ambiente = terraform.workspace
    Projeto  = local.Projeto
  }
}

locals {
  ambiente = terraform.workspace
  counts = {
    "dev" = 1
    "qa"  = 3
  }
  instances = {
    "dev" = "t2.micro"
    "qa"  = "t2.small"
  }
  instance_type = lookup(local.instances, local.ambiente)
  count         = lookup(local.counts, local.ambiente)
}

locals {
  profile = {
    "dev" = "default"
    "qa"  = "default"
  }
  region = {
    "dev" = "us-west-1"
    "qa"  = "us-east-2"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = data.aws_availability_zones.available.names
}

data "aws_ami" "curso_terraform" {
  most_recent = true
  filter {
    name   = "state"
    values = ["available"]
  }
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }
}

locals {
  amis = data.aws_ami.curso_terraform.id
}
```
> :memo: Os Workspaces são identificados a partir do valor `terraform.workspace` de forma automática, e você pode definir quais valores serão aplicados de acordo com o Workspace selecionado no momento da aplicação das configurações.

**Inicialize as configurações**

```ssh
> terraform init
```
 **Crie 2 Workspaces**
```ssh
> terraform workspace new qa 
> terraform workspace new dev
```
**Verifique os Workspaces existentes**
```ssh
> terraform workspace list
  default
* dev
  qa
```
>Observe que automaticamente o **Terraform** seleciona o workspace assim que ele é criado.

**Crie um plano de execução**
```ssh
> terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.
...
      + subnet_id                    = (known after apply)
      + tags                         = {
          + "Ambiente" = "dev"
          + "App_Name" = "Curso-Terraform"
          + "Empresa"  = "Terraform Curso"
          + "Projeto"  = "Aula Workspace"
        }
      + tenancy                      = (known after apply)
      + volume_tags                  = (known after apply)
      + vpc_security_group_ids       = (known after apply)
...
Plan: 1 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```
> Observe que nas tags o nome do Workspace é passado de acordo com o configurado.

**Mude de Workspace**
```ssh
> terraform workspace select qa
Switched to workspace "qa".

> terraform workspace list
  default
  dev
* qa
```
**Execute o plano de execução novamente**

```ssh
> terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

...
      + subnet_id                    = (known after apply)
      + tags                         = {
          + "Ambiente" = "qa"
          + "App_Name" = "Curso-Terraform"
          + "Empresa"  = "Terraform Curso"
          + "Projeto"  = "Aula Workspace"
        }
      + tenancy                      = (known after apply)
...

Plan: 3 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```
> Observe que agora o ambiente das Tags mudou para QA e a quantidade de instancia a ser  criada mudou para 3 conforme definimos nas variáveis. 
>- aws_instance.ec2_curso[0]
>- aws_instance.ec2_curso[1]
>- aws_instance.ec2_curso[2]

**Resumo**
Os workspaces são extremamente uteis quando se precisar utilizar a mesma configuração para ambientes distintos mas com as configurações idênticas, e você ainda pode utilizar diversas expressões para tomar decisões se o recurso será criado no ambiente ou não.


### Terraform Cloud - Básico 
Como já aprendemos a utilizar o binário do **Terraform** e conhecemos diversas das suas funcionalidades, ainda como gerenciar arquivos de estado e workspaces podem ser muito trabalhoso no dia a dia, para facilitar o uso e garantir maior resiliência podemos utilizar o **Terraform Cloud**. 
Terraform Cloud é uma plataforma pronta para realizar as execuções do Terraform e provisionar infraestrutura, sob demanda com suporte a diversos eventos do Terraform. Você não precisa integrar o Terraform em um (CI), pois a plataforma Cloud pode realizar com exelencia os fluxos de trabalho e trabalhar com os dados do Terraform.
Para conhecer mais sobre o Terraform Cloud e suas versões acesse a documentação oficial:
[https://www.terraform.io/docs/cloud/index.html](https://www.terraform.io/docs/cloud/index.html)

Como estamos aqui com foco em ajudar a comunidade vamos trabalhar com a versão free do Terraform Cloud, você pode criar sua conta no link abaixo:
[https://app.terraform.io/signup/account](https://app.terraform.io/signup/account)

Após criar a sua conta no Terraform Cloud no primeiro acesso você poderá encontrar algumas opções que podem ajuda-los nas configurações iniciais, fique a vontade para explorar o learning e outras documentações disponíveis.

**Step by Step**

Realize o login com a sua conta recém criada no Terraform Cloud, a primeira tela você pode escolher algumas opções mas para este guia você pode escolher **Not right now, skip questions**

<p align="center">
  <img src="https://s3.amazonaws.com/www.codeview.com.br/images/terraform-cloud_img1.jpg">
</p>

Crie um nome para seu projeto, assim como os Buckets S3 da AWS se você escolher um nome que já esta sendo usado por outra conta o Terraform não deixará você criar e devera escolher um nome disponível.

<p align="center">
  <img src="https://s3.amazonaws.com/www.codeview.com.br/images/terraform-cloud_img2.jpg">
</p>

Selecione a opção **Version control workflow** para que o seu fluxo de trabalho no workspace seja iniciado a partir de um repositório git.

<p align="center">
  <img src="https://s3.amazonaws.com/www.codeview.com.br/images/terraform-cloud_img3.jpg">
</p>

Escolha o repositório onde sua configuração do terraform esta versionada, veja que o Terraform possui varias opções de repositórios dos serviços mais utilizados.

<p align="center">
  <img src="https://s3.amazonaws.com/www.codeview.com.br/images/terraform-cloud_img4.jpg">
</p>

Autorize o terraform cloud a se conectar na sua conta e selecione o repositório onde seu código será versionado.

<p align="center">
  <img src="https://s3.amazonaws.com/www.codeview.com.br/images/terraform-cloud_img5.jpg">
</p>


Agora de um nome ao seu Workspace dentro do seu organization, para o terraform cloud os workspaces pode ser projetos distintos dentro do mesmo organization e não utilizamos a mesma lógica de criar workspaces local.
> Lembre-se seu repositório não pode ser vazio para iniciar um workspace no Terraform cloud.

<p align="center">
  <img src="https://s3.amazonaws.com/www.codeview.com.br/images/terraform-cloud_img6.jpg">
</p>

Aguarde que as configurações sejam concluídas:
<p align="center">
  <img src="https://s3.amazonaws.com/www.codeview.com.br/images/terraform-cloud_img7.jpg">
</p>

Agora que você realizou configurou seu primeiro Workspace no Terraform Cloud vamos configurar as credenciais de acesso, estamos fazendo apenas o basico para garantir maior segurança consulte as opções suportadas pelo Terraform Cloud.
As variáveis podem ser automaticamente configuradas usando como base o arquivo `terraform.tfvars`para cadastrar suas credenciais AWS você pode utilizar a opção **SENSITIVE** cadastre as variáveis com os valores `AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY` .

<p align="center">
  <img src="https://s3.amazonaws.com/www.codeview.com.br/images/terraform-cloud_img8.jpg">
</p>

<img align="right"  src="https://s3.amazonaws.com/www.codeview.com.br/images/queue-plan_1.jpg"></p>
Após configurar as variáveis, você precisa enfileirar clicando em `queue plan` assim o pipeline do Terraform cloud será iniciado\.
<br>
<br>

Após passa no plano de execução o terraform ira aguardar confirmação para aplicar em sua infraestrutura ou não.

<p align="center">
  <img src="https://s3.amazonaws.com/www.codeview.com.br/images/terraform-cloud_img10.jpg">
</p>

Você também pode utilizar o Terraform Cloud apenas para armazenar o arquivo de estado do Terraform.


Para realizar a execução do Terraform em um pipeline externo ou local você pode usar as opções

- CLI-driven workflow
Execute suas configurações locais e armazene o arquivo de estado no terraform Cloud.

- API-driven workflow
Execute as configurações do terraform atraves de um pipeline personalizado com armazenamento do arquivo de estado no Terraform Cloud.
<p align="center">
  <img src="https://s3.amazonaws.com/www.codeview.com.br/images/terraform-cloud_img11.jpg">
</p>



































**Expressões For**
```hcl

[for s in ["valor1","valor2","valor3"] : upper(s)]
{for s in  ["valor1","valor2","valor3"] : s => upper(s)}
[for s in ["valor1","valor2","","valor4"] : upper(s) if s != ""]
[for k, v in ["valor1","valor2","","valor4"] : length(k) + length(v)]
{for s in ["valor1","valor2","","sabor4"] : substr(s, 0, 1) => s... if s != ""}

```



[https://www.terraform.io/docs/configuration/expressions.html](https://www.terraform.io/docs/configuration/expressions.html)

[https://github.com/rberlind/terraform-0.12-examples](https://github.com/rberlind/terraform-0.12-examples)

[https://github.com/rick-wu-2020/terraform-learn-function/tree/master/terraform-learn-flatten-for_each-for-in-slice/unuse](https://github.com/rick-wu-2020/terraform-learn-function/tree/master/terraform-learn-flatten-for_each-for-in-slice/unuse)

[https://github.com/macleanj/terraform-functions/blob/master/main.tf](https://github.com/macleanj/terraform-functions/blob/master/main.tf)

[https://searchitoperations.techtarget.com/tip/Start-using-Terraform-variables-for-IT-resource-deployment-flexibility](https://searchitoperations.techtarget.com/tip/Start-using-Terraform-variables-for-IT-resource-deployment-flexibility)

###  Utilizando funções com Terraform<a name="data-sources"></a>

###  Terraform Cloud - Introdução<a name="data-sources"></a>

###  Trabalhando com Workspaces<a name="data-sources"></a>






###  Data Sources<a name="data-sources"></a>

[https://gitlab.com/devinfra/curso-terraform/-/blob/master/README.md#dependencias-explicitas](https://gitlab.com/devinfra/curso-terraform/-/blob/master/README.md#dependencias-explicitas)