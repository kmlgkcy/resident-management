import 'package:auto_route/auto_route.dart';
import '../../common/router/app_router.dart';
import '../../controller/apartment_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ApartmentManagementView extends HookConsumerWidget {
  const ApartmentManagementView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(apartmentsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apartment Management Module'),
        actions: const [],
      ),
      floatingActionButton: FloatingActionButton.small(
          onPressed: () {
            context.router.push(ApartmentDetailRoute());
          },
          child: const Text('New')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text('name'),
                    const Spacer(),
                    const SizedBox(width: 52, child: Text('edit')),
                    SizedBox.square(
                      dimension: 24,
                      child: ElevatedButton(
                          onPressed: () {
                            ApartmentController.instance.reload();
                          },
                          style:
                              ElevatedButton.styleFrom(alignment: Alignment.center, padding: const EdgeInsets.only(), backgroundColor: Colors.green),
                          child: const Icon(Icons.refresh_outlined)),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Card(
                  child: controller.when(
                error: (err, __) {
                  // err.log();
                  return const Text('Something went wrong!');
                },
                loading: () => const SizedBox.shrink(),
                data: (data) {
                  if (data != null) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: data.length,
                        // itemCount: 10,
                        itemBuilder: (BuildContext context, int index) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => context.router.push(ApartmentDetailRoute(apartment: data[index])),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('$index   '),
                                    Text(data[index].name),
                                    // Text(data[index].adress),
                                    // Text(data[index].warming),
                                    const Spacer(),

                                    SizedBox.square(
                                      dimension: 24,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            // await ApartmentService.instance.delete(id: data[index].id);
                                            await ApartmentController.instance.delete(apt: data[index]);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              alignment: Alignment.center, padding: const EdgeInsets.only(), backgroundColor: Colors.red),
                                          child: const Icon(Icons.delete_outlined)),
                                    )
                                  ],
                                ),
                              ),
                              const Divider(thickness: 2),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Text('Nothing to show');
                  }
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}
