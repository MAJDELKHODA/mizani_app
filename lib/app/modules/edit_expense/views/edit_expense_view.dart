import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';
import 'package:mizani_app/app/core/theme/app_styles.dart';
import 'package:mizani_app/app/widgets/amount_card.dart';
import 'package:mizani_app/app/widgets/date_selector.dart';
import 'package:mizani_app/app/widgets/note_field.dart';
import 'package:mizani_app/app/widgets/page_header.dart';
import 'package:mizani_app/app/widgets/primary_button.dart';
import 'package:mizani_app/app/widgets/selection_grid.dart';
import 'package:mizani_app/app/modules/edit_expense/controllers/edit_expense_controller.dart';

class EditExpenseView extends GetView<EditExpenseController> {
  const EditExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditExpenseController>(
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


        body: SafeArea(

          child:
          SingleChildScrollView(

            padding:
            const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 12,
            ),


            child: Column(

              children: [


                // =========================
                // Header
                // =========================

                PageHeader(

                  title:
                  "تعديل العملية",

                  subtitle:
                  "عدّل بيانات العملية",

                  onBack: () {

                    Get.back();

                  },

                ),


                const SizedBox(
                  height: 18,
                ),


                // =========================
                // Amount
                // =========================

                AmountCard(

                  controller:
                  controller.amountController,

                  quickAmounts:
                  const [
                    10,
                    20,
                    50,
                    100,
                    200,
                  ],

                  onChanged: () {

                    
controller.update();

                  },

                ),


                const SizedBox(
                  height: 15,
                ),


                // =========================
                // Category
                // =========================

                SelectionGrid(

                  title:
                  "تصنيف المصروف",

                  items:
                  controller.categories,

                  selectedValue:
                  controller.selectedCategory,

                  onSelected:
                      (value) {

                    controller.selectedCategory =
                          value;
controller.update();

                  },

                  crossAxisCount:
                  4,

                ),


                const SizedBox(
                  height: 15,
                ),


                // =========================
                // Date
                // =========================

                DateSelector(

                  date:
                  controller.selectedDate,

                  onTap:
                  controller.pickDate,

                ),


                const SizedBox(
                  height: 15,
                ),


                // =========================
                // Payment Method
                // خاص بالمصروف
                // =========================

                Container(

                  padding:
                  const EdgeInsets.all(
                    15,
                  ),

                  decoration:
                  BoxDecoration(

                    color:
                    AppColors.card,

                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),
  border: Border.all(color: AppColors.border),
  boxShadow: AppStyles.softShadow,
),


                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      Row(

                        children: [

                          Icon(
                            Icons
                                .credit_card,
                            color:
                            AppColors.textDark,
                            size: 18,
                          ),

                          SizedBox(
                            width: 6,
                          ),

                          Text(
                            "طريقة الدفع",
                            style:
                            TextStyle(
                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),

                        ],

                      ),


                      const SizedBox(
                        height: 10,
                      ),


                      Container(

                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 12,
                        ),

                        decoration:
                        BoxDecoration(

                          color:
                          AppColors.surfaceSoft,

                          borderRadius:
                          BorderRadius
                              .circular(
                            13,
                          ),

                          border:
                          Border.all(
                            color:
                            AppColors.primarySoft,
                          ),

                        ),


                        child:
                        DropdownButtonHideUnderline(

                          child:
                          DropdownButton<
                              String>(

                            value:
                            controller.selectedPayment,

                            isExpanded:
                            true,

                            items:
                            const [

                              DropdownMenuItem(
                                value:
                                "نقدي",
                                child:
                                Text(
                                  "نقدي",
                                ),
                              ),

                              DropdownMenuItem(
                                value:
                                "بطاقة",
                                child:
                                Text(
                                  "بطاقة",
                                ),
                              ),

                              DropdownMenuItem(
                                value:
                                "محفظة إلكترونية",
                                child:
                                Text(
                                  "محفظة إلكترونية",
                                ),
                              ),

                              DropdownMenuItem(
                                value:
                                "أخرى",
                                child:
                                Text(
                                  "أخرى",
                                ),
                              ),

                            ],

                            onChanged:
                                (value) {

                              if (value !=
                                  null) {

                                controller.selectedPayment =
                                        value;
controller.update();

                              }

                            },

                          ),

                        ),

                      ),

                    ],

                  ),

                ),


                const SizedBox(
                  height: 15,
                ),


                // =========================
                // Note
                // =========================

                NoteField(

                  controller:
                  controller.noteController,

                ),


                const SizedBox(
                  height: 18,
                ),


                // =========================
                // Save
                // =========================

                PrimaryButton(

                  title:
                  "حفظ التعديلات",

                  icon:
                  Icons.save_outlined,

                  onPressed:
                  controller.saveChanges,

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
}
