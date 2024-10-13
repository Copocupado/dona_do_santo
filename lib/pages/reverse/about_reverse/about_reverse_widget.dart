import 'package:flutter/material.dart';
import 'package:dona_do_santo/custom_code/widgets/components.dart'
as components;
import 'package:dona_do_santo/pages/home_page/home_page_widget.dart' as homePage;

class AboutReverseWidget extends StatelessWidget{

  const AboutReverseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return  Scaffold(
      key: scaffoldKey,
      body: const SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              components.HeaderWidget(
                imagePath:
                'assets/images/about/about_reverse.jpg',
                title: 'Conheça o Reverse',
                description:
                'Revenda peças de roupa da nossa loja que não usará mais com nosso sistema exclusivo de intermediação',
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    homePage.HeaderTexts(
                        title: 'Vendedor', icon: Icons.sell_rounded),
                    components.CustomStepper(
                      stepTitles: [
                        "Insira uma peça de roupa",
                        "Aguardar venda",
                        "Entrega da peça",
                        "Recebimento do pagamento"
                      ],
                      stepDescriptions: [
                        "Na aba \"Reverse\" acesse o dashboard e clique na opção \"adicionar peça\", insira as informações necessárias e clique em \"adicionar\". Após a peça ser criada, ela será avaliada pelos nossos funcionários. Para garantir que a sua peça seja aprovada e possa ser vendida, certifique-se de não ter a peça suja ou com quaisquer tipos de danos. Caso a peça seja aprovada ou reprovada, notificaremos você com nosso sistema de notificações.",
                        "Após a aprovação da peça, ela estará disponível no sistema de busca do Reverse, qualquer pessoa poderá comprar sua peça caso esteja interessada. Caso sua peça seja comprada por outro cliente, notificaremos você pelo sino de notificações.",
                        "Após a compra da peça, você terá 2 dias úteis para entregar a peça em uma de nossas lojas, ela será então, entregue ao comprador por nós.",
                        "Pronto! Após a entrega da peça ao comprador, você receberá créditos no valor da peça para gastar no que quiser em nossas lojas!"
                      ],
                      stepFiles: [
                        "https://firebasestorage.googleapis.com/v0/b/dona-do-santo-ujhc0y.appspot.com/o/OwnerFiles%2FAboutReverse%2Fhuangxiaoming-hxm.gif?alt=media&token=5020cc1e-1b9f-4cfd-b2ef-dbd2d3c65c7a",
                        "https://firebasestorage.googleapis.com/v0/b/dona-do-santo-ujhc0y.appspot.com/o/OwnerFiles%2FAboutReverse%2Fhuangxiaoming-hxm.gif?alt=media&token=5020cc1e-1b9f-4cfd-b2ef-dbd2d3c65c7a",
                        "https://firebasestorage.googleapis.com/v0/b/dona-do-santo-ujhc0y.appspot.com/o/OwnerFiles%2FAboutReverse%2Fhuangxiaoming-hxm.gif?alt=media&token=5020cc1e-1b9f-4cfd-b2ef-dbd2d3c65c7a",
                        "https://firebasestorage.googleapis.com/v0/b/dona-do-santo-ujhc0y.appspot.com/o/OwnerFiles%2FAboutReverse%2Fhuangxiaoming-hxm.gif?alt=media&token=5020cc1e-1b9f-4cfd-b2ef-dbd2d3c65c7a"
                      ],
                    ),
                    SizedBox(height: 50),
                    homePage.HeaderTexts(
                      title: 'Comprador',
                      icon: Icons.money_rounded,
                    ),
                    components.CustomStepper(
                      stepTitles: [
                        "Procure por uma peça",
                        "Aguarde até que o comprador entregue a peça na loja",
                        "Retirar a peça"
                      ],
                      stepDescriptions: [
                        "Na aba \"Reverse\" acesse pesquise por uma peça de roupa que esteja interessado e veja as opções. Clique na opção comprar agora e preencha os dados necessários, você receberá um email de aprovação após a transação",
                        "Damos um prazo máximo de dois dias úteis para a entrega da peça na loja, caso o limite seja excedido, você terá seu dinheiro retornado e a compra cancelada",
                        "Você receberá uma notificação e um email de quando a peça for entregue, nele terá os dados da compra e um código que deverá ser informado aos nossos funcionários para a retirada da peça"
                      ],
                      stepFiles: [
                        "https://firebasestorage.googleapis.com/v0/b/dona-do-santo-ujhc0y.appspot.com/o/OwnerFiles%2FAboutReverse%2Fhuangxiaoming-hxm.gif?alt=media&token=5020cc1e-1b9f-4cfd-b2ef-dbd2d3c65c7a",
                        "https://firebasestorage.googleapis.com/v0/b/dona-do-santo-ujhc0y.appspot.com/o/OwnerFiles%2FAboutReverse%2Fhuangxiaoming-hxm.gif?alt=media&token=5020cc1e-1b9f-4cfd-b2ef-dbd2d3c65c7a",
                        "https://firebasestorage.googleapis.com/v0/b/dona-do-santo-ujhc0y.appspot.com/o/OwnerFiles%2FAboutReverse%2Fhuangxiaoming-hxm.gif?alt=media&token=5020cc1e-1b9f-4cfd-b2ef-dbd2d3c65c7a",
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
