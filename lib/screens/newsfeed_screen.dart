import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuazon_mobprog/widgets/post_card.dart';
import '../constants.dart';

class NewsfeedScreen extends StatelessWidget {
  const NewsfeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //UI
    return ListView(
      children: [
        PostCard(
          userName: 'Rene Barrios',
          postContent: 'LF: Graham Balls',
          likesCount: "321",
          commentsCount: 0,
          sharesCount: 3,
          date: DateTime.now().subtract(Duration(days: 1)),
          userImage: kGenericAvatar,
        ),
        buildAdvertisementCarousel(),
        PostCard(
          userName: 'Walang Pasok',
          postContent: 'Walang Pasok [August 18, 2026]',
          likesCount: "124",
          commentsCount: 0,
          sharesCount: 15,
          imagePath:
              'https://play-lh.googleusercontent.com/XxN2uh1U2LhLEvJisEVeJYsCtdAyyzJP8lA-fHCqqbZSBqNUJCa1DcisSSmFmQahKGFtVhXTghCLsOktq8mmZg',
          date: DateTime.now().subtract(Duration(minutes: 13)),
          userImage: kGenericAvatar,
        ),
        buildAdvertisementCarousel(),
        PostCard(
          userName: 'Vhan Hajj',
          postContent:
              '2️⃣+2️⃣=4️⃣ DEPENDENDE 😭🙏 SA 💀 ROAD 🛣️ MARKINGS 🚦 MERON 😭 DYAN 👈 ARROWS ⬅️➡️ SA 💀 ROAD 🛣️ MARKINGS 🚦 NOT ❌ ALL 💯 THE 🗣️ TIME ⏰ KALIWA ⬅️ IS 😭 KALIWA ⬅️ AND 💀 KANAN ➡️ IS 😭 KANAN ➡️, ANO ❓ MAY 🗣️ KALIWA ⬅️ BA 🤨 SA 💀 KANAN ➡️? MAY 😭 KALIWA ⬅️ BA 🤨 SA 💀 RIGHT ➡️? BOSS 🗣️ NILILITO 🤯 MO 👉 UNG 😭 MGA 💀 ATHLETES 🏃‍♂️ KO 💯! YUNG 😭 MGA 💀 ISTUDENTS 📚 KO 💯 TSAKA 😭, IDRINAWING ✍️ KO 💯 NA 😭 NGA 💀 EH 🗣️ DRINAWING ✍️ KO 💯 NA 😭 KUNG 🤨 ANO ❓ NAKALAGAY 📄 YUN 😭 LANG 💀 SASAGUTIN 📝! AND 😭 DEPENDE 🤯 PA 💀 SA 🚦 ROAD 🛣️ MARKINGS 🚦 DRINAWING ✍️ KO 💯 NA 😭 UNG 💀 SITWASYON 🗺️! PARA 😭 MONG 🗣️ SINABI 💬 "2️⃣+2️⃣=4️⃣ 🤓 HMM 🤔 DEPENDE 😭 KUNG 🤨 3️⃣ YAN 💀 KASI 😭 PAG 🤨 3️⃣ EDI 🗣️ FIVE ✋" SYEMPRE 😭🙏💀‼️🔥🗣️🤯🚨💯',
          likesCount: "412",
          commentsCount: 0,
          sharesCount: 6,
          date: DateTime.now().subtract(Duration(hours: 2)),
          userImage: kGenericAvatar,
        ),
        PostCard(
          userName: 'Ronald Rafael',
          postContent:
              'Last night 🌚⭐️ I 🙋had a dream 😴💭: Mayor Rody 🌚👃🏻 was granted 🙏🏻house 🏠 arrest 🚔. We 👽💃 had a tearful 😢😢😢reunion 👨‍❤️‍👨🤗. We hugged 👨‍❤️‍💋‍👨🫂each other & he whispered 🗣️🤫 to me;👰🏽‍♂️ "Ronald, I\'m 👃🏻👰🏽‍♂️ okey now." 💕🥰💖. Lord 🙏🏻🤲, pls 🛐 make my dream 💤💭come true.📿🧎‍➡️',
          likesCount: "1.2K",
          commentsCount: 0,
          sharesCount: 41,
          date: DateTime.now().subtract(Duration(hours: 4)),
          userImage: kGenericAvatar,
        ),
        PostCard(
          userName: 'Jamaine Grace',
          postContent:
              'hi idol!! Walang signal dito sa bukid pero nung nalaman kong nag post ka dali dali akong bumaba ng bukid, tumawid ako ng tatlong ilog, tinumbok ko ang pitong bundok, at umutang ako ng perang pamasahe papuntang syudad at namalimos pa ako para may pang hulog sa pisonet para lang maka heart react sa post mo. Sana manotice moko idol.',
          likesCount: "3.4K",
          commentsCount: 0,
          sharesCount: 156,
          date: DateTime.now().subtract(Duration(hours: 6)),
          userImage: kGenericAvatar,
        ),
        PostCard(
          userName: 'Princess Glyza',
          postContent:
              'hawak mo ang beat, hawak mo ang beat, hawak mo ang beat, hawak mo ang beat, dubai chewy cookie, ano tara? ilocos empanada, ano tara? scramble ng tomboy, ano tara? isang araw nag mamaneho ako sa laguna, beep beep beep beep beep beep, dubi dubi dap dap dubi dubi dap dap di dip didip didap, Maglaro tayo, Maglaro? gayahin mo ako',
          likesCount: "769",
          commentsCount: 0,
          sharesCount: 12,
          date: DateTime.now().subtract(Duration(hours: 9)),
          userImage: kGenericAvatar,
        ),
      ],
    );
  }

  List<Widget> carouselItems() {
    return [
      PostCard(
        userName: 'Brew & Bytes Café',
        postContent: 'Buy one, get one on every hand-brewed coffee — weekdays 2–5PM.',
        imagePath: 'assets/images/ad_cafe.png',
        date: DateTime.now(),
        adsMarket: 'Find a branch',
        userImage: kGenericAvatar,
      ),
      PostCard(
        userName: 'Loop Pay',
        postContent: 'Send money to any bank in seconds. Zero fees for your first 10 transfers.',
        imagePath: 'assets/images/ad_pay.png',
        date: DateTime.now(),
        adsMarket: 'Get the app',
        userImage: kGenericAvatar,
      ),
      PostCard(
        userName: 'NorthPeak Outfitters',
        postContent: 'Rainy season sale — up to 40% off jackets, packs, and trail shoes.',
        imagePath: 'assets/images/ad_outfitters.png',
        date: DateTime.now(),
        adsMarket: 'Shop the sale',
        userImage: kGenericAvatar,
      ),
      PostCard(
        userName: 'SkillForge Academy',
        postContent: 'Become a full-stack developer in 16 weeks. Next cohort starts soon.',
        imagePath: 'assets/images/ad_academy.png',
        date: DateTime.now(),
        adsMarket: 'Reserve a slot',
        userImage: kGenericAvatar,
      ),
      PostCard(
        userName: 'Verdant Greens',
        postContent: 'Fresh salads and grain bowls delivered to your desk before noon.',
        imagePath: 'assets/images/ad_greens.png',
        date: DateTime.now(),
        adsMarket: 'Order lunch',
        userImage: kGenericAvatar,
      ),
      PostCard(
        userName: 'TaskNest',
        postContent: 'One board for your whole team. Plan, track, and ship without the chaos.',
        imagePath: 'assets/images/ad_tasknest.png',
        date: DateTime.now(),
        adsMarket: 'Try it free',
        userImage: kGenericAvatar,
      ),
      PostCard(
        userName: 'Aurora Mobile',
        postContent: 'Unlimited 5G data at half the price. Switch your number in 5 minutes.',
        imagePath: 'assets/images/ad_mobile.png',
        date: DateTime.now(),
        adsMarket: 'See plans',
        userImage: kGenericAvatar,
      ),
    ];
  }

  Widget buildAdvertisementCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
          child: Row(
            children: [
              Text(
                'SPONSORED',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                  color: LOOP_MUTED,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: Divider(color: LOOP_BORDER)),
            ],
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            enableInfiniteScroll: false,
            height: 308.h,
            padEnds: false,
          ),
          items: carouselItems(),
        ),
      ],
    );
  }
}
