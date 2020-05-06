import 'package:flutter/material.dart';
import 'package:flutterworldexchangerates/blocs/currency_list_bloc.dart';
import 'package:flutterworldexchangerates/models/currency_response.dart';
import 'package:flutterworldexchangerates/services/repository.dart';

class AllCurrenciesWidget extends StatefulWidget {

  AllCurrenciesWidget(this._repository);

  final Repository _repository;

  @override
  _AllCurrenciesWidgetState createState() => _AllCurrenciesWidgetState();
}

class _AllCurrenciesWidgetState extends State<AllCurrenciesWidget> {
  CurrencyListBloc _currencyListBloc;

  @override
  void initState() {
    _currencyListBloc = CurrencyListBloc(widget._repository);
    _currencyListBloc.loadCurrencies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    child: StreamBuilder<CurrencyListState>(
        initialData: CurrencyListLoadingState(),
        stream: _currencyListBloc.currencyList,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state is CurrencyListLoadingState) {
            return _buildLoading();
          } 
          if (state is CurrencyListErrorState) {
            return _buildError(state);
          }
          return _buildBody(state);
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildBody(CurrencyListDataState state) {
    if (state == null) {
      return _buildError(CurrencyListErrorState("No currencies available. Please try again later."));
    }
    return _getListView(state.currencies);
  }

  ListView _getListView(List<Currency> currencyList) => ListView.builder(
      itemCount: currencyList.length,
      itemBuilder: (BuildContext context, int position) {
        return _getRow(currencyList[position]);
      });

  Widget _getRow(Currency currency) {
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

  Widget _buildError(CurrencyListErrorState error) {
    return Center(
      child: Text(
        error.error as String,
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
