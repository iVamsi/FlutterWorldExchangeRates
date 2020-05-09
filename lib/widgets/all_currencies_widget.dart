import 'package:flutter/material.dart';
import 'package:flutterworldexchangerates/blocs/currency_list_bloc.dart';
import 'package:flutterworldexchangerates/models/currency_entity.dart';
import 'package:flutterworldexchangerates/services/result.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class AllCurrenciesWidget extends StatefulWidget {

  @override
  _AllCurrenciesWidgetState createState() => _AllCurrenciesWidgetState();
}

class _AllCurrenciesWidgetState extends State<AllCurrenciesWidget> {
  CurrencyListBloc _currencyListBloc;

  @override
  void didChangeDependencies() {
    _currencyListBloc = BlocProvider.of<CurrencyListBloc>(context);
    _currencyListBloc.loadCurrencies();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    child: StreamBuilder<Result<List<CurrencyEntity>>>(
        initialData: LoadingState(),
        stream: _currencyListBloc.currencyListStream,
        builder: (context, snapshot) {
          final result = snapshot.data;
          if (result is LoadingState) {
            return _buildLoading();
          } 
          if (result is ErrorResult) {
            return _buildError(result as ErrorResult);
          }
          return _buildBody(result as SuccessResult);
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildBody(SuccessResult result) {
    if (result == null) {
      return _buildError(ErrorResult("No currencies available. Please try again later."));
    }
    return _getListView(result.value);
  }

  ListView _getListView(List<CurrencyEntity> currencyList) => ListView.builder(
      itemCount: currencyList.length,
      itemBuilder: (BuildContext context, int position) {
        return _getRow(currencyList[position]);
      });

  Widget _getRow(CurrencyEntity currency) {
    return Card(
      elevation: 4.0,
      child: ListTile(
        title: Text(
          "${currency.currencyId}",
        ),
        subtitle: Text(
          "${currency.currencyValue}",
        ),
      ),
    );
  }

  Widget _buildError(ErrorResult error) {
    return Center(
      child: Text(
        error.errorMessage as String,
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
