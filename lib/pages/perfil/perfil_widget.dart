import 'package:auto_size_text/auto_size_text.dart';
import 'package:dona_do_santo/auth/firebase_auth/auth_util.dart';
import 'package:dona_do_santo/backend/schema/reverse_store_record.dart';
import 'package:dona_do_santo/custom_code/actions/convertDoubleToString.dart';
import 'package:dona_do_santo/custom_code/widgets/components.dart'
as components;
import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../backend/firebase/firebase_config.dart';
import '../../flutter_flow/nav/serialization_util.dart';
import '../notifications/notifications_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '../../backend/backend.dart';
import '../../backend/firebase_storage/storage.dart';
import '../../custom_code/actions/deleteImagesFromStorage.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../flutter_flow/upload_data.dart';

class PerfilWidget extends StatefulWidget {
	const PerfilWidget({
		super.key,
	});

	@override
	State<PerfilWidget> createState() => PerfilWidgetState();
}

class PerfilWidgetState extends State<PerfilWidget> {
	final scaffoldKey = GlobalKey<ScaffoldState>();
	final unfocusNode = FocusNode();

	final ValueNotifier<bool> isUploadingPfp = ValueNotifier(false);
	final ValueNotifier<bool> isSendingEmail = ValueNotifier(false);

	bool isDeletingAccount = false;
	String message = '';
	double progress = 0.0;

	static final ValueNotifier<bool?> isNotificationsEnabled = ValueNotifier(null);
	static late bool hasCalledOnce;

	@override
	void initState() {
		super.initState();
		unfocusNode.dispose();
	}

	Future<void> checkIfNotificationsEnabled() async {
		print('method called');
		try {
			var docRef = FirebaseFirestore.instance.collection('tokens_de_notificacao').doc(FirebaseApi.fcmToken);
			var doc = await docRef.get();

			if(!doc.exists) return;

			if(doc.data() == null) return;
			setState(() {});
			hasCalledOnce = true;
			isNotificationsEnabled.value = doc.data()!['user_reference'] == currentUserReference;

		} catch (e) {
			print('Error checking document existence: $e');
			return;
		}
	}

	@override
	void dispose() {
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onTap: () => unfocusNode.canRequestFocus
					? FocusScope.of(context).requestFocus(unfocusNode)
					: FocusScope.of(context).unfocus(),
			child: Scaffold(
				key: scaffoldKey,
				backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
				body: SafeArea(
					top: true,
					child: !isDeletingAccount
							? FutureBuilder(
							future: !hasCalledOnce ? checkIfNotificationsEnabled() : null,
							builder: (context, snapshot){
								if (snapshot.connectionState == ConnectionState.waiting) {
									return const components.LoadingIcon();
								} if (snapshot.hasError) {
									return Text('Error: ${snapshot.error}');
								}
								isNotificationsEnabled.value ??= false;

								return SingleChildScrollView(
									child: Stack(
										children: [
											Column(
												children: [
													const SizedBox(height: 100),
													Padding(
														padding: const EdgeInsets.all(12),
														child: Column(
															children: [
																userCard(),
																labelForReverseCredits(),
															].divide(const SizedBox(height: 20)),
														),
													),
													const SizedBox(height: 10),
													reverseCredits(),
													Column(
														children: [
															ValueListenableBuilder(
																valueListenable: isSendingEmail,
																builder: (context, value, child) {
																	if (value) {
																		return const Column(
																			children: [
																				components.LoadingIcon(),
																				SizedBox(height: 10),
																			],
																		);
																	}
																	return ProfileOption(
																			title: 'Redefinir senha',
																			icon: Icons.remove_red_eye,
																			parentFunc: resetPassword);
																},
															),
															ProfileOption(
																	title: 'Alterar foto de perfil',
																	icon: Icons.person,
																	parentFunc: changeUserPfp),
															NotificationsSection(initialValue: isNotificationsEnabled),
															ProfileOption(
																	title: 'Deletar conta',
																	icon: Icons.delete,
																	parentFunc: deleteAccount),
														].divide(const Separator()),
													),
													const Separator(),
													SizedBox(
														width: MediaQuery.of(context).size.width,
														child: Padding(
															padding: const EdgeInsets.all(36),
															child: FFButtonWidget(
																onPressed: () async {
																	GoRouter.of(context).prepareAuthEvent();
																	await authManager.signOut();
																	if (context.mounted) {
																		GoRouter.of(context)
																				.clearRedirectLocation();
																		context.goNamedAuth(
																				'Login', context.mounted);
																	}
																},
																text: 'Sair',
																icon: const Icon(
																	Icons.logout,
																	size: 24,
																),
																options: FFButtonOptions(
																	padding: const EdgeInsetsDirectional.fromSTEB(
																			16, 0, 16, 0),
																	iconPadding:
																	const EdgeInsetsDirectional.fromSTEB(
																			0, 0, 0, 0),
																	color: FlutterFlowTheme.of(context).tertiary,
																	textStyle: FlutterFlowTheme.of(context)
																			.titleSmall
																			.override(
																		fontFamily: 'Readex Pro',
																		color: FlutterFlowTheme.of(context)
																				.primaryBackground,
																	),
																	elevation: 10,
																	borderRadius: BorderRadius.circular(100),
																),
															),
														),
													),
												],
											),
											Padding(
												padding: const EdgeInsets.all(12),
												child: components.AppBar(
													mainColor: FlutterFlowTheme.of(context).primaryText,
													secondaryColor: FlutterFlowTheme.of(context).tertiary,
													imageVariant: 'default',
												),
											),
										],
									),
								);
							}
					)
							: UserDeletionUI(message: message, currentProgress: progress),
				),
			),
		);
	}

	double returnReverseCredits(double? value) {
		if (value == null) {
			currentUserReference!.update(createUsersRecordData(
				reverseCredits: 0.0,
			));
			return 0.0;
		}
		return value;
	}

	Widget reverseCredits() {
		return AuthUserStreamWidget(
			builder: (context) {
				return Text(
					'R\$${convertDoubleToString(currentUserDocument!.reverseCredits)}',
					style: FlutterFlowTheme.of(context).bodyMedium.override(
						fontFamily: 'Readex Pro',
						fontSize: 50,
						color: FlutterFlowTheme.of(context).primaryText,
					),
				);
			},
		);
	}

	Future<void> deleteAccount() async {
		await showDialog(
			context: context,
			builder: (dialogContext) {
				return Dialog(
					elevation: 0,
					insetPadding: EdgeInsets.zero,
					backgroundColor: Colors.transparent,
					alignment: const AlignmentDirectional(0, 0)
							.resolve(Directionality.of(context)),
					child: GestureDetector(
						onTap: () => FocusScope.of(dialogContext).unfocus(),
						child: const DeleteAccountConfirmationDialog(),
					),
				);
			},
		).then((value) async {
			if (value == true) {
				setState(() => isDeletingAccount = true);

				setState(() => message = 'Busacndo seus anúncios no reverse...');
				final List<ReverseStoreRecord> reverseStoreRecords =
				await queryReverseStoreRecordOnce(
					queryBuilder: (reverseStoreRecord) => reverseStoreRecord.where(
						'created_by',
						isEqualTo: currentUserReference,
					),
				);

				setState(() {
					progress = 0.16666;
					message = 'Buscando suas solicitações...';
				});
				final List<SolicitacoesRecord> solicitacoesRecords =
				await querySolicitacoesRecordOnce(
					queryBuilder: (solicitacoesRecord) => solicitacoesRecord.where(
						'created_by',
						isEqualTo: currentUserReference,
					),
				);

				final List<String> imagesToDelete = [
					...reverseStoreRecords.expand((item) => item.images),
					...solicitacoesRecords.expand((item) => item.images)
				];

				setState(() {
					message = 'Excluindo as imagens atribuídas à sua conta...';
					progress += 0.16666;
				});
				for (var image in imagesToDelete) {
					try {
						await FirebaseStorage.instance.refFromURL(image).delete();
					} catch (e) {
						print(e);
					}
					setState(() => progress += (0.16666 / imagesToDelete.length));
				}

				setState(() {
					message = 'Excluindo seus anúncios...';
					progress = 0.5;
				});
				for (var reverseItem in reverseStoreRecords) {
					await reverseItem.reference.delete();
					setState(() => progress += (0.16666 / reverseStoreRecords.length));
				}

				setState(() => message = 'Excluindo suas solicitações...');
				for (var solicitacao in solicitacoesRecords) {
					await solicitacao.reference.delete();
					setState(() => progress += (0.16666 / solicitacoesRecords.length));
				}

				setState(() => message = 'Excluindo seu usuário...');
				await deletePastImage();
				await currentUserReference!.delete();
				setState(() => progress += (0.16666 / 2));
				await authManager.deleteUser(context);
				setState(() {
					message = 'Tudo Feito!';
					progress = 1.0;
					isDeletingAccount = false;
				});
				await Future.delayed(const Duration(milliseconds: 500));
				context.pushNamed('Login');
			}
		});
	}

	Widget userCard() {
		return Container(
			width: MediaQuery.sizeOf(context).width,
			height: 100,
			decoration: BoxDecoration(
				color: FlutterFlowTheme.of(context).tertiary,
				boxShadow: const [
					BoxShadow(
						blurRadius: 4,
						color: Colors.black,
						offset: Offset(
							0,
							2,
						),
					)
				],
				borderRadius: BorderRadius.circular(12),
			),
			child: Padding(
				padding: const EdgeInsets.all(12),
				child: Row(
					mainAxisAlignment: MainAxisAlignment.start,
					children: [
						Flexible(
							child: InkWell(
								onTap: showPfp,
								child: Stack(
									children: [
										Container(
											height: 1000,
											//Corrige bug da imagem
											width: 1000,
											clipBehavior: Clip.antiAlias,
											decoration: const BoxDecoration(
												shape: BoxShape.circle,
											),
											child: ValueListenableBuilder<bool>(
													valueListenable: isUploadingPfp,
													builder: (context, value, child) {
														if (value) {
															return components.LoadingIcon(
																	altColor: FlutterFlowTheme.of(context)
																			.primaryBackground);
														} else {
															return components.ImageWithPlaceholder(
																	image: currentUserPhoto);
														}
													}),
										),
										Align(
											alignment: Alignment.bottomRight,
											child: Container(
												width: 30,
												height: 30,
												clipBehavior: Clip.antiAlias,
												decoration: BoxDecoration(
													shape: BoxShape.circle,
													color: FlutterFlowTheme.of(context).primaryText,
												),
												child: Icon(
													Icons.camera_alt,
													size: 16,
													color: FlutterFlowTheme.of(context).primaryBackground,
												),
											),
										),
									],
								),
							),
						),
						Expanded(
							flex: 4,
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Expanded(
										flex: 2,
										child: SizedBox(
											child: Align(
												alignment: Alignment.centerLeft,
												child: AutoSizeText(
													currentUserDisplayName,
													minFontSize: 12,
													style:
													FlutterFlowTheme.of(context).bodyMedium.override(
														fontFamily: 'Outfit',
														color: FlutterFlowTheme.of(context)
																.primaryBackground,
														fontSize: 20,
													),
												),
											),
										),
									),
									Expanded(
										child: SizedBox(
											child: Align(
												alignment: Alignment.centerLeft,
												child: AutoSizeText(
													currentUserEmail,
													minFontSize: 8,
													style:
													FlutterFlowTheme.of(context).bodyMedium.override(
														fontFamily: 'Outfit',
														color: FlutterFlowTheme.of(context).primary,
													),
												),
											),
										),
									),
								].divide(const SizedBox(height: 10)),
							),
						)
					].divide(const SizedBox(width: 10)),
				),
			),
		);
	}

	Future<void> resetPassword() async {
		isSendingEmail.value = true;
		await authManager.resetPassword(
			email: currentUserEmail,
			context: context,
		);
		isSendingEmail.value = false;
	}

	void showPfp() {
		context.pushNamed(
			'Gallery',
			queryParameters: {
				'index': serializeParam(
					0,
					ParamType.int,
				),
				'images': serializeParam(
					[currentUserPhoto],
					ParamType.String,
					isList: true,
				),
			}.withoutNulls,
		);
	}

	Widget labelForReverseCredits() {
		return SizedBox(
			width: MediaQuery.of(context).size.width,
			height: 20,
			child: Align(
				alignment: Alignment.centerLeft,
				child: Text(
					'Seu valor em reais de Reverse Credits: ',
					style: FlutterFlowTheme.of(context).bodyMedium.override(
						fontFamily: 'Readex Pro',
						fontSize: 14,
						color: FlutterFlowTheme.of(context).tertiary,
					),
				),
			),
		);
	}

	Future<void> changeUserPfp() async {
		String? uploadedUrl = await uploadFileToStorage();

		if (uploadedUrl != null) {
			if (currentUserPhoto != FFAppState().defaultPfp) {
				await deletePastImage();
			}
			await applyNewUserPfp(uploadedUrl);
		}
		isUploadingPfp.value = false;
	}

	Future<void> applyNewUserPfp(String newUrl) async {
		await currentUserReference!.update(createUsersRecordData(
			photoUrl: newUrl,
		));
	}

	Future<String?> uploadFileToStorage() async {
		String? uploadedUrl;

		final selectedMedia = await selectMediaWithSourceBottomSheet(
			context: context,
			maxWidth: 300.00,
			maxHeight: 300.00,
			imageQuality: 100,
			allowPhoto: true,
		);
		isUploadingPfp.value = true;
		if (selectedMedia != null &&
				selectedMedia
						.every((m) => validateFileFormat(m.storagePath, context))) {
			var selectedUploadedFiles = <FFUploadedFile>[];
			List<Object> downloadUrls = <String>[];
			try {
				selectedUploadedFiles = selectedMedia
						.map((m) => FFUploadedFile(
					name: m.storagePath.split('/').last,
					bytes: m.bytes,
					height: m.dimensions?.height,
					width: m.dimensions?.width,
					blurHash: m.blurHash,
				))
						.toList();
				downloadUrls = (await Future.wait(
					selectedMedia.map(
								(m) async => await uploadData(m.storagePath, m.bytes),
					),
				))
						.where((u) => u != null)
						.map((u) => u!)
						.toList();
			} catch (e) {
				print(e);
			}
			if (selectedUploadedFiles.length == selectedMedia.length &&
					downloadUrls.length == selectedMedia.length) {
				uploadedUrl = downloadUrls.first as String;
				return uploadedUrl;
			} else {
				return null;
			}
		}
		return null;
	}

	Future<void> deletePastImage() async {
		try {
			await (deleteImagesFromStorage([currentUserPhoto]));
		} catch (e) {
			print(e);
		}
	}
}

class UserDeletionUI extends StatefulWidget {
	final String message;
	final double currentProgress;

	const UserDeletionUI({
		super.key,
		required this.message,
		required this.currentProgress,
	});

	@override
	State<StatefulWidget> createState() => UserDeletionIUState();
}

class UserDeletionIUState extends State<UserDeletionUI> {
	@override
	Widget build(BuildContext context) {
		return SizedBox(
			width: MediaQuery.of(context).size.width,
			height: MediaQuery.of(context).size.height,
			child: Column(
				mainAxisSize: MainAxisSize.max,
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					Lottie.asset(
						'assets/lottie_animations/deletingUser.json',
						width: MediaQuery.of(context).size.width * 0.8,
						fit: BoxFit.cover,
						frameRate: const FrameRate(120),
						animate: true,
					),
					Text(
						'Excluindo sua conta',
						style: FlutterFlowTheme.of(context).bodyMedium.override(
							fontFamily: 'Readex Pro',
							fontSize: 24,
							fontWeight: FontWeight.bold,
						),
					),
					Text(
						'Este processo pode levar alguns minutos\nNão saia do aplicativo',
						textAlign: TextAlign.center,
						style: FlutterFlowTheme.of(context).bodyMedium.override(
							fontFamily: 'Readex Pro',
							fontSize: 13,
							color: FlutterFlowTheme.of(context).secondaryText,
						),
					),
					const SizedBox(height: 30),
					Padding(
						padding: const EdgeInsets.only(left: 40, right: 40),
						child: TweenAnimationBuilder(
							tween: Tween<double>(begin: 0, end: widget.currentProgress),
							duration: const Duration(milliseconds: 500),
							// Adjust this duration as needed
							builder: (context, double value, child) {
								return LinearProgressIndicator(
									value: value, // This smoothly updates the progress
									backgroundColor: FlutterFlowTheme.of(context).primaryText,
									valueColor: AlwaysStoppedAnimation<Color>(
											FlutterFlowTheme.of(context).secondary),
								);
							},
						),
					),
					Text(
						widget.message,
						style: FlutterFlowTheme.of(context).bodyMedium.override(
							fontFamily: 'Readex Pro',
							fontSize: 15,
							fontWeight: FontWeight.normal,
						),
					)
				].divide(const SizedBox(height: 10)),
			),
		);
	}
}

class NotificationsSection extends StatelessWidget{
	final ValueNotifier<bool?> initialValue;
	final ValueNotifier<bool> isUpdating = ValueNotifier(false);

	NotificationsSection({
		super.key,
		required this.initialValue,
	});

	@override
	Widget build(BuildContext context) {
		print(initialValue);
		return SizedBox(
			width: MediaQuery.of(context).size.width,
			height: 70,
			child: Padding(
				padding: const EdgeInsets.only(left: 24, right: 24),
				child: Row(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: [
						Row(
							children: [
								Icon(
									Icons.notifications,
									color: FlutterFlowTheme.of(context).primaryText,
									size: 24,
								),
								Text(
									'Notificações',
									style: FlutterFlowTheme.of(context).bodyMedium.override(
										fontFamily: 'Readex Pro',
									),
								),
							].divide(const SizedBox(width: 50)),
						),
						ValueListenableBuilder(
								valueListenable: isUpdating,
								builder: (context, value, child){
									if(value){
										return const components.LoadingIcon();
									}
									return ValueListenableBuilder(
											valueListenable: initialValue,
											builder: (context, value, child){
												return Switch.adaptive(
													value: value!,
													onChanged: (newValue) async {
														if(newValue == initialValue.value) return;

														isUpdating.value = true;
														if(newValue){
															await _allowNotifications();
														} else{
															await _disableNotifications();
														}

														await Future.delayed(const Duration(milliseconds: 3000));//evita spam
														isUpdating.value = false;
														await Future.delayed(const Duration(milliseconds: 100)); //mantem a animacao do switch
														initialValue.value = newValue;
													},
													activeColor: FlutterFlowTheme.of(context).primary,
													activeTrackColor: FlutterFlowTheme.of(context).tertiary,
													inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
													inactiveThumbColor: FlutterFlowTheme.of(context).secondaryBackground,
												);
											}
									);
								}
						)
					],
				),
			),
		);
	}

	Future<void> _allowNotifications() async {
		await currentUserReference!.update({
			'allowed_notifications' : true,
		});
		await FirebaseApi.initNotifications();
	}
	Future<void> _disableNotifications() async {
		await currentUserReference!.update({
			'allowed_notifications' : false,
		});
		await FirebaseApi.disableNotifications();
	}
}

class DeleteAccountConfirmationDialog extends StatefulWidget {
	const DeleteAccountConfirmationDialog({super.key});

	@override
	State<StatefulWidget> createState() => DeleteAccountConfirmationDialogState();
}

class DeleteAccountConfirmationDialogState
		extends State<DeleteAccountConfirmationDialog> {
	final controller = TextEditingController();
	final focusNode = FocusNode();

	final ValueNotifier<bool> userTypedExcluir = ValueNotifier(false);

	@override
	void dispose() {
		super.dispose();
		controller.dispose();
		focusNode.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return SizedBox(
			child: Container(
				width: MediaQuery.of(context).size.width * 0.8,
				constraints: BoxConstraints(
					maxHeight: MediaQuery.of(context).size.height * 0.7,
				),
				decoration: BoxDecoration(
					color: FlutterFlowTheme.of(context).primaryBackground,
					borderRadius: BorderRadius.circular(12),
				),
				child: Padding(
					padding: const EdgeInsets.all(12),
					child: SingleChildScrollView(
						child: Column(
							children: [
								Row(
									mainAxisAlignment: MainAxisAlignment.center,
									children: [
										Text(
											'ATENÇÃO',
											style: FlutterFlowTheme.of(context).bodyMedium.override(
												fontFamily: 'Readex Pro',
												fontSize: 24,
												fontWeight: FontWeight.bold,
												color: FlutterFlowTheme.of(context).error,
											),
										),
										Icon(
											Icons.warning,
											color: FlutterFlowTheme.of(context).error,
											size: 30,
										),
									].divide(const SizedBox(width: 10)),
								),
								Text(
									'Você está prestes a excluir sua conta permanentemente. Esta ação não pode ser desfeita e todas as suas informações serão apagadas incluindo seus Reverse Credits',
									textAlign: TextAlign.justify,
									style: FlutterFlowTheme.of(context).bodyMedium.override(
										fontFamily: 'Readex Pro',
										color: FlutterFlowTheme.of(context).alternate,
									),
								),
								Text(
									'Para prosseguir com a exclusão da sua conta, digite \"EXCLUIR\" abaixo:',
									textAlign: TextAlign.justify,
									style: FlutterFlowTheme.of(context).bodyMedium.override(
										fontFamily: 'Readex Pro',
										fontWeight: FontWeight.bold,
										color: FlutterFlowTheme.of(context).primaryText,
									),
								),
								TextFormField(
									controller: controller,
									focusNode: focusNode,
									autofocus: false,
									obscureText: false,
									onChanged: (_) => EasyDebounce.debounce(
										'controller',
										const Duration(milliseconds: 1),
										hasUserTypedExcluir,
									),
									decoration: InputDecoration(
										isDense: true,
										labelStyle:
										FlutterFlowTheme.of(context).labelMedium.override(
											fontFamily: 'Readex Pro',
											letterSpacing: 0.0,
										),
										enabledBorder: UnderlineInputBorder(
											borderSide: BorderSide(
												color: FlutterFlowTheme.of(context).secondaryBackground,
												width: 1,
											),
											borderRadius: BorderRadius.circular(0),
										),
										focusedBorder: UnderlineInputBorder(
											borderSide: BorderSide(
												color: FlutterFlowTheme.of(context).primaryText,
												width: 1,
											),
											borderRadius: BorderRadius.circular(0),
										),
										errorBorder: UnderlineInputBorder(
											borderSide: BorderSide(
												color: FlutterFlowTheme.of(context).error,
												width: 1,
											),
											borderRadius: BorderRadius.circular(0),
										),
										focusedErrorBorder: UnderlineInputBorder(
											borderSide: BorderSide(
												color: FlutterFlowTheme.of(context).error,
												width: 1,
											),
											borderRadius: BorderRadius.circular(0),
										),
									),
									style: FlutterFlowTheme.of(context).bodyMedium.override(
										fontFamily: 'Readex Pro',
										color: FlutterFlowTheme.of(context).primaryText,
									),
								),
								SizedBox(
									width: MediaQuery.of(context).size.width * 0.8,
									child: ValueListenableBuilder(
										valueListenable: userTypedExcluir,
										builder: (context, value, child) {
											return FFButtonWidget(
												onPressed:
												value ? () => Navigator.pop(context, true) : null,
												text: 'Excluir minha conta',
												options: FFButtonOptions(
													padding: const EdgeInsetsDirectional.fromSTEB(
															16, 0, 16, 0),
													iconPadding:
													const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
													color: FlutterFlowTheme.of(context).error,
													textStyle:
													FlutterFlowTheme.of(context).titleSmall.override(
														fontFamily: 'Readex Pro',
														color: FlutterFlowTheme.of(context)
																.primaryBackground,
													),
													elevation: 0,
													borderRadius: BorderRadius.circular(12),
													disabledColor:
													FlutterFlowTheme.of(context).secondaryBackground,
													disabledTextColor:
													FlutterFlowTheme.of(context).primaryBackground,
												),
											);
										},
									),
								),
							].divide(const SizedBox(height: 30)),
						),
					),
				),
			),
		);
	}

	void hasUserTypedExcluir() {
		if (controller.text == 'EXCLUIR') {
			userTypedExcluir.value = true;
		} else {
			userTypedExcluir.value = false;
		}
	}
}

class ProfileOption extends StatelessWidget {
	const ProfileOption({
		super.key,
		this.parentFunc,
		this.title,
		this.icon,
	});

	final dynamic parentFunc;
	final String? title;
	final IconData? icon;

	@override
	Widget build(BuildContext context) {
		return InkWell(
			onTap: parentFunc ?? () => (),
			child: SizedBox(
				width: MediaQuery.of(context).size.width,
				height: 70,
				child: Padding(
					padding: const EdgeInsets.only(left: 24, right: 24),
					child: Row(
						children: [
							Icon(
								icon,
								color: FlutterFlowTheme.of(context).primaryText,
								size: 24,
							),
							Text(
								title!,
								style: FlutterFlowTheme.of(context).bodyMedium.override(
									fontFamily: 'Readex Pro',
									letterSpacing: 0.0,
								),
							),
						].divide(const SizedBox(width: 50)),
					),
				),
			),
		);
	}
}
