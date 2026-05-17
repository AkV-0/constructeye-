import 'package:flutter/material.dart';

import 'LoginScreen.dart';
import 'SignupScreen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: const Color(0xFF37353E),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= NAVBAR =================
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 40,
                vertical: isMobile ? 12 : 20,
              ),

              child: isMobile
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "ConstructEye",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white54),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: const Color(0xFF715A5A),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Get Started",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "ConstructEye",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 24),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white54),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 26,
                                  vertical: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: const Color(0xFF44444E),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Get Started",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            // ================= PRICING SECTION =================
            Container(
              width: double.infinity,

              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 40,
                vertical: isMobile ? 40 : 70,
              ),

              color: const Color(0xFFF4F5F5),

              child: Column(
                children: [
                  Text(
                    "Subscription Plans",
                    style: TextStyle(
                      fontSize: isMobile ? 24 : 44,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF37353E),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    "Choose the perfect plan for your construction projects.",
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 18,
                      color: Colors.black54,
                    ),
                  ),

                  SizedBox(height: isMobile ? 30 : 50),

                  isMobile
                      ? Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: pricingCard("Basic", "₹99/month", [
                                "1 Construction Site",
                                "Basic Analytics",
                                "Photo Uploads",
                                "Weekly Reports",
                              ], false),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: pricingCard("Professional", "₹249/month", [
                                "Up to 3 Sites",
                                "Advanced Analytics",
                                "Real-Time Monitoring",
                                "Priority Support",
                              ], true),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: pricingCard("Enterprise", "₹599/month", [
                                "Unlimited Sites",
                                "AI Analytics",
                                "Dedicated Support",
                                "Custom Integrations",
                              ], false),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: pricingCard("Basic", "₹99/month", [
                                "1 Construction Site",
                                "Basic Analytics",
                                "Photo Uploads",
                                "Weekly Reports",
                              ], false),
                            ),

                            const SizedBox(width: 24),

                            Expanded(
                              child: pricingCard("Professional", "₹249/month", [
                                "Up to 3 Sites",
                                "Advanced Analytics",
                                "Real-Time Monitoring",
                                "Priority Support",
                              ], true),
                            ),

                            const SizedBox(width: 24),

                            Expanded(
                              child: pricingCard("Enterprise", "₹599/month", [
                                "Unlimited Sites",
                                "AI Analytics",
                                "Dedicated Support",
                                "Custom Integrations",
                              ], false),
                            ),
                          ],
                        ),
                ],
              ),
            ),

            // ================= HERO SECTION =================
            Container(
              width: double.infinity,

              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 40,
                vertical: isMobile ? 40 : 50,
              ),

              color: const Color(0xFFF4F5F5),

              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Monitor Construction\nProjects In Real-Time",
                          style: TextStyle(
                            fontSize: isMobile ? 24 : 50,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF37353E),
                            height: 1.2,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Track progress, manage workers, upload site images, and analyze project performance with ConstructEye.",
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 20,
                            color: Colors.black54,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 30),

                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF715A5A),
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 18 : 34,
                                  vertical: isMobile ? 12 : 22,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Start Trial",
                                style: TextStyle(
                                  fontSize: isMobile ? 14 : 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFF715A5A),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 18 : 34,
                                  vertical: isMobile ? 12 : 22,
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "Watch Demo",
                                style: TextStyle(
                                  fontSize: isMobile ? 14 : 18,
                                  color: const Color(0xFF715A5A),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        Container(
                          width: double.infinity,
                          height: isMobile ? 200 : 420,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1504307651254-35680f356dfd?q=80&w=1200&auto=format&fit=crop',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              const Text(
                                "Monitor Construction\nProjects In Real-Time",
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF37353E),
                                  height: 1.2,
                                ),
                              ),

                              const SizedBox(height: 24),

                              const Text(
                                "Track progress, manage workers, upload site images, and analyze project performance with ConstructEye.",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                  height: 1.6,
                                ),
                              ),

                              const SizedBox(height: 36),

                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF715A5A),

                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 34,
                                        vertical: 22,
                                      ),
                                    ),

                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignupScreen(),
                                        ),
                                      );
                                    },

                                    child: const Text(
                                      "Start Trial",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 18),

                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Color(0xFF715A5A),
                                      ),

                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 34,
                                        vertical: 22,
                                      ),
                                    ),

                                    onPressed: () {},

                                    child: const Text(
                                      "Watch Demo",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF715A5A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 50),

                        Expanded(
                          child: Container(
                            height: 420,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),

                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),

                              child: Image.network(
                                'https://images.unsplash.com/photo-1504307651254-35680f356dfd?q=80&w=1200&auto=format&fit=crop',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),

            // ================= FOOTER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              color: const Color(0xFF37353E),

              child: const Center(
                child: Text(
                  "© 2026 ConstructEye. All rights reserved.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pricingCard(
    String title,
    String price,
    List<String> features,
    bool highlighted,
  ) {
    return Container(
      padding: const EdgeInsets.all(32),

      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFF44444E) : Colors.white,

        borderRadius: BorderRadius.circular(30),

        border: Border.all(color: Colors.grey.shade500, width: 1.5),

        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          if (highlighted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),

              child: const Text(
                "MOST POPULAR",
                style: TextStyle(
                  color: Color(0xFF715A5A),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),

          if (highlighted) const SizedBox(height: 24),

          Text(
            title,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: highlighted ? Colors.white : const Color(0xFF37353E),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            price,
            style: TextStyle(
              fontSize: 46,
              fontWeight: FontWeight.bold,
              color: highlighted ? Colors.white : const Color(0xFF715A5A),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Perfect for modern construction management",
            style: TextStyle(
              fontSize: 16,
              color: highlighted ? Colors.white70 : Colors.black54,
            ),
          ),

          const SizedBox(height: 36),

          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 20),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Icon(
                    Icons.check_circle,
                    size: 24,
                    color: highlighted ? Colors.white : const Color(0xFF715A5A),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.4,
                        color: highlighted ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 58,

            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,

                backgroundColor: highlighted
                    ? Colors.white
                    : const Color(0xFF715A5A),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),

              onPressed: () {},

              child: Text(
                highlighted ? "Start Professional" : "Get Started",

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: highlighted ? const Color(0xFF44444E) : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
