Passo a passo criando um projeto com django

-primeiro vamos criar uma pasta com o nome do projeto que iremos fazer, por exemplo django2

-agora ultilizaremos o comando pip install para instalar aplicaçoes que usaremos no nosso projeto
ficara da seguinte forma:
  '  pip install django whitenoise gunicorn django-bootstrap4 PyMySQL django-stdimage '

-neste projeto iremos ultilizar o servidor de banco de dados PyMySQL

-proximo passo criar o arquivo requirements.txt,
 ultilizaremos o rseguinte comando:                 // o arquivo requirements.txt tera o nome dos app instalados no nosso projeto
    " pip freeze > requirements.txt "

- agora iremos criar o projeto, com  seguinte comando:
   " django-admin startproject django2 . "

- criaremos agora o nosso aplicativo, com o comando:
    " django-admin startapp core "

- em seguida começaremos a configurar o nosso arquivo settings
   vamos alterar o arquivo ALLOWED_HOST = [],  ficara da seguinte forma: ALLOWED_HOST = ['*']
   
   ainda em settings, vamos acrescentar os app que instalamos em INSTALLED_APP, ficara da seguinte forma:
   'core',
   'bootstrap4',
   'stdimage',

   na sessão middleware, acrescentaremos na SEGUNDA linha, esse comando ficara comentado durante o desenvolvimento.
   #'whitenoise.middleware.WhiteNoiseMiddleware',

   na sessao de TEMPLATES, iremos colocar o seguinte:
   'DIRS': ['templates'],        avisando ao programa que teremos um diretorio template, onde ficara os arquivos html7


agora vamos configurar o DATABASES, com o banco de dados (django2) já criado, iremos alterar o campo de DATABASES para que fique da seguinte forma:
   DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'django2',
        'USER': 'root',
        'PASSWORD': '159635',
        'HOST': 'localhost',
        'PORT': '3306'
    }
}

mudaremos o idioma para pt-br

em seguida, criaremos o static_root, ficara da seguinte forma:
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')

podemos agora definir as VIEWS,  e crias as defs
    no exemplo do programa que estamos fazendo, vamos criar as views INDEX, CONTATO e PRODUTO.

em seguida, devemos criar um diretorio, na raiz da aplicação, com o nome 'templates', onde ficara os arquivos html
    dentro de templates iremos criar os 3 arquivos html correnspondentes as views que criamos 

criar um diretorio na raiz da app com o nome, 'static' 
        dentro dele, tres diretorios com os seguintes nomes:
            'css'
            'js'
            'images'
        onde ficarao os arquivos estaticos, como imagens, arquivos css e arquivos java script


até o momento temos apenas um arquivo de rotas no nosso projeto, o que nao é legal, entao criaremos um arquivos de rotas
'urls.py' em cada app
        para isso, iremos no arquivos urls.py do nosso projeto, e criaremos um path, ficara da seguinte forma:

            from django.contrib import admin
            from django.urls import path, include

            urlpatterns = [
                path('admin/', admin.site.urls),
                path('', include('core.urls')),
            ]

a rota que estamos informando ao nosso programa ainda nao existe, entao precisamos criala.
    vamos criar na raiz da nossa app, um arquivo urls.py

    o nosso arquivo ficara da seguinte forma:

        from django.urls import path
        from .views import index, contato, produto

        urlpatterns = [
            path('', index, name='index')
            path('contato/', contato, name='contato')
            path('produto', produto, name='produto')
        ]   

em seguida vamos fazer o migrate:   'python manage.py migrate'

o proximo passo é conectar o programa com o banco de dados, sera ultilizado o seguinte comando:
    python manage.py migrate
        esse comando criara automaticamente as tabelas do programa no nosso banco de dados, já é um sinal que esta
        dando tudo certo, pois se o programa nao consegui-se se conectar ao banco de dados, daria um erro neste momento!

o proximo passo sera criar o SUPERUSER, ultilizaremos o comando 'python manage.py createsuperuser'. 

agora podemos rodar a aplicação, para testar...

ANOTAÇÃO
    Neste projeto, teremos o recurso de enviar e receber email, sera de uma maneira 'simulada'

na raiz da nossa aplicação, criaremos um arquivo com o nome de 'forms.py'.  neste arquivo ficara os nossos formularios
caso tenha em formularios em nossa app...
ANOTAÇÃO
    algumas anotações sobre formulario no django:
        ao criar um formulario em arquivo html com django, é preciso dentro deste formulario ultilizar a ferramenta
        '{% csfr-token %}'

        no exemplo da aula, foi ultilizado o bootstrap4, facilita trabalhar com formulario, pois criar layouts já prontos
        com css e javascript

       nosso form dentro do arquivo html, ficou da seguinte forma:
           ' <div class="container">
            <h1>Contato</h1>
            {% bootstrap_messages %}
                <form action="{% url 'contato' %}" method="post" class="form" autocomplete="off">   //observe class="form"  esta avisando ao bootstrap, para usar um layout especifico para formularios
                    {% csrf_token %}
                    {% bootstrap_form form %}
                    {% buttons %}
                        <button type="submit" class="btn btn-primary">Enviar Mensagem</button>
                    {% endbuttons %}
                </form>
            </div>'
    em resumo, o form nao esta salvando esses dados que estao sendo submetidos no banco de dados, para isso se ultilizaria classes em python


CONFIGURANDO A PARTE DE SETTINGS EMAILL

    no exemplo da aula, ultilizamos esta ferramenta do django.
        EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackends'
        mas caso haja um servidor de Email, usara a seguinte connfiguração
            EMAIL_HOST = 'localhost'    geralmente por padrão é local host
            EMAIL_HOST_USER = 'no-reply@seudominio.com.br      vai ser o email a qual vai ser conectado ao servidor de email
            EMAIL_PORT = 587    a porta de conexão,  se for conexão segura geralmente vai ser 587
            EMAIL_USER_TSL = True    se vai ultilizar criptografia ou nao,, geralmente sim
            EMAIL_HOST_PASSWORD = sua senha'

    Vamos criar uma def dentro da classe ContatoForm, essa def se chamara send_mail, nela sera criada uma instancia
    da classe Emailmessage, Emailmessage é uma classe do django, ao criar esta instancia
    essa def ficara da seguinte forma:

            from django import forms
            from django.core.mail.message import EmailMessage

            def send_mail(self):
                nome = self.cleaned_data['nome']
                email = self.cleaned_data['email']
                assunto = self.cleaned_data['assunto']
                mensagem = self.cleaned_data['mensagem']

                conteudo = f'Nome: {nome}\nEmail: {email}\nAssunto: {assunto}\nMensagem: {mensagem}'

                mail = EmailMessage(
                subject='Email enviado pelo sistema django2',
                body=conteudo,
                from_email='contato@seudominio.com.br',
                to=['contato@seudominio.com.br'],
                headers={'Replay-to': email}
                )

                mail.send()
        

    Agora nossas configurações para enviar email estão concluidas, iremos alterar a def contato(), no diretorio views, ficara, da seguinte forma:
                
    def contato(request):
    form = ContatoForm(request.POST or None)

        if str(request.method) == 'POST':
            if form.is_valid():
                form.send_mail()
                
                messages.success(request, 'E-mail enviado com sucesso!')
                form = ContatoForm()
            else:
                messages.error(request, 'Erro ao enviar e-mail')

        context = {
            'form': form
        }
    return render(request, 'contato.html', context)

CRIANDO NOSSOS MODELOS
        vamos criar uma classe abstrata, que sera herdada pelas proximas classes, para que ela herde alguns
        atributos que podem ser repetidos ANOTAÇÃO interessante! as classes abstratas não são instaladas no banco de dados!!!
        
        Ainda vamos criar um slug, que é um metodo para que o nome do nosso produto possa aparecer no link!
        a class em models ficara da seguinte forma:
        from django.db import models
        from stdimage.models import StdImageField

        from django.db.models import signals
        from django.template.defaultfilters import slugify

        class Base(models.Model):
            criado = models.DateField('Data de criação', auto_now_add=True)
            modificado = models.DateField('Data de Atualização', auto_now=True)
            ativo = models.BooleanField('Ativo?', default=True)

            class Meta:
                abstract = True
        class Produto(Base):
            nome = models.CharField('Nome', max_length=100)
            preco = models.DecimalField('Preco', max_digits=8, decimal_places=2)
            estoque = models.IntegerField('Estoque')
            imagem = StdImageField('Imagem', upload_to='produtos', variations={'thumb': (124, 124)})
            slug = models.SlugField('Slug', max_length=100, blank=True, editable=False)

            def __str__(self):
                return self.nome
        def produto_pre_save(signal, instance, sender, **kwargs):
            instance.slug = slugify(instance.nome)

        signals.pre_save.connect(produto_pre_save, sender=Produto)

            
        Após criar essa classe, devos executar o comando python manage.py makemigrations, é padrao que a cada classe nova
        criada, seja executado esse comando
        Agora vamos configurar o arquivo admin.py, para registrar nossa class, ficara da seguinte forma:
            from django.contrib import admin

            from .models import Produto
            
            @admin.register(Produto)
            class ProdutoAdmin(admin.ModelAdmin):
                list_display = ('nome', 'preco', 'estoque', 'slug', 'criado', 'modificado', 'ativo')
        

AGORA JÁ CONSEGUIMOS CADASTRAR NOSSOS PRODUTOS NA SESSAO ADMIN, E CARREGAR IMAGENS AO CADASTRAR O PRODUTO, E TUDO SERA 
SALVO NO BANCO DE DADOS.


Já haviamos aprendido criar o formulario de email, agora vamos aprender o  'model form' para salvar os formularios
no banco de dados.

Precisamos criar uma class em forms.py, ficara da seguinte forma:

    from .models import Produto
    class ProdutoModelForm(forms.ModelForm):
        class Meta:
            model = Produto
            field = ['nome', 'preco', 'estoque', 'imagem']

depois precisamos alterar nosso def produto(), ficara da seguinte forma:
    def produto(request):
        if str(request.method) == 'POST':     #verifica se o metodo é POST, ou seja, se o usuario esta postando o formulario já preechido
            form = ProdutoModelForm(request.POST, request.FILES)        
            if form.is_valid():               #verifica se o formulario é valido
                prod = form.save(commit=False)        #neste exemplo nao esta sendo salvo no banco de dados, vamos apenas printar no terminal, para analisar o codigo
                
                print(f'Nome: {prod.nome}')
                print(f'Preço: {prod.preco}')
                print(f'Estoque: {prod.estoque}')
                print(f'Imagem: {prod.imagem}')
                
                messages.success(request, 'Produto salvo com sucesso.')
            else:
                messages.error(request, 'Erro ao salvar Produto')
                
        else:                                 # Se a requisição, não for tipo POST, segnfica que é primeira vez que o formulario esta sendo aberto, é precisa ser preenchido, entao a classe sera estanciada, para que seja preenchido os campos
            form = ProdutoModelForm()
        context = {
            'form': form
        }
        return render(request, 'produto.html', context)


Em seguida vamos criar o arquivo html de produtos, ficara da seguinte forma:

    {% load bootstrap4 %}
    <!DOCTYPE html>
    <html lang="pt-br">
    <head>
        <meta charset="UTF-8">
        <title>Produto</title>
        {% bootstrap_css %}
    </head>
    <body>
        <div class="container">
            <h1>Produto</h1>
            {% bootstrap_messages %}

            <form action="{% url 'produto' %}" method="post" class="form" autocomplete="off" enctype="multipart/form-data">
                {% csfr_token %}

                {% bootstrap_form form %}
                {% buttons %}
                    <button type="submit" class="btn-primary">Cadastrar</button>
                {% endbuttons %}
            </form>
        </div>
    {% bootstrap_javascript jquery='full' %}
    </body>
    </html>"


Já conseguimos agora cadastrar os produtos com modelform, via html, mas por enquanto esta só printanndo os dados na tela, na proxima aula, vamos aprender a salvar no banco de dados
Vamos alterar a nossa views produto, para que agora ela salve os arquivos no banco de dados... ficara assim:
    def produto(request):
        if str(request.method) == 'POST':
            form = ProdutoModelForm(request.POST, request.FILES)
            if form.is_valid():
                form.save()

                messages.success(request, 'Produto salvo com sucesso.')
                form = ProdutoModelForm()
            else:
                messages.error(request, 'Erro ao salvar Produto')
        else:
            form = ProdutoModelForm()
        context = {
            'form': form
        }
        return render(request, 'produto.html', context)



Observamos que os nossos arquivos de media que estao sendo upados pelo usuario, estao sendo criados dentro do
diretorio produto, não é o ideal. Entao vamos alterar o nosso settigns, ficara da seguinte forma:
    STATIC_URL = 'static/'
    STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
    MEDIA_URL = 'media/'
    MEDIA_ROOT = os.path.join(BASE_DIR, 'media')    

    Agora na raiz do projeto, precisamos alterar o arquivo de urls, ficara da seguinte forma:
        from django.contrib import admin
        from django.urls import path, include

        from django.conf.urls.static import static
        from django.conf import settings

        urlpatterns = [
            path('admin/', admin.site.urls),
            path('', include('core.urls')),
        ] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

    esta pronto, nossos produtos estao sendo salvos agora no banco de daods, via model form, 
    ANOTAÇÃO umma observação importante é que os arquivos de media nao estao sendo salvos no banco de dados,
    no banco de dados há apenas o caminho, indicando onde esta salvo o arquivo de media, no caso do nosso programa, 
    esta em diretorio com o nome de produto.



APRESENTANDO DADOS DO BANCO DE DADOS NO TEMPLATES...
    vamos agora importar o nosso mmodel Produto, para a view Index..  vamos colocar todos os objetos de Produto no contexto
    ficara assim:

from .models import Produto

def index(request):
    context = {
        'produtos': Produto.objects.all()
    }
    return render(request, 'index.html', context)

    pronto, agora podemos apresentar nossos dados do banco de dados na pagina html, manipulalos com javascript



Como deixar apenas que usuario acesse a area administrativa se ele tiver acesso:

if str(request.user) != 'AnonymousUser':
        Basta acrescentar este if nadef da views produto, se ele for diferente de 'AnonymousUser', significa que o usuario 
        esta logado. e pode seguir o fluxo normal da def...


        PUBLICANDO NOSSO PROJETO NA INTERNET 

        primeiro passo no arquivo settigns, mudar o DEBUG para False
        
        agora vamos descomentar a linha de codigo whitenoise, na seção middleware...

        vamos comentar o EMAIL_BACKEND

        BANCO DE DADOS, o django nao da suporte para o mysql, entao vamos comentar as configurções anteriores de banco de dados

        Precisamos digitar no terminal o comando  'pip install dj_database_url psycopg2-binary'      
                dj_database_url *serve para a gente passar as configurações defaut de banco de dados para o django.
                psycopg2-binary *é o nosso drive de conexão para o banco de dados lá no heroko

                vamos atualizar o requirements.txt 'pip freeze > requirements.txt'

                agora vamos em settings, fazer o import da biblioteca que a gente acabou de instalar
                        'import dj_database_url'

                o banco de dados que vamos ultilizar, é o PostgreSQL com Heroku
                    import dj_database_url

                    #usando postgresql com heroku
                    DATABASES = {
                        'defaut': dj_database_url.config()
                    }

                criamos o arquivo na raiz do nosso projeto, '.gitignore'
                    e dentro dele ficara da seguinte forma:

                            __pycache__

                            *.*~

                            *.pyc

                            .idea

                Agora vamos criar um projeto git init dentro do nosso projeto, com o seguinte comando:
                    'git init'

                em seguida:
                    'git add .'    nao pode esquecer do espaço ponto.

                vamos fazer o primeiro commit:
                        'git commit -m "projeto finalizado"'

                Precisamos agora logar com o heroku:
                        'heroku login'
                    
                criamos o arquivo na raiz do nosso projeto:
                    'runtime.txt' dentro dele colocaremos a versao do nosso python que estamos ultilizando:
                        'python-3.10.7'

                criamos umm arquivo na raiz do nosso projeto:
                    Procfile...   dentro dele ficara assim:
                        web: gunicorn django2.wsgi --log-file -

                vamos novamente adicionar e comitar..

                agora criamos a nossa aplicação no heroku:
                    'heroku create django2-dr --buildpack heroku/python'

                em seguinda:
                    'git push heroku master'
                
                agora vamos adicionar nossas tabelas do banco de dados:
                    'heroku run python manage.py migrate'
                
                em seguida, criamos o super user
                'heroku run python manage.py createsuperuser'


                
            --------------O PROJETO ESTA PUBLICADO E ONLINE--------------

os arquivos de media, não estao aparecendo.. 
passos:
        no console:   'pip install dj-static'        #esta biblioteca ira substituir o whitenoise
        em seguida:   'pip install -r requirements.txt'
        vamos desistalar o whitenoise, já que ele nao sera usado:  'pip uninstall whitenoise'
        e agora atulizar o requirements 'pip freeze > requirements.txt'
        vamos em 'settigns' e remover o whitenoise
        vamos no diretorio 'wsgi' em vamos fazer o import da biblioteca que acabamos de instalar 'from dj_static import Cling, MediaCling'
                    O MediaCling vai apresentar pra gente os arquivos de upload do usuario, e o Cling os arquivos css, javascript
                        dentro do wsgi ficara da seguinte forma: 'application = Cling(MediaCling(get_wsgi_application()))'
                        'git add .' para adicionar as mudanças que forma feitas
                        'git commit -m "blabla"'
                        'git push heroku master'


                        
Como haviamos publicado, e os arquivos de media nao estavam aparecendo, vamos resetar o banco de dados, o comando a seguir ira zerar o banco de dados:
      '  heroku pg:reset DATABASE_URL '
            Agora precisar fazer o migrate, para recriar ass tabelas novamente:
                            '  heroku run python manage.py migrate  '
            Criar superuser:
                            '  heroku run python manage.py createsuperuser  '

                            CABO!!!!!!!