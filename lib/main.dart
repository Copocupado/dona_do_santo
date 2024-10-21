import 'dart:io';
import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/firebase/firebase_config.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'index.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
	print('Handling a background message: ${message.messageId}');
}

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await FirebaseApi.initFirebase();
	FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
	PlatformDispatcher.instance.onError = (error, stack) {
		FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
		return true;
	};
	final AppStateNotifier _appStateNotifier = AppStateNotifier.instance;
	final GoRouter _router = createRouter(_appStateNotifier);

	final appState = FFAppState(); // Initialize FFAppState
	await appState.initializePersistedState();

	Future<void> initPushNotifications() async {
		final firebaseMessaging = FirebaseMessaging.instance;

		await firebaseMessaging.requestPermission(
			alert: true,
			announcement: true,
			badge: true,
			carPlay: true,
			criticalAlert: true,
			provisional: true,
			sound: true,
		);

		void handleMessage(RemoteMessage? message) {
			WidgetsBinding.instance.addPostFrameCallback((_) {
				_router.go('/notifications');
			});
		}

		FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
		// Handle messages when the app is in the foreground
		FirebaseMessaging.onMessage.listen((RemoteMessage message) {
			handleMessage(message);
		});

		// Handle messages when the app is in the background but not terminated
		FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
			handleMessage(message);
		});
	}

	await dotenv.load(fileName: ".env");
	GoRouter.optionURLReflectsImperativeAPIs = true;
	usePathUrlStrategy();
	await initPushNotifications();
	runApp(ChangeNotifierProvider(
		create: (context) => appState,
		child: const MyApp(),
	));

}

class MyApp extends StatefulWidget {
	const MyApp({super.key});

	// This widget is the root of your application.
	@override
	State<MyApp> createState() => _MyAppState();

	static _MyAppState of(BuildContext context) =>
			context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
	Locale? _locale;

	ThemeMode _themeMode = ThemeMode.system;

	late AppStateNotifier _appStateNotifier;
	late GoRouter _router;

	late Stream<BaseAuthUser> userStream;

	final authUserSub = authenticatedUserStream.listen((_) {});
	@override
	void initState() {
		super.initState();
		_appStateNotifier = AppStateNotifier.instance;
		_router = createRouter(_appStateNotifier);
		userStream = donaDoSantoFirebaseUserStream()
			..listen((user) {
				_appStateNotifier.update(user);
			});
		jwtTokenStream.listen((_) {});
		Future.delayed(
			const Duration(milliseconds: 1000),
					() => _appStateNotifier.stopShowingSplashImage(),
		);
	}


	@override
	void dispose() {
		authUserSub.cancel();

		super.dispose();
	}

	void setLocale(String language) {
		setState(() => _locale = createLocale(language));
	}

	void setThemeMode(ThemeMode mode) => setState(() {
		_themeMode = mode;
	});

	@override
	Widget build(BuildContext context) {
		return MaterialApp.router(
			title: 'DonaDoSanto',
			localizationsDelegates: const [
				FFLocalizationsDelegate(),
				GlobalMaterialLocalizations.delegate,
				GlobalWidgetsLocalizations.delegate,
				GlobalCupertinoLocalizations.delegate,
			],
			locale: _locale,
			supportedLocales: const [
				Locale('pt'),
			],
			theme: ThemeData(
				brightness: Brightness.light,
			),
			themeMode: _themeMode,
			routerConfig: _router,
		);
	}
}

class NavBarPage extends StatefulWidget {
	const NavBarPage({super.key, this.initialPage, this.page});

	final String? initialPage;
	final Widget? page;

	@override
	_NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
	String _currentPageName = 'HomePage';
	late Widget? _currentPage;

	@override
	void initState() {
		super.initState();
		_currentPageName = widget.initialPage ?? _currentPageName;
		_currentPage = widget.page;
	}

	@override
	Widget build(BuildContext context) {
		final tabs = {
			'HomePage': HomePageWidget(),
			'Reverse': const ReverseWidget(),
			'Perfil': const PerfilWidget(),
		};
		final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

		return Scaffold(
			body: _currentPage ?? tabs[_currentPageName],
			bottomNavigationBar: GNav(
				selectedIndex: currentIndex,
				onTabChange: (i) => setState(() {
					_currentPage = null;
					_currentPageName = tabs.keys.toList()[i];
				}),
				backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
				color: FlutterFlowTheme.of(context).secondaryText,
				activeColor: FlutterFlowTheme.of(context).primaryText,
				tabBackgroundColor: FlutterFlowTheme.of(context).secondary,
				tabBorderRadius: 100.0,
				tabMargin: const EdgeInsets.all(15.0),
				padding: const EdgeInsets.all(10.0),
				gap: 10.0,
				mainAxisAlignment: MainAxisAlignment.spaceAround,
				duration: const Duration(milliseconds: 500),
				haptic: false,
				tabs: const [
					GButton(
						icon: FontAwesomeIcons.home,
						text: 'Home',
						iconSize: 20.0,
					),
					GButton(
						icon: FontAwesomeIcons.rev,
						text: 'Reverse',
						iconSize: 24.0,
					),
					GButton(
						icon: Icons.person_rounded,
						text: 'Perfil',
						iconSize: 30.0,
					)
				],
			),
		);
	}
}
