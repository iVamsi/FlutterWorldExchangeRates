import 'package:flutter/material.dart';
import 'package:worldexchangerates/blocs/currency_list_bloc.dart';
import 'package:worldexchangerates/constants.dart';
import 'package:worldexchangerates/models/currency_entity.dart';
import 'package:worldexchangerates/services/result.dart';
import 'package:worldexchangerates/widgets/base_alert_dialog.dart';

class AllCurrenciesWidget extends StatefulWidget {
  final CurrencyListBloc bloc;

  AllCurrenciesWidget({@required this.bloc});

  @override
  _AllCurrenciesWidgetState createState() => _AllCurrenciesWidgetState();
}

class _AllCurrenciesWidgetState extends State<AllCurrenciesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<Result<List<CurrencyEntity>>>(
        initialData: LoadingState(),
        stream: widget.bloc.currencyListStream,
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
      return _buildError(
          ErrorResult("No currencies available. Please try again later."));
    }
    return _getListView(result.value);
  }

  ListView _getListView(List<CurrencyEntity> currencyList) => ListView.builder(
      itemCount: currencyList.length,
      itemBuilder: (BuildContext context, int position) {
        return _getRow(context, currencyList[position]);
      });

  Widget _getRow(BuildContext context, CurrencyEntity currency) {
    return Card(
      elevation: 4.0,
      child: ListTile(
        onLongPress: () {
          _showSetOrRemoveFavoriteDialog(context, currency);
        },
        leading: Image(
            image: AssetImage(
                'images/flag_${currency.currencyId.toString().toLowerCase()}.png')),
        title: Text(
          "${currency.currencyId}",
        ),
        subtitle: Text(
          "${currency.currencyName}",
        ),
        trailing: Text(
          currency.currencyValue.toStringAsFixed(3),
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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

  _showSetOrRemoveFavoriteDialog(
      BuildContext context, CurrencyEntity currencyEntity) {
    print("item long pressed");
    if (currencyEntity.currencyFavorite == Constants.FAVORITE_CURRENCY_YES) {
      _showDialog(
          context: context,
          currencyEntity: currencyEntity,
          title: "Remove Favorite?",
          content: "Do you want to remove this currency from Favorites?");
    } else {
      _showDialog(
          context: context,
          currencyEntity: currencyEntity,
          title: "Set Favorite?",
          content: "Do you want to set this currency as Favorite?");
    }
  }

  showAlertDialog(
      {BuildContext context,
      String title,
      String description,
      Function onYesPressed,
      Function onNoPressed,
      String yesButtonText = "Yes",
      String cancelButtonText = "Cancel"}) {
    // set up the buttons
    Widget yesButton = FlatButton(
      child: Text(yesButtonText),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
        onYesPressed();
      },
    );
    Widget cancelButton = FlatButton(
      child: Text(cancelButtonText),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _showDialog(
      {BuildContext context,
      CurrencyEntity currencyEntity,
      String title,
      String content}) {
    showAlertDialog(
        context: context,
        title: title,
        description: content,
        onYesPressed: () {
          _onPressedYes(currencyEntity);
        });
  }

  _onPressedYes(CurrencyEntity currencyEntity) {
    String favorite;
    if (currencyEntity.currencyFavorite == Constants.FAVORITE_CURRENCY_YES) {
      favorite = Constants.FAVORITE_CURRENCY_NO;
    } else {
      favorite = Constants.FAVORITE_CURRENCY_YES;
    }

    CurrencyEntity updatedCurrency = CurrencyEntity(
        currencyId: currencyEntity.currencyId,
        currencyName: currencyEntity.currencyName,
        currencyValue: currencyEntity.currencyValue,
        currencyFavorite: favorite,
        baseCurrency: currencyEntity.baseCurrency);

    widget.bloc.updateCurrency(currencyEntity: updatedCurrency);
    //TODO: Needs optimization. Find a way to refresh the list
    setState(() {
      widget.bloc.loadCurrencies(
          isFavoriteCurrenciesList: currencyEntity.currencyFavorite ==
              Constants.FAVORITE_CURRENCY_YES);
    });
  }
}
