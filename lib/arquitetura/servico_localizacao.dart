import 'package:geolocator/geolocator.dart';

class ServicoLocalizacao {
  Future<Position> obterPosicaoAtual() async {
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) throw 'GPS desativado no celular.';

    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) throw 'Permissão de GPS negada.';
    }

    return await Geolocator.getCurrentPosition();
  }
}
