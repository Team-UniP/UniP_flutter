import 'package:flutter/material.dart';

void showFriendRequestDialog(
    BuildContext context, String friendName, String imageUrl) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: 332,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Friend profile picture and name
              Container(
                width: 40,
                height: 59,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 38,
                      child: Text(
                        friendName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage(imageUrl), // Using AssetImage here
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(36.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Friend request message
              Text(
                '친구요청을 수락하시겠습니까?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              // Accept and Decline buttons
              Container(
                width: 204,
                height: 28,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Accept button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // Accept friend request logic
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          '수락',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    // Decline button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // Decline friend request logic
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          '거절',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
