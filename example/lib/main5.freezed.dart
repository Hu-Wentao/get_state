// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'main5.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$CounterMTearOff {
  const _$CounterMTearOff();

  _CounterM call({int number, String str}) {
    return _CounterM(
      number: number,
      str: str,
    );
  }
}

// ignore: unused_element
const $CounterM = _$CounterMTearOff();

mixin _$CounterM {
  int get number;
  String get str;

  $CounterMCopyWith<CounterM> get copyWith;
}

abstract class $CounterMCopyWith<$Res> {
  factory $CounterMCopyWith(CounterM value, $Res Function(CounterM) then) =
      _$CounterMCopyWithImpl<$Res>;
  $Res call({int number, String str});
}

class _$CounterMCopyWithImpl<$Res> implements $CounterMCopyWith<$Res> {
  _$CounterMCopyWithImpl(this._value, this._then);

  final CounterM _value;
  // ignore: unused_field
  final $Res Function(CounterM) _then;

  @override
  $Res call({
    Object number = freezed,
    Object str = freezed,
  }) {
    return _then(_value.copyWith(
      number: number == freezed ? _value.number : number as int,
      str: str == freezed ? _value.str : str as String,
    ));
  }
}

abstract class _$CounterMCopyWith<$Res> implements $CounterMCopyWith<$Res> {
  factory _$CounterMCopyWith(_CounterM value, $Res Function(_CounterM) then) =
      __$CounterMCopyWithImpl<$Res>;
  @override
  $Res call({int number, String str});
}

class __$CounterMCopyWithImpl<$Res> extends _$CounterMCopyWithImpl<$Res>
    implements _$CounterMCopyWith<$Res> {
  __$CounterMCopyWithImpl(_CounterM _value, $Res Function(_CounterM) _then)
      : super(_value, (v) => _then(v as _CounterM));

  @override
  _CounterM get _value => super._value as _CounterM;

  @override
  $Res call({
    Object number = freezed,
    Object str = freezed,
  }) {
    return _then(_CounterM(
      number: number == freezed ? _value.number : number as int,
      str: str == freezed ? _value.str : str as String,
    ));
  }
}

class _$_CounterM with DiagnosticableTreeMixin implements _CounterM {
  _$_CounterM({this.number, this.str});

  @override
  final int number;
  @override
  final String str;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CounterM(number: $number, str: $str)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CounterM'))
      ..add(DiagnosticsProperty('number', number))
      ..add(DiagnosticsProperty('str', str));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _CounterM &&
            (identical(other.number, number) ||
                const DeepCollectionEquality().equals(other.number, number)) &&
            (identical(other.str, str) ||
                const DeepCollectionEquality().equals(other.str, str)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(number) ^
      const DeepCollectionEquality().hash(str);

  @override
  _$CounterMCopyWith<_CounterM> get copyWith =>
      __$CounterMCopyWithImpl<_CounterM>(this, _$identity);
}

abstract class _CounterM implements CounterM {
  factory _CounterM({int number, String str}) = _$_CounterM;

  @override
  int get number;
  @override
  String get str;
  @override
  _$CounterMCopyWith<_CounterM> get copyWith;
}
