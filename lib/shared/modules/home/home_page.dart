import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:payflow/shared/modules/home/home_controller.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();
  final pages = [Container(color: Colors.red), Container(color: Colors.blue)];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(152),
        child: Container(
            height: 152,
            color: AppColors.primary,
            child: Center(
              child: ListTile(
                title: Text.rich(TextSpan(
                  text: "Olá, ",
                  style: TextStyles.titleRegular,
                  children: [
                    TextSpan(
                        text: "João", style: TextStyles.titleBoldBackground)
                  ],
                )),
                subtitle: Text("Mantenha suas contas em dia",
                    style: TextStyles.captionShape),
                trailing: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            )),
      ),
      body: pages[controller.currentPage],
      bottomNavigationBar: Container(
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  controller.setPage(0);
                  setState(() {});
                },
                icon: Icon(Icons.home, color: AppColors.primary)),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/barcode_scanner');
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10)),
                child:
                    Icon(Icons.add_box_outlined, color: AppColors.background),
              ),
            ),
            IconButton(
                onPressed: () {
                  controller.setPage(1);
                  setState(() {});
                },
                icon: Icon(Icons.description_outlined, color: AppColors.body))
          ],
        ),
      ),
    );
  }
}
