import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';
import 'package:mizani_app/app/core/utils/app_formatters.dart';
import 'package:mizani_app/app/widgets/amount_card.dart';
import 'package:mizani_app/app/widgets/date_selector.dart';
import 'package:mizani_app/app/widgets/note_field.dart';
import 'package:mizani_app/app/widgets/page_header.dart';
import 'package:mizani_app/app/widgets/primary_button.dart';
import 'package:mizani_app/app/widgets/selection_grid.dart';
import 'package:mizani_app/app/modules/edit_income/controllers/edit_income_controller.dart';

class EditIncomeView extends GetView<EditIncomeController> {
  const EditIncomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditIncomeController>(
      builder: (_) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {


    return Directionality(


      textDirection:
      TextDirection.rtl,



      child: Scaffold(


        backgroundColor:
        AppColors.background,



        body:
        SafeArea(


          child:
          SingleChildScrollView(


            padding:
            const EdgeInsets
                .symmetric(


              horizontal:
              18,


              vertical:
              12,


            ),



            child:
            Column(


              children: [



                // =========================================
                // Header
                // Widget مشتركة
                // =========================================

                PageHeader(


                  title:
                  "تعديل الدخل",


                  subtitle:
                  "عدّل بيانات عملية الدخل",


                  onBack: () {


                    Get.back();


                  },


                ),



                const SizedBox(
                  height: 18,
                ),



                // =========================================
                // بطاقة معلومات العملية
                // خاصة بواجهة تعديل الدخل
                // =========================================

                _buildIncomeCard(),



                const SizedBox(
                  height: 15,
                ),



                // =========================================
                // Amount
                // Widget مشتركة
                // =========================================

                AmountCard(


                  controller:
                  controller.amountController,


                  quickAmounts:
                  const [


                    200,

                    500,

                    1000,

                    2000,


                  ],


                  onChanged: () {


                    
controller.update();


                  },


                ),



                const SizedBox(
                  height: 15,
                ),



                // =========================================
                // Income Source
                // Widget مشتركة
                // =========================================

                SelectionGrid(


                  title:
                  "مصدر الدخل",


                  items:
                  controller.incomeSources,


                  selectedValue:
                  controller.selectedSource,


                  onSelected:
                      (value) {


                    controller.selectedSource =
                          value;
controller.update();


                  },


                  crossAxisCount:
                  3,


                ),



                const SizedBox(
                  height: 15,
                ),



                // =========================================
                // Date
                // Widget مشتركة
                // =========================================

                DateSelector(


                  date:
                  controller.selectedDate,


                  onTap:
                  controller.pickDate,


                ),



                const SizedBox(
                  height: 15,
                ),



                // =========================================
                // Note
                // Widget مشتركة
                // =========================================

                NoteField(


                  controller:
                  controller.noteController,


                ),



                const SizedBox(
                  height: 18,
                ),



                // =========================================
                // ملخص التعديل
                // =========================================

                _buildSummaryCard(),



                const SizedBox(
                  height: 18,
                ),



                // =========================================
                // Save Button
                // Widget مشتركة
                // =========================================

                if (!controller.isSaving)

                  PrimaryButton(


                    title:
                    "حفظ التعديلات",


                    icon:
                    Icons.save_outlined,


                    onPressed:
                    controller.saveChanges,


                  )

                else

                  Container(


                    width:
                    double.infinity,


                    height:
                    55,


                    decoration:
                    BoxDecoration(


                      color:
                      AppColors.primary,


                      borderRadius:
                      BorderRadius.circular(
                        17,
                      ),


                    ),


                    child:
                    const Center(


                      child:
                      SizedBox(


                        width:
                        24,


                        height:
                        24,


                        child:
                        CircularProgressIndicator(


                          strokeWidth:
                          2.5,


                          color:
                          Colors.white,


                        ),


                      ),


                    ),


                  ),



                const SizedBox(
                  height: 15,
                ),


              ],


            ),


          ),


        ),


      ),


    );

  }

  Widget _buildIncomeCard() {


    return Container(


      width:
      double.infinity,


      padding:
      const EdgeInsets.all(
        18,
      ),



      decoration:
      BoxDecoration(


        gradient:
        LinearGradient(


          colors: [


            AppColors.primaryLight,


            AppColors.primaryDark,


          ],


        ),



        borderRadius:
        BorderRadius.circular(
          22,
        ),


      ),



      child:
      Row(


        children: [



          // =========================
          // Icon
          // =========================

          Container(


            width:
            55,


            height:
            55,


            decoration:
            BoxDecoration(


              color:
              Colors.white24,


              borderRadius:
              BorderRadius.circular(
                16,
              ),


            ),



            child:
            const Icon(


              Icons
                  .account_balance_wallet_outlined,


              color:
              Colors.white,


              size:
              28,


            ),


          ),



          const SizedBox(
            width: 15,
          ),



          // =========================
          // معلومات العملية
          // =========================

          Expanded(


            child:
            Column(


              crossAxisAlignment:
              CrossAxisAlignment.start,


              children: [


                const Text(


                  "عملية الدخل",


                  style:
                  TextStyle(


                    color:
                    Colors.white70,


                    fontSize:
                    13,


                  ),


                ),



                const SizedBox(
                  height: 5,
                ),



                Text(


                  controller.selectedSource,


                  style:
                  const TextStyle(


                    color:
                    Colors.white,


                    fontSize:
                    18,


                    fontWeight:
                    FontWeight.bold,


                  ),


                ),



                const SizedBox(
                  height: 3,
                ),



                const Text(


                  "يمكنك تعديل البيانات أدناه",


                  style:
                  TextStyle(


                    color:
                    Colors.white70,


                    fontSize:
                    11,


                  ),


                ),


              ],


            ),


          ),



          // =========================
          // Amount
          // =========================

          Column(


            crossAxisAlignment:
            CrossAxisAlignment.end,


            children: [


              const Text(


                "المبلغ",


                style:
                TextStyle(


                  color:
                  Colors.white70,


                  fontSize:
                  11,


                ),


              ),



              const SizedBox(
                height: 5,
              ),



              Text(


                "${controller.amountController.text.isEmpty ? "0" : controller.amountController.text} ₪",


                style:
                TextStyle(


                  color:
                  AppColors.incomeLight,


                  fontSize:
                  20,


                  fontWeight:
                  FontWeight.bold,


                ),


              ),


            ],


          ),


        ],


      ),


    );

  }

  Widget _buildSummaryCard() {


    return Container(


      width:
      double.infinity,


      padding:
      const EdgeInsets.all(
        17,
      ),



      decoration:
      BoxDecoration(


        color:
        AppColors.primarySoft,


        borderRadius:
        BorderRadius.circular(
          18,
        ),


      ),



      child:
      Column(


        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [


          Row(


            children: [


              Icon(


                Icons
                    .edit_note_outlined,


                color:
                AppColors.primary,


                size:
                21,


              ),



              SizedBox(
                width: 7,
              ),



              Text(


                "ملخص التعديل",


                style:
                TextStyle(


                  color:
                  AppColors.textDark,


                  fontWeight:
                  FontWeight.bold,


                  fontSize:
                  15,


                ),


              ),


            ],


          ),



          const SizedBox(
            height: 15,
          ),



          Row(


            mainAxisAlignment:
            MainAxisAlignment
                .spaceAround,


            children: [



              // =========================
              // Amount
              // =========================

              Expanded(


                child:
                _summaryItem(


                  title:
                  "المبلغ",


                  value:
                  "${controller.amountController.text.isEmpty ? "0" : controller.amountController.text} ₪",


                ),


              ),



              // =========================
              // Separator
              // =========================

              Container(


                width:
                1,


                height:
                42,


                color:
                AppColors.primaryBorder,


              ),



              // =========================
              // Source
              // =========================

              Expanded(


                child:
                _summaryItem(


                  title:
                  "المصدر",


                  value:
                  controller.selectedSource,


                ),


              ),



              // =========================
              // Separator
              // =========================

              Container(


                width:
                1,


                height:
                42,


                color:
                AppColors.primaryBorder,


              ),



              // =========================
              // Date
              // =========================

              Expanded(


                child:
                _summaryItem(


                  title:
                  "التاريخ",


                  value:
                  AppFormatters.date(
                    controller.selectedDate,
                  ),


                ),


              ),


            ],


          ),


        ],


      ),


    );

  }

  Widget _summaryItem({


    required String title,


    required String value,


  }) {


    return Column(


      children: [


        Text(


          title,


          style:
          TextStyle(


            color:
            AppColors.textMuted,


            fontSize:
            10,


          ),


        ),



        const SizedBox(
          height: 5,
        ),



        Text(


          value,


          maxLines:
          1,


          overflow:
          TextOverflow.ellipsis,


          textAlign:
          TextAlign.center,


          style:
          TextStyle(


            color:
            AppColors.textDark,


            fontWeight:
            FontWeight.bold,


            fontSize:
            12,


          ),


        ),


      ],


    );

  }
}
