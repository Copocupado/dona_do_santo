import 'dart:math';

import 'package:dona_do_santo/auth/firebase_auth/auth_util.dart';
import 'package:dona_do_santo/backend/schema/reverse_store_record.dart';
import 'package:dona_do_santo/backend/schema/structs/index.dart';
import 'package:dona_do_santo/custom_code/actions/convertStringToDouble.dart';

import '../backend/schema/util/firestore_util.dart';

final List<String> titles = [
	'Camiseta Básica',
	'Jaqueta Jeans',
	'Calça Skinny',
	'Vestido Floral',
	'Blusa de Tricô',
	'Camisa Social',
	'Casaco de Lã',
	'Short Jeans',
	'Macacão Estampado',
	'Saia Midi',
	'Blazer de Linho',
	'Calça Cargo',
	'Polo Piquet',
	'Moletom Oversized',
	'Regata de Algodão',
	'Jaqueta Corta-Vento',
	'Camisa Xadrez',
	'Cardigan Alongado',
	'Calça Legging',
	'Vestido Tubinho',
	'Suéter Gola V',
	'Bermuda de Sarja',
	'Blusa de Renda',
	'Casaco de Couro',
	'Jardineira Denim',
	'Parka Militar',
	'Calça Jogger',
	'Camisa de Seda',
	'Jaqueta Bomber',
	'Saia Plissada',
	'Blusa Ombro a Ombro',
	'Camisa Polo Slim',
	'Calça de Moletom',
	'Vestido Longo',
	'Blazer Slim Fit',
	'Camiseta Estampada',
	'Blusa de Crepe',
	'Calça Flare',
	'Casaco Trench Coat',
	'Macacão Pantacourt',
	'Saia Lápis',
	'Jaqueta Puffer',
	'Camisa Listrada',
	'Blusa de Tule',
	'Calça Cropped',
	'Vestido Evasê',
	'Suéter Gola Alta',
	'Short de Tecido',
	'Blazer Xadrez',
	'Camiseta Gola Careca',
	'Camisa de Linho',
	'Calça Social',
	'Blusa de Seda',
	'Vestido de Festa',
	'Jaqueta de Sarja',
	'Saia Godê',
	'Calça Pantacourt',
	'Camisa Jeans',
	'Casaco Sobretudo',
	'Camiseta Longline',
	'Blusa Peplum',
	'Calça Clochard',
	'Vestido de Malha',
	'Blazer de Veludo',
	'Short Saia',
	'Camisa de Chiffon',
	'Jaqueta Varsity',
	'Calça Pantalegging',
	'Camiseta Raglan',
	'Blusa Ciganinha',
	'Vestido de Tricô',
	'Casaco de Pele Sintética',
	'Saia de Tule',
	'Calça Capri',
	'Camisa Manga Curta',
	'Macacão Saruel',
	'Blusa Bata',
	'Jaqueta Aviador',
	'Calça Pijama',
	'Vestido Decote V',
	'Blazer Texturizado',
	'Camiseta Tie Dye',
	'Calça de Vinil',
	'Camisa Floral',
	'Saia Longa',
	'Casaco Matelassê',
	'Blusa Manga Bufante',
	'Vestido Ciganinha',
	'Jaqueta Estofada',
	'Calça Pantalona',
	'Camiseta Vintage',
	'Saia de Couro',
	'Camisa de Viscose',
	'Blazer Alfaiataria',
	'Calça Chino',
	'Vestido de Linho',
	'Blusa Listrada',
	'Jaqueta de Nylon',
	'Calça Envelope',
	'Saia de Veludo',
	'Camiseta Básica Unissex',
];

final List<String> descriptions = [
	'Conforto e estilo para o dia a dia',
	'Design moderno com detalhes clássicos',
	'Ideal para ocasiões casuais ou formais',
	'Corte slim fit que valoriza a silhueta',
	'Tecido leve e respirável para o verão',
	'Toque suave com acabamento impecável',
	'Feita com materiais sustentáveis',
	'Perfeita para combinar com jeans ou saia',
	'Estampa exclusiva com cores vibrantes',
	'Elegância discreta para o trabalho',
	'Modelo versátil que se adapta a qualquer look',
	'Textura macia com um toque sofisticado',
	'Versatilidade para criar diferentes estilos',
	'Caimento perfeito para todas as estações',
	'Detalhes em renda que trazem delicadeza',
	'Resistente e durável, ideal para o inverno',
	'Ideal para sobrepor em dias mais frios',
	'Fácil de combinar com outras peças do guarda-roupa',
	'Estilo urbano com um toque de elegância',
	'Design minimalista com corte reto',
	'Perfeita para usar em viagens e passeios',
	'Toque retrô com um ar moderno',
	'Detalhe em botão que faz toda a diferença',
	'Look despojado para momentos de lazer',
	'Ideal para quem busca conforto sem perder o estilo',
	'Combinação de cores harmoniosa',
	'Leve e prática para o dia a dia',
	'Estilo descontraído com personalidade',
	'Perfeita para compor looks de meia estação',
	'Acabamento em costura dupla para maior durabilidade',
	'Versátil para o trabalho e momentos de lazer',
	'Modelo ajustável para maior conforto',
	'Estampa geométrica que se destaca',
	'Ideal para o fim de semana ou eventos especiais',
	'Toque macio com caimento leve',
	'Elegância e sofisticação em uma só peça',
	'Praticidade com um toque fashion',
	'Modelo clássico que nunca sai de moda',
	'Perfeita para combinar com acessórios variados',
	'Detalhes únicos que tornam a peça especial',
	'Tecido que proporciona liberdade de movimento',
	'Ideal para dias mais frescos e ensolarados',
	'Modelo que valoriza a silhueta feminina',
	'Confortável para usar o dia todo',
	'Acabamento em alta qualidade',
	'Tecido de alta tecnologia que garante conforto térmico',
	'Estilo contemporâneo para um visual moderno',
	'Ideal para ambientes profissionais',
	'Detalhes delicados para um toque feminino',
	'Corte moderno que valoriza o corpo',
	'Look sofisticado para ocasiões especiais',
	'Conforto absoluto com design diferenciado',
	'Tecido de fácil manutenção, não amassa',
	'Design clean com toque elegante',
	'Modelo versátil que pode ser usado de diversas formas',
	'Toque luxuoso com acabamento em brilho',
	'Perfeita para dias de clima ameno',
	'Ideal para combinar com peças neutras',
	'Design exclusivo com estampa diferenciada',
	'Estilo casual para o dia a dia',
	'Confeccionada com tecido premium',
	'Ideal para sobreposição em looks variados',
	'Acabamento refinado com detalhes sutis',
	'Design criativo com estilo único',
	'Perfeita para usar em eventos ao ar livre',
	'Tecido que garante conforto e estilo',
	'Look moderno com personalidade',
	'Elegância atemporal para todas as ocasiões',
	'Detalhe bordado que traz charme à peça',
	'Ideal para os dias mais quentes',
	'Tecido flexível que se adapta ao corpo',
	'Look casual com um toque chic',
	'Modelo despojado e confortável',
	'Perfeita para ocasiões especiais',
	'Estilo básico com um toque moderno',
	'Detalhe em zíper que agrega valor',
	'Modelo clássico com design contemporâneo',
	'Tecido respirável que garante frescor',
	'Look elegante e confortável',
	'Estilo prático para o dia a dia',
	'Toque macio com design clean',
	'Modelo com corte reto e elegante',
	'Estampa floral que traz leveza',
	'Perfeita para dias de verão',
	'Design esportivo com toque casual',
	'Tecido leve que proporciona frescor',
	'Look urbano com estilo moderno',
	'Ideal para compor looks descontraídos',
	'Detalhe trançado que agrega sofisticação',
	'Estilo casual com toque elegante',
	'Corte ajustado que valoriza o corpo',
	'Perfeita para usar com jeans ou leggings',
	'Tecido resistente que garante durabilidade',
	'Estilo básico para o guarda-roupa',
	'Detalhe em renda que agrega charme',
	'Modelo leve e prático',
	'Estilo fashion com toque minimalista',
	'Ideal para combinar com tênis ou sandálias',
	'Look casual para o dia a dia',
	'Detalhes modernos com design inovador',
	'Perfeita para compor looks de meia estação',
];


final List<String> genders = ['Masculino', 'Feminino', 'Unissex'];
final List<String> categories = ['Tops', 'Inferiores', 'Pijamas', 'Lingerie', 'Acessórios', 'Calçados', 'Roupas Sociais'];
final List<String> sizes = ['PP', 'P', 'M', 'G', 'GG', 'XG', 'XXG'];

final store = StoreStruct(
	address: "https://www.google.com/maps/search/?api=1&query=830%20Av.%20Planalto%2C%20Bento%20Gon%C3%A7alves%2C%20Rio%20Grande%20do%20Sul%2C%20Brasil",
	formattedAddress: "Bento Gonçalves - 830 Av. Planalto",
	storeImage: "https://firebasestorage.googleapis.com/v0/b/dona-do-santo-ujhc0y.appspot.com/o/users%2FYSw4b5SsePanr8cpk2lkLg4vLrB3%2FThu%20Aug%2008%202024%2011%3A43%3A58%20GMT-0300%20(Brasilia%20Standard%20Time)?alt=media&token=7556da6e-7f36-4364-bb93-6c6ff9f078c4",
);

final List<String> images = [
	'https://firebasestorage.googleapis.com/v0/b/dona-do-santo-ujhc0y.appspot.com/o/OwnerFiles%2Fbg1.jpg?alt=media&token=4e20bb8f-c62d-4bfa-a389-1e3eb26afd7a',
	'https://firebasestorage.googleapis.com/v0/b/dona-do-santo-ujhc0y.appspot.com/o/OwnerFiles%2Fbg2.jpg?alt=media&token=c6c0320e-26a6-4f16-9d8e-37b37c4f3baf',
	'https://firebasestorage.googleapis.com/v0/b/dona-do-santo-ujhc0y.appspot.com/o/OwnerFiles%2Fbg3.jpg?alt=media&token=30cf60ca-2813-4552-87e2-d2fafc9f1e15',
	'https://firebasestorage.googleapis.com/v0/b/dona-do-santo-ujhc0y.appspot.com/o/OwnerFiles%2Fbg4.jpg?alt=media&token=766df9ec-96f8-4ae7-ae41-1e4bdb0ed593',
];



Map<String, dynamic> createDummyDoc(){
	Random random = Random();

	return {
		...createReverseStoreRecordData(
			title: titles[random.nextInt(titles.length)],
			description: '${descriptions[random.nextInt(descriptions.length)]}, ${descriptions[random.nextInt(descriptions.length)]}, ${descriptions[random.nextInt(descriptions.length)]}',
			price: random.nextDouble() * 100000,
			gender: genders[random.nextInt(genders.length)],
			category: categories[random.nextInt(categories.length)],
			size: sizes[random.nextInt(sizes.length)],
			store: store,
			createdTime: DateTime.now(),
			createdBy: currentUserReference,
		),
		...mapToFirestore(
			{
				'images': [images[random.nextInt(images.length)], images[random.nextInt(images.length)], images[random.nextInt(images.length)], images[random.nextInt(images.length)]],
			},
		),
	};
}