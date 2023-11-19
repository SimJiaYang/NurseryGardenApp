import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/delivery_detail_model.dart';
import 'package:nurserygardenapp/data/model/delivery_model.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/data/repositories/delivery_repo.dart';
import 'package:nurserygardenapp/helper/response_helper.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryProvider extends ChangeNotifier {
  final DeliveryRepo deliveryRepo;
  final SharedPreferences sharedPreferences;

  DeliveryProvider(
      {required this.deliveryRepo, required this.sharedPreferences});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DeliveryModel _deliveryModel = DeliveryModel();
  DeliveryModel get deliveryModel => _deliveryModel;

  List<Delivery> _deliveryList = [];
  List<Delivery> get deliveryList => _deliveryList;

  String _noMoreDataMessage = '';
  String get noMoreDataMessage => _noMoreDataMessage;

  /// ================== DELIVERY LIST ==================
  Future<bool> getDeliveryList(BuildContext context, params,
      {bool isLoadMore = false, bool isLoad = true}) async {
    if (!isLoadMore) {
      _deliveryList = [];
      _noMoreDataMessage = '';
    }

    bool result = false;
    String query = ResponseHelper.buildQuery(params);
    int limit = params['limit'] != null ? int.parse(params['limit']) : 8;

    _isLoading = isLoad;
    notifyListeners();

    ApiResponse apiResponse = await deliveryRepo.getDeliveryList(query);

    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        _deliveryModel = DeliveryModel.fromJson(apiResponse.response!.data);
        _deliveryList = _deliveryModel.data!.delivery ?? [];
        if (_deliveryList.length < limit && limit > 8) {
          _noMoreDataMessage = AppConstants.NO_MORE_DATA;
        }
      }
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  /// ================== DELIVERY DETAIL ==================
  bool _isLoadingDetail = false;
  bool get isLoadingDetail => _isLoadingDetail;
  DeliveryDetailModel _deliveryDetailModel = DeliveryDetailModel();
  DeliveryDetailModel get deliveryDetailModel => _deliveryDetailModel;
  Delivery _deliveryDetail = Delivery();
  Delivery get deliveryDetail => _deliveryDetail;

  Future<bool> getDeliveryDetail(BuildContext context, params) async {
    bool result = false;
    String query = ResponseHelper.buildQuery(params);

    _isLoadingDetail = true;
    notifyListeners();

    ApiResponse apiResponse = await deliveryRepo.getDeliveryDetail(query);

    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        _deliveryDetailModel =
            DeliveryDetailModel.fromJson(apiResponse.response!.data);
        _deliveryDetail = _deliveryDetailModel.delivery ?? Delivery();
      }
    }

    _isLoadingDetail = false;
    notifyListeners();

    return result;
  }
}
