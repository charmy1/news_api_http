// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:data_connection_checker/data_connection_checker.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:new_api_http_flutter/application/news_bloc/news_bloc.dart'
    as _i8;
import 'package:new_api_http_flutter/core/injectable_module.dart' as _i9;
import 'package:new_api_http_flutter/core/network_info.dart' as _i5;
import 'package:new_api_http_flutter/domain/news/news_interface.dart' as _i6;
import 'package:new_api_http_flutter/infrastructure/news/news_impl.dart' as _i7;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final injectableModule = _$InjectableModule();
    gh.lazySingleton<_i3.Client>(() => injectableModule.httpClient);
    gh.lazySingleton<_i4.DataConnectionChecker>(
        () => injectableModule.dataConnectionChecker);
    gh.lazySingleton<_i5.NetworkInfo>(
        () => _i5.NetworkInfoImpl(gh<_i4.DataConnectionChecker>()));
    gh.lazySingleton<_i6.NewsInterface>(() => _i7.NewsImpl(
          gh<_i5.NetworkInfo>(),
          gh<_i3.Client>(),
        ));
    gh.factory<_i8.NewsBloc>(() => _i8.NewsBloc(gh<_i6.NewsInterface>()));
    return this;
  }
}

class _$InjectableModule extends _i9.InjectableModule {}
