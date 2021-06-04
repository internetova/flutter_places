import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/location/location_bloc.dart';
import 'package:places/ui/components/bottom_navigationbar.dart';

/// todo удалить всё после тестирования
/// экран для тестирования всяких штук
/// геопозиция
class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(builder: (context, state) {
        print(state);
        if (state is LocationInitial) {
          return Center(child: Text('Fetching Location'));
        } else if (state is LocationLoadSuccess) {
          print('${state.position.latitude}, ${state.position.longitude}');

          return Center(
            child: Text(
              'Location: (${state.position.latitude}, ${state.position.longitude})',
            ),
          );
        } else if (state is LocationFailure) {
          return Center(
            child: Text(
              '${state.errorMessage}',
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<LocationBloc>().add(LocationStarted());
        },
        child: Icon(Icons.add_location),
      ),
      bottomNavigationBar: const MainBottomNavigationBar(current: 1),
    );
  }
}
