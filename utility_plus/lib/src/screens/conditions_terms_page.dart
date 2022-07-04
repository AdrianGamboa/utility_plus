import 'package:flutter/material.dart';
import '../utils/global.dart';

class ConditionsTermsPage extends StatefulWidget {
  const ConditionsTermsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ConditionsTermsPage> createState() => ConditionsTermsPageState();
}

class ConditionsTermsPageState extends State<ConditionsTermsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            title: const Text('Términos y Condiciones'),
          )),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).focusColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: themeManager.themeMode == ThemeMode.light
                        ? Image.asset("assets/images/UtilityC.png")
                        : Image.asset("assets/images/UtilityO.png"),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text('Términos y Condiciones',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Text(
                    '''
    Al descargar o usar esta aplicación, se aplicarán estos términos automáticamente a usted; por lo tanto, debe asegurarse de leerlos detenidamente antes de usar la aplicación. No tiene permitido copiar ni modificar la aplicación, ninguna parte de la aplicación o nuestras marcas comerciales de ninguna manera. No se le permite intentar extraer el código fuente de la aplicación, y tampoco debe intentar traducir la aplicación a otros idiomas o hacer versiones derivadas. La aplicación en sí y todas las marcas comerciales, derechos de autor, derechos de bases de datos y otros derechos de propiedad intelectual relacionados con ella siguen perteneciendo a Utility+.

    Utility+ se compromete a garantizar que la aplicación sea lo más útil y eficiente posible. Por ese motivo, nos reservamos el derecho de realizar cambios en la aplicación o cobrar por sus servicios, en cualquier momento y por cualquier motivo. Nunca le cobraremos por la aplicación o sus servicios sin dejarle muy claro exactamente lo que está pagando.

    La aplicación Utility+ almacena y procesa los datos personales que nos ha proporcionado para proporcionar nuestro Servicio. Es su responsabilidad mantener su teléfono y el acceso a la aplicación seguros. Por lo tanto, le recomendamos que no haga jailbreak ni rootee su teléfono, que es el proceso de eliminar las restricciones y limitaciones de software impuestas por el sistema operativo oficial de su dispositivo. Podría hacer que su teléfono sea vulnerable a malware/virus/programas maliciosos, comprometer las funciones de seguridad de su teléfono y podría provocar que la aplicación Utility+ no funcione correctamente o no funcione en absoluto.

    La aplicación utiliza servicios de terceros que declaran sus Términos y condiciones.

    Enlace a los Términos y condiciones de los proveedores de servicios de terceros utilizados por la aplicación
    •	Google Analytics for Firebase

    Debe tener en cuenta que hay ciertas cosas de las que Utility+ no se hace responsable. Ciertas funciones de la aplicación requerirán que la aplicación tenga una conexión a Internet activa. La conexión puede ser por Wi-Fi o proporcionada por su proveedor de red móvil, pero Utility+ no puede asumir la responsabilidad de que la aplicación no funcione con todas sus funciones si no tiene acceso a Wi-Fi o no se tiene los datos móviles activados.

    Si está utilizando la aplicación fuera de un área con Wi-Fi, debe recordar que se seguirán aplicando los términos del acuerdo con su proveedor de red móvil. Como resultado, es posible que su proveedor de telefonía móvil le cobre el costo de los datos durante la duración de la conexión mientras accede a la aplicación u otros cargos de terceros. Al usar la aplicación, usted acepta la responsabilidad de dichos cargos, incluidos los cargos por datos de roaming si usa la aplicación fuera de su territorio de origen (es decir, región o país) sin desactivar el roaming de datos. Si usted no es él que paga la factura del dispositivo en el que está usando la aplicación, tenga en cuenta que asumimos que ha recibido permiso del que cancela la factura para usar la aplicación.

    De la misma manera, Utility+ no siempre puede asumir la responsabilidad por la forma en que usa la aplicación, es decir, debe asegurarse de que su dispositivo permanezca cargado; si se queda sin batería y no puede encenderlo para aprovechar el Servicio, Utility+ no puede aceptar la responsabilidad. 

    Con respecto a la responsabilidad de Utility+ por el uso que usted haga de la aplicación, cuando la use, es importante tener en cuenta que, aunque nos esforzamos por garantizar que esté actualizada y sea correcta en todo momento, confiamos en terceros para proporcionar información para que podamos ponerla a su disposición. Utility+ no acepta ninguna responsabilidad por cualquier pérdida, directa o indirecta, que experimente como resultado de confiar completamente en esta funcionalidad de la aplicación.

    En algún momento, es posible que deseemos actualizar la aplicación. La aplicación está actualmente disponible en Android: los requisitos para el sistema y para cualquier sistema adicional al que decidamos extender la disponibilidad de la aplicación pueden cambiar, y deberá descargar las actualizaciones si desea seguir usando la aplicación. Utility+ no promete que siempre actualizará la aplicación para que sea relevante para usted y/o funcione con la versión de Android que tiene instalada en su dispositivo. Sin embargo, usted se compromete a aceptar siempre las actualizaciones de la aplicación cuando se le ofrezcan. También es posible que deseemos dejar de proporcionar la aplicación en cualquier momento sin notificarle la terminación. A menos que le indiquemos lo contrario, ante cualquier terminación, (a) los derechos y licencias que se le otorgaron en estos términos terminarán; (b) debe dejar de usar la aplicación y de ser necesario eliminarla de su dispositivo.
                    ''',
                    style: TextStyle(
                      fontSize: 16.0,
                      height: 1.5,
                    ),
                  ),
                  Text('Cambios a estos Términos y Condiciones',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Text(
                    '''
    Es posible que actualicemos nuestros Términos y condiciones de vez en cuando. Por lo tanto, se le recomienda revisar esta página periódicamente para ver si hay cambios. Le notificaremos cualquier cambio publicando los nuevos Términos y Condiciones en esta página.

    Estos términos y condiciones son efectivos a partir del 2022-06-14
''',
                    style: TextStyle(
                      fontSize: 16.0,
                      height: 1.5,
                    ),
                  ),
                  Text('Contáctenos',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Text(
                    '''
    Si tiene alguna pregunta o sugerencia sobre nuestros Términos y Condiciones, no dude en contactarnos en utilitypluscontact@gmail.com.

Estos términos y condiciones fueron generados con App Privacy Policy Generator
''',
                    style: TextStyle(
                      fontSize: 16.0,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
