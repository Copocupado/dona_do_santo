import 'dart:async';

import 'package:dona_do_santo/pages/Cart/cart_widget.dart';
import 'package:dona_do_santo/pages/Gallery.dart';
import 'package:dona_do_santo/pages/reverse/options/historicos/historicos.dart';
import 'package:dona_do_santo/pages/reverse/qr_code/qr_code.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../backend/schema/reverse_store_record.dart';
import '../../pages/notifications/notifications_widget.dart';
import '../../pages/reverse/checkout/checkout.dart';
import '../../pages/reverse/extra_details/extra_details.dart';
import '../../pages/reverse/options/gerenciar_anuncios/gerenciar_anuncios_widget.dart';
import '../../pages/reverse/orders/order.dart';
import '../../pages/reverse/reverse_store_item/reverse_store_item.dart';
import '/auth/base_auth_user_provider.dart';

import '/index.dart';
import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
	AppStateNotifier._();

	static AppStateNotifier? _instance;
	static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

	BaseAuthUser? initialUser;
	BaseAuthUser? user;
	bool showSplashImage = true;
	String? _redirectLocation;

	/// Determines whether the app will refresh and build again when a sign
	/// in or sign out happens. This is useful when the app is launched or
	/// on an unexpected logout. However, this must be turned off when we
	/// intend to sign in/out and then navigate or perform any actions after.
	/// Otherwise, this will trigger a refresh and interrupt the action(s).
	bool notifyOnAuthChange = true;

	bool get loading => user == null || showSplashImage;
	bool get loggedIn => user?.loggedIn ?? false;
	bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
	bool get shouldRedirect => loggedIn && _redirectLocation != null;

	String getRedirectLocation() => _redirectLocation!;
	bool hasRedirect() => _redirectLocation != null;
	void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
	void clearRedirectLocation() => _redirectLocation = null;

	/// Mark as not needing to notify on a sign in / out when we intend
	/// to perform subsequent actions (such as navigation) afterwards.
	void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

	void update(BaseAuthUser newUser) {
		final shouldUpdate =
				user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
		initialUser ??= newUser;
		user = newUser;
		// Refresh the app on auth change unless explicitly marked otherwise.
		// No need to update unless the user has changed.
		if (notifyOnAuthChange && shouldUpdate) {
			notifyListeners();
		}
		// Once again mark the notifier as needing to update on auth change
		// (in order to catch sign in / out events).
		updateNotifyOnAuthChange(true);
	}

	void stopShowingSplashImage() {
		showSplashImage = false;
		notifyListeners();
	}
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
	initialLocation: '/',
	debugLogDiagnostics: true,
	refreshListenable: appStateNotifier,
	errorBuilder: (context, state) =>
	appStateNotifier.loggedIn ? const NavBarPage() : const LoginWidget(),
	routes: [
		FFRoute(
			name: '_initialize',
			path: '/',
			builder: (context, _) =>
			appStateNotifier.loggedIn ? const NavBarPage() : const LoginWidget(),
		),
		FFRoute(
			name: 'HomePage',
			requireAuth: true,
			path: '/homePage',
			builder: (context, params) => params.isEmpty
					? const NavBarPage(initialPage: 'HomePage')
					: HomePageWidget(),
		),
		FFRoute(
			name: 'Login',
			path: '/login',
			builder: (context, params) => const LoginWidget(),
		),
		FFRoute(
			name: 'Reverse',
			requireAuth: true,
			path: '/reverse',
			builder: (context, params) => params.isEmpty
					? const NavBarPage(initialPage: 'Reverse')
					: const ReverseWidget(),
		),
		FFRoute(
			name: 'Perfil',
			requireAuth: true,
			path: '/perfil',
			builder: (context, params) => params.isEmpty
					? const NavBarPage(initialPage: 'Perfil')
					: const PerfilWidget(),
		),
		FFRoute(
			name: 'SignUp',
			path: '/signUp',
			builder: (context, params) => const SignUpWidget(),
		),
		FFRoute(
			name: 'AboutReverse',
			requireAuth: true,
			path: '/aboutReverse',
			builder: (context, params) => const AboutReverseWidget(),
		),
		FFRoute(
			name: 'DuvidasFrequentes',
			requireAuth: true,
			path: '/duvidasFrequentes',
			builder: (context, params) => DuvidasFrequentesWidget(),
		),
		FFRoute(
			name: 'BazarSolidario',
			requireAuth: true,
			path: '/bazarSolidario',
			builder: (context, params) => BazarSolidarioWidget(),
		),
		FFRoute(
			name: 'ResetPassword',
			path: '/resetPassword',
			builder: (context, params) => const ResetPasswordWidget(),
		),
		FFRoute(
			name: 'CreateAnuncio',
			path: '/createAnuncio',
			builder: (context, params) => CreateAnuncioWidget(
				solicitacao: params.getParam(
					'solicitacao',
					ParamType.DocumentReference,
					isList: false,
					collectionNamePath: ['solicitacoes'],
				),
				reverseStoreDoc: params.getParam(
					'reverseStoreDoc',
					ParamType.DocumentReference,
					isList: false,
					collectionNamePath: ['reverse_store'],
				),
			),
		),
		FFRoute(
			name: 'Notifications',
			requireAuth: true,
			path: '/notifications',
			builder: (context, params) => NotificationsWidget(),
		),
		FFRoute(
			name: 'GerenciarAnuncios',
			requireAuth: true,
			path: '/gerenciarAnuncios',
			builder: (context, params) => const GerenciarAnunciosWidget(),
		),
		FFRoute(
			name: 'ReverseStoreItem',
			requireAuth: true,
			path: '/reverseStoreItem',
			builder: (context, params) => ReverseStoreItem(
				solicitacao: params.getParam(
					'solicitacao',
					ParamType.DocumentReference,
					isList: false,
					collectionNamePath: ['solicitacoes'],
				),
				reverseStoreDoc: params.getParam(
					'reverseStoreDoc',
					ParamType.DocumentReference,
					isList: false,
					collectionNamePath: ['reverse_store'],
				),
				novidade: params.getParam(
					'novidade',
					ParamType.DocumentReference,
					isList: false,
					collectionNamePath: ['novidades'],
				),
			),
		),
		FFRoute(
			name: 'Gallery',
			requireAuth: true,
			path: '/gallery',
			builder: (context, params) => GalleryWidget(
				index: params.getParam(
					'index',
					ParamType.int,
				),
				images: params.getParam<String>(
					'images',
					ParamType.String,
					isList: true,
				),
			),
		),
		FFRoute(
			name: 'Favs',
			requireAuth: true,
			path: '/favs',
			builder: (context, params) => const CartWidget(),
		),
		FFRoute(
			name: 'ExtraDetails',
			requireAuth: true,
			path: '/extra_details',
			builder: (context, params) => ExtraDetails(
				itemsList: params.getParam<ReverseStoreRecord>(
					'itemsList',
					ParamType.Document,
					isList: true,
				),
			),
			asyncParams: {
				'items':
				getDocList(['reverse_store'], ReverseStoreRecord.fromSnapshot),
				'doc': getDoc(['reverse_store'], ReverseStoreRecord.fromSnapshot),
			},
			/*builder: (context, params) => PerfilWidget(
				doc: params.getParam(
					'doc',
					ParamType.Document,
				),
			),*/
		),
		FFRoute(
			name: 'Checkout',
			requireAuth: true,
			path: '/checkout',
			builder: (context, params) => Checkout(
				itemsList: params.getParam<ReverseStoreRecord>(
					'itemsList',
					ParamType.Document,
					isList: true,
				),
				address: params.getParam<String>(
					'address',
					ParamType.String,
					isList: false,
				),
				image: params.getParam<String>(
					'image',
					ParamType.String,
					isList: false,
				),
				formattedAddress: params.getParam<String>(
					'formattedAddress',
					ParamType.String,
					isList: false,
				),
				cpf: params.getParam<String>(
					'cpf',
					ParamType.String,
					isList: false,
				),
			),
			asyncParams: {
				'items': getDocList(['reverse_store'], ReverseStoreRecord.fromSnapshot),
			},
		),
		FFRoute(
			name: 'QrCode',
			requireAuth: true,
			path: '/qrcode',
			builder: (context, params) => QrCodeView(
				qrcode: params.getParam<String>(
					'qrcode',
					ParamType.String,
					isList: false,
				),
			),
		),
		FFRoute(
			name: 'History',
			requireAuth: true,
			path: '/history',
			builder: (context, params) => Historicos(
				shouldQueryAsBuyer: params.getParam<bool>(
					'shouldQueryAsBuyer',
					ParamType.bool,
					isList: false,
				),
			),
		),
		FFRoute(
			name: 'Order',
			requireAuth: true,
			path: '/order',
			builder: (context, params) => Order(
				pedido: params.getParam(
					'pedido',
					ParamType.DocumentReference,
					isList: false,
					collectionNamePath: ['pedidos'],
				),
			),
		),
	].map((r) => r.toRoute(appStateNotifier)).toList(),
);

extension NavParamExtensions on Map<String, String?> {
	Map<String, String> get withoutNulls => Map.fromEntries(
		entries
				.where((e) => e.value != null)
				.map((e) => MapEntry(e.key, e.value!)),
	);
}

extension NavigationExtensions on BuildContext {
	void goNamedAuth(
			String name,
			bool mounted, {
				Map<String, String> pathParameters = const <String, String>{},
				Map<String, String> queryParameters = const <String, String>{},
				Object? extra,
				bool ignoreRedirect = false,
			}) =>
			!mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
					? null
					: goNamed(
				name,
				pathParameters: pathParameters,
				queryParameters: queryParameters,
				extra: extra,
			);

	void pushNamedAuth(
			String name,
			bool mounted, {
				Map<String, String> pathParameters = const <String, String>{},
				Map<String, String> queryParameters = const <String, String>{},
				Object? extra,
				bool ignoreRedirect = false,
			}) =>
			!mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
					? null
					: pushNamed(
				name,
				pathParameters: pathParameters,
				queryParameters: queryParameters,
				extra: extra,
			);

	void safePop() {
		// If there is only one route on the stack, navigate to the initial
		// page instead of popping.
		if (canPop()) {
			pop();
		} else {
			go('/');
		}
	}
}

extension GoRouterExtensions on GoRouter {
	AppStateNotifier get appState => AppStateNotifier.instance;
	void prepareAuthEvent([bool ignoreRedirect = false]) =>
			appState.hasRedirect() && !ignoreRedirect
					? null
					: appState.updateNotifyOnAuthChange(false);
	bool shouldRedirect(bool ignoreRedirect) =>
			!ignoreRedirect && appState.hasRedirect();
	void clearRedirectLocation() => appState.clearRedirectLocation();
	void setRedirectLocationIfUnset(String location) =>
			appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
	Map<String, dynamic> get extraMap =>
			extra != null ? extra as Map<String, dynamic> : {};
	Map<String, dynamic> get allParams => <String, dynamic>{}
		..addAll(pathParameters)
		..addAll(uri.queryParameters)
		..addAll(extraMap);
	TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
			? extraMap[kTransitionInfoKey] as TransitionInfo
			: TransitionInfo.appDefault();
}

class FFParameters {
	FFParameters(this.state, [this.asyncParams = const {}]);

	final GoRouterState state;
	final Map<String, Future<dynamic> Function(String)> asyncParams;

	Map<String, dynamic> futureParamValues = {};

	// Parameters are empty if the params map is empty or if the only parameter
	// present is the special extra parameter reserved for the transition info.
	bool get isEmpty =>
			state.allParams.isEmpty ||
					(state.allParams.length == 1 &&
							state.extraMap.containsKey(kTransitionInfoKey));
	bool isAsyncParam(MapEntry<String, dynamic> param) =>
			asyncParams.containsKey(param.key) && param.value is String;
	bool get hasFutures => state.allParams.entries.any(isAsyncParam);
	Future<bool> completeFutures() => Future.wait(
		state.allParams.entries.where(isAsyncParam).map(
					(param) async {
				final doc = await asyncParams[param.key]!(param.value)
						.onError((_, __) => null);
				if (doc != null) {
					futureParamValues[param.key] = doc;
					return true;
				}
				return false;
			},
		),
	).onError((_, __) => [false]).then((v) => v.every((e) => e));

	dynamic getParam<T>(
			String paramName,
			ParamType type, {
				bool isList = false,
				List<String>? collectionNamePath,
			}) {
		if (futureParamValues.containsKey(paramName)) {
			return futureParamValues[paramName];
		}
		if (!state.allParams.containsKey(paramName)) {
			return null;
		}
		final param = state.allParams[paramName];
		// Got parameter from `extras`, so just directly return it.
		if (param is! String) {
			return param;
		}
		// Return serialized value.
		return deserializeParam<T>(
			param,
			type,
			isList,
			collectionNamePath: collectionNamePath,
		);
	}
}

class FFRoute {
	const FFRoute({
		required this.name,
		required this.path,
		required this.builder,
		this.requireAuth = false,
		this.asyncParams = const {},
		this.routes = const [],
	});

	final String name;
	final String path;
	final bool requireAuth;
	final Map<String, Future<dynamic> Function(String)> asyncParams;
	final Widget Function(BuildContext, FFParameters) builder;
	final List<GoRoute> routes;

	GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
		name: name,
		path: path,
		redirect: (context, state) {
			if (appStateNotifier.shouldRedirect) {
				final redirectLocation = appStateNotifier.getRedirectLocation();
				appStateNotifier.clearRedirectLocation();
				return redirectLocation;
			}

			if (requireAuth && !appStateNotifier.loggedIn) {
				appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
				return '/login';
			}
			return null;
		},
		pageBuilder: (context, state) {
			fixStatusBarOniOS16AndBelow(context);
			final ffParams = FFParameters(state, asyncParams);
			final page = ffParams.hasFutures
					? FutureBuilder(
				future: ffParams.completeFutures(),
				builder: (context, _) => builder(context, ffParams),
			)
					: builder(context, ffParams);
			final child = appStateNotifier.loading
					? Center(
				child: SizedBox(
					width: 50.0,
					height: 50.0,
					child: CircularProgressIndicator(
						valueColor: AlwaysStoppedAnimation<Color>(
							FlutterFlowTheme.of(context).tertiary,
						),
					),
				),
			)
					: page;

			final transitionInfo = state.transitionInfo;
			return transitionInfo.hasTransition
					? CustomTransitionPage(
				key: state.pageKey,
				child: child,
				transitionDuration: transitionInfo.duration,
				transitionsBuilder:
						(context, animation, secondaryAnimation, child) =>
						PageTransition(
							type: transitionInfo.transitionType,
							duration: transitionInfo.duration,
							reverseDuration: transitionInfo.duration,
							alignment: transitionInfo.alignment,
							child: child,
						).buildTransitions(
							context,
							animation,
							secondaryAnimation,
							child,
						),
			)
					: MaterialPage(key: state.pageKey, child: child);
		},
		routes: routes,
	);
}

class TransitionInfo {
	const TransitionInfo({
		required this.hasTransition,
		this.transitionType = PageTransitionType.fade,
		this.duration = const Duration(milliseconds: 300),
		this.alignment,
	});

	final bool hasTransition;
	final PageTransitionType transitionType;
	final Duration duration;
	final Alignment? alignment;

	static TransitionInfo appDefault() => const TransitionInfo(hasTransition: false);
}

class RootPageContext {
	const RootPageContext(this.isRootPage, [this.errorRoute]);
	final bool isRootPage;
	final String? errorRoute;

	static bool isInactiveRootPage(BuildContext context) {
		final rootPageContext = context.read<RootPageContext?>();
		final isRootPage = rootPageContext?.isRootPage ?? false;
		final location = GoRouterState.of(context).uri.toString();
		return isRootPage &&
				location != '/' &&
				location != rootPageContext?.errorRoute;
	}

	static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
		value: RootPageContext(true, errorRoute),
		child: child,
	);
}

extension GoRouterLocationExtension on GoRouter {
	String getCurrentLocation() {
		final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
		final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
				? lastMatch.matches
				: routerDelegate.currentConfiguration;
		return matchList.uri.toString();
	}
}
