import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o App'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              Text(
                'Nome do App:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('PokéLens'),
              SizedBox(height: 16),
              Text(
                'Versão do App:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('1.0.0'),
              SizedBox(height: 16),
              Text(
                'Descrição do App:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Este aplicativo é dedicado à manutenção de cartas Pokémon TCG. '
                'Ele inclui recursos como scanner de cartas usando visão computacional '
                'e armazenamento de dados offline.',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 32),
              Text(
                'Este aplicativo foi desenvolvido como parte de um projeto de iniciação científica '
                'por um aluno da Escola de Engenharia de São Carlos - USP, com o apoio da Bolsa PUB. '
                'O aplicativo utiliza apenas ferramentas de código aberto e não tem fins lucrativos. ' 
                'A equipe de desenvolvimento não possui afiliação com a Pokémon Company, Copag ou '
                'qualquer marketplace de cartas colecionáveis.', 
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 32),
              Text(
                'Desenvolvido por:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Thales Gomes Maurin'),
              SizedBox(height: 16),
              Text(
                'Contato:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Thalesmaurin@gmail.com'),
              SizedBox(height: 160),
            ],
          ),
        ),
      ),
    );
  }
}
