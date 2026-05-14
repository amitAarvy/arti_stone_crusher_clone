// part of 'advertise_bloc.dart';

import 'package:equatable/equatable.dart';

class ChallanEvent extends Equatable{
  const ChallanEvent();

  @override
  List<Object?> get props => [];
}

class SelectTransport extends ChallanEvent{
  final String selectTransport;
  const SelectTransport({required this.selectTransport});

  @override
  List<Object> get props => [selectTransport];
}

class PasswordChange extends ChallanEvent{
  final String password;
  const PasswordChange({required this.password});

  @override
  List<Object> get props => [password];
}

class SelectPlant extends ChallanEvent{
  final String selectPlant;
  const SelectPlant({ required this.selectPlant});

  @override
  List<Object> get props => [selectPlant];
}

class SiteAddress extends ChallanEvent{
  final String siteAddress;
  const SiteAddress({required this.siteAddress});

  @override
  List<Object> get props => [siteAddress];
}

class SelectCompany extends ChallanEvent{
  final String selectCompany;
  const SelectCompany({required this.selectCompany});

  @override
  List<Object> get props => [selectCompany];
}
class SelectSupplier extends ChallanEvent{
  final String selectSupplier;
  const SelectSupplier({required this.selectSupplier});

  @override
  List<Object> get props => [selectSupplier];
}

class SelectParty extends ChallanEvent{
  final String selectParty;
  const SelectParty({required this.selectParty});

  @override
  List<Object> get props => [selectParty];
}

class SelectVehicle extends ChallanEvent{
  final String selectVehicle;
  const SelectVehicle({required this.selectVehicle});

  @override
  List<Object> get props => [selectVehicle];
}

class VehicleNo extends ChallanEvent{
  final String vehicleNo;
  const VehicleNo({required this.vehicleNo});

  @override
  List<Object> get props => [vehicleNo];
}
class SelectTrips extends ChallanEvent{
  final String selectTrips;
  const SelectTrips({required this.selectTrips});

  @override
  List<Object> get props => [selectTrips];
}

class Measurement extends ChallanEvent{
  final String measurement;
  const Measurement({required this.measurement});

  @override
  List<Object> get props => [measurement];
}

class Weight extends ChallanEvent{
  final String weight;
  const Weight({required this.weight});

  @override
  List<Object> get props => [weight];
}
class SelectCredit extends ChallanEvent{
  final String selectCredit;
  const SelectCredit({required this.selectCredit});

  @override
  List<Object> get props => [selectCredit];
}
class SelectPaymentMethod extends ChallanEvent{
  final String selectPaymentMethod;
  const SelectPaymentMethod({required this.selectPaymentMethod});

  @override
  List<Object> get props => [selectPaymentMethod];
}
class SelectTripsDate extends ChallanEvent{
  final String selectTripsDate;
  const SelectTripsDate({required this.selectTripsDate});

  @override
  List<Object> get props => [selectTripsDate];
}
class SelectTripsTime extends ChallanEvent{
  final String selectTripsTime;
  const SelectTripsTime({required this.selectTripsTime});

  @override
  List<Object> get props => [selectTripsTime];
}
class SelectProduct extends ChallanEvent{
  final String selectProduct;
  const SelectProduct({required this.selectProduct});

  @override
  List<Object> get props => [selectProduct];
}

class SelectedSupplier extends ChallanEvent{
  final String selectedSupplier;
  const SelectedSupplier({required this.selectedSupplier});

  @override
  List<Object> get props => [selectedSupplier];
}

class ProductList extends ChallanEvent{}
class PartyList extends ChallanEvent{}
class VehicleList extends ChallanEvent{}
class CompanyList extends ChallanEvent{}
class PlantList extends ChallanEvent{}
class SupplierList extends ChallanEvent{}
class ResetAllFields extends ChallanEvent {}


class SubmitChallan extends ChallanEvent{}