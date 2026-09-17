import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onLogoutPressed;
  final String email;

  const ProfileScreen({
    super.key,
    required this.onClose,
    required this.onLogoutPressed,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------------------------------------------
            // HEADER
            // --------------------------------------------------
            SizedBox(
              height: 50,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF211A2D),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: onClose,
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xFF211A2D),
                      ),
                      splashRadius: 22,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // --------------------------------------------------
            // ACCOUNT ICON
            // --------------------------------------------------
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1EAF8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 38,
                  color: Color(0xFF6846A8),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // --------------------------------------------------
            // EMAIL LABEL
            // --------------------------------------------------
            const Text(
              "Email address",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 8),

            // --------------------------------------------------
            // EMAIL CARD
            // --------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F5FA),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE9E0F0)),
              ),
              child: Text(
                email,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF29232F),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 28),

            // --------------------------------------------------
            // LOGOUT
            // --------------------------------------------------
            InkWell(
              onTap: onLogoutPressed,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F5FA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE4F5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.logout,
                        size: 21,
                        color: Color(0xFF6846A8),
                      ),
                    ),

                    const SizedBox(width: 14),

                    const Expanded(
                      child: Text(
                        "Log out",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF29232F),
                        ),
                      ),
                    ),

                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
