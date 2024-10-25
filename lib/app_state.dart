import 'package:dona_do_santo/auth/firebase_auth/auth_util.dart';
import 'package:dona_do_santo/backend/schema/notifications_record.dart';
import 'package:dona_do_santo/backend/schema/pedidos_record.dart';
import 'package:dona_do_santo/backend/schema/relatorio_reverse_credits_record.dart';
import 'package:dona_do_santo/backend/schema/reverse_store_record.dart';
import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'backend/schema/structs/favs_by_user_struct.dart';
import 'flutter_flow/request_manager.dart';
import '/backend/backend.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';

class FFAppState extends ChangeNotifier {
	static FFAppState _instance = FFAppState._internal();

	factory FFAppState() {
		return _instance;
	}

	FFAppState._internal();

	static void reset() {
		_instance = FFAppState._internal();
	}

	Future initializePersistedState() async {
		prefs = await SharedPreferences.getInstance();
	}
	void initializeFavedItemsMap(){
		print('currently authed user: $currentUserReference');
		_safeInit(() {
			_favsByUserMap = prefs
					.getStringList('ff_favsByUserMap')
					?.map((x) {
				try {
					return FavsByUserStruct.fromJson(jsonDecode(x));
				} catch (e) {
					print("Can't decode persisted data type. Error: $e.");
					return null;
				}
			})
					.withoutNulls
					.toList() ??
					_favsByUserMap;
		});

		for(var item in _favsByUserMap){
			if(item.user == currentUserReference){
				userFavedItems = item.reverseStoreItems;
			}
		}
		try {
			print('Faved Items by the user: $userFavedItems');
		} catch (e) {
			addToFavsByUserMap(FavsByUserStruct(user: currentUserReference, reverseStoreItems: ValueNotifier<List<DocumentReference>?>([])));
			userFavedItems = ValueNotifier<List<DocumentReference>?>([]);
		}
	}

	String defaultPfp = 'https://firebasestorage.googleapis.com/v0/b/dona-do-santo-ujhc0y.appspot.com/o/OwnerFiles%2FdefaultPfp.webp?alt=media&token=43f35518-7f44-444f-a19c-dcf679402767';


	void update(VoidCallback callback) {
		callback();
		notifyListeners();
	}

	late SharedPreferences prefs;
	late ValueNotifier<List<DocumentReference>?> userFavedItems;

	List<FavsByUserStruct> _favsByUserMap = [];
	List<FavsByUserStruct> get favsByUserMap => _favsByUserMap;
	set favsByUserMap(List<FavsByUserStruct> value) {
		_favsByUserMap = value;

		List<String> stringList = value.map((favs) => jsonEncode(favs.toJson())).toList();
		prefs.setStringList('ff_favsByUserMap', stringList);
		print('updated');
	}

	void addToFavsByUserMap(FavsByUserStruct value) {
		favsByUserMap.add(value);
		List<String> stringList = _favsByUserMap.map((favs) => jsonEncode(favs.toJson())).toList();
		prefs.setStringList('ff_favsByUserMap', stringList);
		print('updated');
	}

	void removeFromFavsByUserMap(FavsByUserStruct value) {
		favsByUserMap.remove(value);
		List<String> stringList = _favsByUserMap.map((favs) => jsonEncode(favs.toJson())).toList();
		prefs.setStringList('ff_favsByUserMap', stringList);
		print('updated');
	}

	void removeAtIndexFromFavsByUserMap(int index) {
		favsByUserMap.removeAt(index);
		List<String> stringList = _favsByUserMap.map((favs) => jsonEncode(favs.toJson())).toList();
		prefs.setStringList('ff_favsByUserMap', stringList);
		print('updated');
	}

	void updateFavsByUserMapAtIndex(
			int index,
			FavsByUserStruct Function(FavsByUserStruct) updateFn,
			) {
		favsByUserMap[index] = updateFn(_favsByUserMap[index]);
		List<String> stringList = _favsByUserMap.map((favs) => jsonEncode(favs.toJson())).toList();
		prefs.setStringList('ff_favsByUserMap', stringList);
		print('updated');
	}

	void insertAtIndexInFavsByUserMap(int index, FavsByUserStruct value) {
		favsByUserMap.insert(index, value);
		List<String> stringList = _favsByUserMap.map((favs) => jsonEncode(favs.toJson())).toList();
		prefs.setStringList('ff_favsByUserMap', stringList);
		print('updated');
	}



	final _storeNewsManager = StreamRequestManager<List<NovidadesRecord>>();
	Stream<List<NovidadesRecord>> storeNews({
		String? uniqueQueryKey,
		bool? overrideCache,
		required Stream<List<NovidadesRecord>> Function() requestFn,
	}) =>
			_storeNewsManager.performRequest(
				uniqueQueryKey: uniqueQueryKey,
				overrideCache: overrideCache,
				requestFn: requestFn,
			);
	void clearStoreNewsCache() => _storeNewsManager.clear();
	void clearStoreNewsCacheKey(String? uniqueKey) =>
			_storeNewsManager.clearRequest(uniqueKey);

	final _storeNewsItemManager = StreamRequestManager<NovidadesRecord>();
	Stream<NovidadesRecord> storeNewsItem({
		String? uniqueQueryKey,
		bool? overrideCache,
		required Stream<NovidadesRecord> Function() requestFn,
	}) =>
			_storeNewsItemManager.performRequest(
				uniqueQueryKey: uniqueQueryKey,
				overrideCache: overrideCache,
				requestFn: requestFn,
			);
	void clearStoreNewsItemManagerCache() => _storeNewsItemManager.clear();
	void clearStoreNewsItemManagerCacheKey(String? uniqueKey) =>
			_storeNewsItemManager.clearRequest(uniqueKey);

	final _generalNewsManager = StreamRequestManager<List<NoticiasRecord>>();
	Stream<List<NoticiasRecord>> generalNews({
		String? uniqueQueryKey,
		bool? overrideCache,
		required Stream<List<NoticiasRecord>> Function() requestFn,
	}) =>
			_generalNewsManager.performRequest(
				uniqueQueryKey: uniqueQueryKey,
				overrideCache: overrideCache,
				requestFn: requestFn,
			);
	void clearGeneralNewsCache() => _generalNewsManager.clear();
	void clearGeneralNewsCacheKey(String? uniqueKey) =>
			_generalNewsManager.clearRequest(uniqueKey);

	final _fAQsManager = StreamRequestManager<List<DuvidasFrequentesRecord>>();
	Stream<List<DuvidasFrequentesRecord>> fAQs({
		String? uniqueQueryKey,
		bool? overrideCache,
		required Stream<List<DuvidasFrequentesRecord>> Function() requestFn,
	}) =>
			_fAQsManager.performRequest(
				uniqueQueryKey: uniqueQueryKey,
				overrideCache: overrideCache,
				requestFn: requestFn,
			);
	void clearFAQsCache() => _fAQsManager.clear();
	void clearFAQsCacheKey(String? uniqueKey) =>
			_fAQsManager.clearRequest(uniqueKey);

	final _companyStoresManager =
	StreamRequestManager<List<LojasDaEmpresaRecord>>();
	Stream<List<LojasDaEmpresaRecord>> companyStores({
		String? uniqueQueryKey,
		bool? overrideCache,
		required Stream<List<LojasDaEmpresaRecord>> Function() requestFn,
	}) =>
			_companyStoresManager.performRequest(
				uniqueQueryKey: uniqueQueryKey,
				overrideCache: overrideCache,
				requestFn: requestFn,
			);
	void clearCompanyStoresCache() => _companyStoresManager.clear();
	void clearCompanyStoresCacheKey(String? uniqueKey) =>
			_companyStoresManager.clearRequest(uniqueKey);

	final _storeRecomendationsManager =
	StreamRequestManager<List<RecomendacoesRecord>>();
	Stream<List<RecomendacoesRecord>> storeRecomendations({
		String? uniqueQueryKey,
		bool? overrideCache,
		required Stream<List<RecomendacoesRecord>> Function() requestFn,
	}) =>
			_storeRecomendationsManager.performRequest(
				uniqueQueryKey: uniqueQueryKey,
				overrideCache: overrideCache,
				requestFn: requestFn,
			);
	void clearStoreRecomendationsCache() => _storeRecomendationsManager.clear();
	void clearStoreRecomendationsCacheKey(String? uniqueKey) =>
			_storeRecomendationsManager.clearRequest(uniqueKey);

	final _notificationsManager =
	StreamRequestManager<List<NotificationsRecord>>();
	Stream<List<NotificationsRecord>> storeNotifications({
		String? uniqueQueryKey,
		bool? overrideCache,
		required Stream<List<NotificationsRecord>> Function() requestFn,
	}) =>
			_notificationsManager.performRequest(
				uniqueQueryKey: uniqueQueryKey,
				overrideCache: overrideCache,
				requestFn: requestFn,
			);
	void clearStoreNotificationsCache() => _notificationsManager.clear();
	void clearStoreNotificationsCacheKey(String? uniqueKey) =>
			_notificationsManager.clearRequest(uniqueKey);


	final _requestManager =
	StreamRequestManager<SolicitacoesRecord>();
	Stream<SolicitacoesRecord> storeRequest({
		String? uniqueQueryKey,
		bool? overrideCache,
		required Stream<SolicitacoesRecord> Function() requestFn,
	}) =>
			_requestManager.performRequest(
				uniqueQueryKey: uniqueQueryKey,
				overrideCache: overrideCache,
				requestFn: requestFn,
			);
	void clearStoreRequestCache() => _requestManager.clear();
	void clearStoreRequestCacheKey(String? uniqueKey) =>
			_requestManager.clearRequest(uniqueKey);

	final _requestsManager =
	StreamRequestManager<List<SolicitacoesRecord>>();
	Stream<List<SolicitacoesRecord>> storeRequests({
		String? uniqueQueryKey,
		bool? overrideCache,
		required Stream<List<SolicitacoesRecord>> Function() requestFn,
	}) =>
			_requestsManager.performRequest(
				uniqueQueryKey: uniqueQueryKey,
				overrideCache: overrideCache,
				requestFn: requestFn,
			);
	void clearStoreRequestsCache() => _requestManager.clear();
	void clearStoreRequestsCacheKey(String? uniqueKey) =>
			_requestManager.clearRequest(uniqueKey);


	final _reverseStoreManager =
	StreamRequestManager<List<ReverseStoreRecord>>();
	Stream<List<ReverseStoreRecord>> reverseStoreRequest({
		String? uniqueQueryKey,
		bool? overrideCache,
		required Stream<List<ReverseStoreRecord>> Function() requestFn,
	}) =>
			_reverseStoreManager.performRequest(
				uniqueQueryKey: uniqueQueryKey,
				overrideCache: overrideCache,
				requestFn: requestFn,
			);
	void clearReverseStoreRequestCache() => _requestManager.clear();
	void clearReverseStoreRequestCacheKey(String? uniqueKey) =>
			_requestManager.clearRequest(uniqueKey);

	final _reverseStoreItemManager = StreamRequestManager<ReverseStoreRecord>();
	Stream<ReverseStoreRecord> reverseStoreItem({
		String? uniqueQueryKey,
		bool? overrideCache,
		required Stream<ReverseStoreRecord> Function() requestFn,
	}) =>
			_reverseStoreItemManager.performRequest(
				uniqueQueryKey: uniqueQueryKey,
				overrideCache: overrideCache,
				requestFn: requestFn,
			);
	void clearReverseStoreItemCache() => _reverseStoreItemManager.clear();
	void clearReverseStoreItemCacheKey(String? uniqueKey) =>
			_reverseStoreItemManager.clearRequest(uniqueKey);

	final _userInfoManager = StreamRequestManager<UsersRecord>();
	Stream<UsersRecord> userInfo({
		String? uniqueQueryKey,
		bool? overrideCache,
		required Stream<UsersRecord> Function() requestFn,
	}) =>
			_userInfoManager.performRequest(
				uniqueQueryKey: uniqueQueryKey,
				overrideCache: overrideCache,
				requestFn: requestFn,
			);
	void clearUserInfoCache() => _reverseStoreItemManager.clear();
	void clearUserInfoCacheKey(String? uniqueKey) =>
			_userInfoManager.clearRequest(uniqueKey);

	final _pedidosManager =
	StreamRequestManager<List<PedidosRecord>>();
	Stream<List<PedidosRecord>> pedidosRequest({
		String? uniqueQueryKey,
		bool? overrideCache,
		required Stream<List<PedidosRecord>> Function() requestFn,
	}) =>
			_pedidosManager.performRequest(
				uniqueQueryKey: uniqueQueryKey,
				overrideCache: overrideCache,
				requestFn: requestFn,
			);
	void clearPedidosCache() => _pedidosManager.clear();
	void clearPedidosCacheKey(String? uniqueKey) =>
			_pedidosManager.clearRequest(uniqueKey);

	final _pedidoManager = StreamRequestManager<PedidosRecord>();
	Stream<PedidosRecord> pedidoItem({
		String? uniqueQueryKey,
		bool? overrideCache,
		required Stream<PedidosRecord> Function() requestFn,
	}) =>
			_pedidoManager.performRequest(
				uniqueQueryKey: uniqueQueryKey,
				overrideCache: overrideCache,
				requestFn: requestFn,
			);
	void clearPedidoItemItemCache() => _pedidoManager.clear();
	void clearPedidoItemCacheKey(String? uniqueKey) =>
			_pedidoManager.clearRequest(uniqueKey);


	final _relatoriosReverseCredits = StreamRequestManager<List<RelatorioReverseCreditsRecord>>();
	Stream<List<RelatorioReverseCreditsRecord>> relatorios({
		String? uniqueQueryKey,
		bool? overrideCache,
		required Stream<List<RelatorioReverseCreditsRecord>> Function() requestFn,
	}) => _relatoriosReverseCredits.performRequest(
		uniqueQueryKey: uniqueQueryKey,
		overrideCache: overrideCache,
		requestFn: requestFn,
	);
}

void _safeInit(Function() initializeField) {
	try {
		initializeField();
	} catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
	try {
		await initializeField();
	} catch (_) {}
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
	static final _lock = Lock();

	Future<void> writeSync({required String key, String? value}) async =>
			await _lock.synchronized(() async {
				await write(key: key, value: value);
			});

	void remove(String key) => delete(key: key);

	Future<String?> getString(String key) async => await read(key: key);
	Future<void> setString(String key, String value) async =>
			await writeSync(key: key, value: value);

	Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
	Future<void> setBool(String key, bool value) async =>
			await writeSync(key: key, value: value.toString());

	Future<int?> getInt(String key) async =>
			int.tryParse(await read(key: key) ?? '');
	Future<void> setInt(String key, int value) async =>
			await writeSync(key: key, value: value.toString());

	Future<double?> getDouble(String key) async =>
			double.tryParse(await read(key: key) ?? '');
	Future<void> setDouble(String key, double value) async =>
			await writeSync(key: key, value: value.toString());

	Future<List<String>?> getStringList(String key) async =>
			await read(key: key).then((result) {
				if (result == null || result.isEmpty) {
					return null;
				}
				return const CsvToListConverter()
						.convert(result)
						.first
						.map((e) => e.toString())
						.toList();
			});
	Future<void> setStringList(String key, List<String> value) async =>
			await writeSync(key: key, value: const ListToCsvConverter().convert([value]));
}
