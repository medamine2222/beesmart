import 'package:cwt_ecommerce_app/common/widgets/profile_product_item/profile_product_item.dart';
import 'package:cwt_ecommerce_app/features/personalization/models/user_model.dart';
import 'package:cwt_ecommerce_app/features/shop/controllers/user_profile_controller.dart';
import 'package:cwt_ecommerce_app/features/shop/models/product_model.dart';
import 'package:cwt_ecommerce_app/features/shop/models/review_model.dart';
import 'package:cwt_ecommerce_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class UserProfileScreen extends StatefulWidget {
  final UserModel user;

  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  int _selectedIndex = 0;
  final UserProfileController controller = Get.put(UserProfileController());

  @override
  void initState() {
    super.initState();
    controller.init(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView( 
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                color: TColors.primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    // Profile info
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile picture
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 42,
                                      backgroundColor: TColors.light,
                                      backgroundImage:
                                          widget.user.profilePicture.isNotEmpty
                                              ? NetworkImage(
                                                  widget.user.profilePicture)
                                              : null,
                                      child: widget.user.profilePicture.isEmpty
                                          ? Text(
                                              '${widget.user.firstName[0]}${widget.user.lastName[0]}'
                                                  .toUpperCase(),
                                              style: TextStyle(fontSize: 30),
                                            )
                                          : null,
                                    ),
                                  ),
                                  Obx(() => Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      color: Colors.white,
                                      child: buildStarRating(calculateAverage(controller.reviews.value)),
                                    ),
                                  )),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(width: 10),
                          // User info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // User name
                                Text(
                                  '${widget.user.firstName} ${widget.user.lastName}'
                                      .split(' ')
                                      .map((String word) {
                                    return word.substring(0, 1).toUpperCase() +
                                        word.substring(1);
                                  }).join(' '),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                // Sales status
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0, vertical: 6.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(32.0),
                                          ),
                                          child: Row(
                                            children: [
                                              // Add boost icon here
                                              Icon(
                                                Icons.electric_bolt,
                                                color: Colors.white,
                                                size: 16.0,
                                              ),
                                              SizedBox(width: 8.0),
                                              Obx(
                                                () => Text(
                                                  getSalesStatusText(
                                                      controller.products),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        // Follow/Unfollow button
                                        Obx(() => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 18.0,
                                                      vertical: 4.0),
                                              decoration: BoxDecoration(
                                                color: controller
                                                        .followingUserIDs.value
                                                        .contains(
                                                            controller.user.id)
                                                    ? Colors.white
                                                    : null,
                                                border: controller
                                                        .followingUserIDs.value
                                                        .contains(
                                                            controller.user.id)
                                                    ? null
                                                    : Border.all(
                                                        color: Colors.white,
                                                        width: 1,
                                                      ),
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  controller.handleFollow();
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                                child: Row(
                                                  children: [
                                                    // Add icon representing following or unfollowing action
                                                    Icon(
                                                      controller
                                                              .followingUserIDs
                                                              .value
                                                              .contains(
                                                                  controller
                                                                      .user.id)
                                                          ? Icons
                                                              .check_circle_outline // Replace with your following icon
                                                          : Icons
                                                              .add_circle_outline,
                                                      // Replace with your follow icon
                                                      color: controller
                                                              .followingUserIDs
                                                              .value
                                                              .contains(
                                                                  controller
                                                                      .user.id)
                                                          ? Colors.green
                                                          : Colors.white,
                                                    ),
                                                    SizedBox(width: 4.0),
                                                    Container(
                                                      child: Text(
                                                        controller
                                                                .followingUserIDs
                                                                .value
                                                                .contains(
                                                                    controller
                                                                        .user
                                                                        .id)
                                                            ? 'Following'
                                                            : 'Follow',
                                                        style: TextStyle(
                                                          color: controller
                                                                  .followingUserIDs
                                                                  .value
                                                                  .contains(
                                                                      controller
                                                                          .user
                                                                          .id)
                                                              ? Colors.black
                                                              : Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          width: 1.0,
                                        ),
                                        //
                                        Column(
                                          children: [
                                            Obx(() => Text(
                                                  controller
                                                      .products.value.length
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                )),
                                            Text(
                                              "Articles",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        // Follow/Unfollow button
                                        Column(
                                          children: [
                                            Obx(() => Text(
                                              controller
                                                  .products.value.length
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.white),
                                            )),
                                            Text(
                                              "Followers",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 4.0,
                                        ),
                                        //
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8,),
              Container(
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: TColors.primary,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTabButton('Available', 0),
                    _buildTabButton('Sold', 1),
                    _buildTabButton('Reviews', 2),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Tab content
              _selectedIndex == 0
                  ? _buildAvailableTab()
                  : _selectedIndex == 1
                      ? _buildSoldTab()
                      : _buildReviewsTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStarRating(double averageRating) {
    const int totalStars = 5;

    List<Widget> starWidgets = [];

    int fullStars = averageRating.floor();

    bool hasHalfStar = averageRating - fullStars >= 0.5;

    for (int i = 0; i < fullStars; i++) {
      starWidgets.add(Icon(
        Icons.star,
        color: Colors.yellow,
        size: 12,
      ));
    }

    // Add half star if needed
    if (hasHalfStar) {
      starWidgets.add(Icon(
        Icons.star_half,
        color: Colors.yellow,
        size: 12,
      ));
    }

    // Add gray stars to fill remaining space
    int remainingStars = totalStars - starWidgets.length;
    for (int i = 0; i < remainingStars; i++) {
      starWidgets.add(Icon(
        Icons.star_border,
        color: Colors.grey,
        size: 12,
      ));
    }

    // Create the row with stars and rating text
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...starWidgets,
        SizedBox(width: 4),
        Text(
          '${averageRating.toStringAsFixed(1)}/$totalStars',
          style: TextStyle(
            color: Colors.black,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  double calculateAverage(List<Review> array) {
    if (array.isEmpty) {
      return 0.0;
    }

    double sum = 0.0;
    for (Review item in array) {
      sum += double.parse(item.stars);
    }

    return sum / array.length;
  }


  // Function to build a tab button
  Widget _buildTabButton(String title, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Text(
        title,
        style: TextStyle(
          color: _selectedIndex == index ? TColors.primary : Colors.black,
        ),
      ),
    );
  }

  // Function to build the available tab content
  Widget _buildAvailableTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingGridView();
      } else {
        final availableProducts = controller.products
            .where((product) => product.isSold == false)
            .toList();
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 0.77,
          ),
          itemCount: availableProducts.length,
          itemBuilder: (context, index) {
            final product = availableProducts[index];
            return ProductItem(product: product);
          },
        );
      }
    });
  }

// Function to build the sold tab content
  Widget _buildSoldTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingGridView();
      } else {
        final soldProducts = controller.products
            .where((product) => product.isSold == true)
            .toList();
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 0.77,
          ),
          itemCount: soldProducts.length,
          itemBuilder: (context, index) {
            final product = soldProducts[index];
            return ProductItem(product: product);
          },
        );
      }
    });
  }

  // Function to build the reviews tab content
  Widget _buildReviewsTab() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: controller.reviews.value.length,
      itemBuilder: (context, index) {
        Review review = controller.reviews.value[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(review.userModel!.profilePicture),
          ),
          title: Row(
            children: [
              Text(
                  "${review.userModel!.firstName} ${review.userModel?.lastName}"),
              SizedBox(width: 8), // Adjust spacing between name and stars
              // Display star icons based on the rating
              Row(
                children: [
                  for (int i = 1; i <= int.parse(review.stars); i++)
                    Icon(Icons.star, color: Colors.yellow),
                  // Display empty star icons for the remaining rating
                  for (int i = int.parse(review.stars) + 1; i <= 5; i++)
                    Icon(Icons.star_border, color: Colors.grey),
                ],
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(review.comment),
          ),
        );
      },
    );
  }

// Function to get sales status text based on the number of products sold
  String getSalesStatusText(List<ProductModel> products) {
    int soldProductCount = products.where((product) => product.isSold).length;
    if (soldProductCount < 5) {
      return 'Beginner';
    } else if (soldProductCount >= 5 && soldProductCount < 15) {
      return 'Regular';
    } else if (soldProductCount >= 15 && soldProductCount < 50) {
      return 'Confirmed';
    } else if (soldProductCount >= 50 && soldProductCount < 100) {
      return 'Expert';
    } else {
      return 'Ambassador';
    }
  }

  // Function to build a loading GridView with shimmer effect
  Widget _buildLoadingGridView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 0.77,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        // Placeholder item with shimmer effect
        return Shimmer.fromColors(
          baseColor: Colors.transparent,
          highlightColor: Colors.grey[300]!,
          child: Container(
            color: Colors.white, // Set background color for the shimmer
          ),
        );
      },
    );
  }
}
