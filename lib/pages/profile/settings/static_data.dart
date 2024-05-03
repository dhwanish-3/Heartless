import 'package:heartless/services/enums/activity_status.dart';
import 'package:heartless/services/enums/activity_type.dart';
import 'package:heartless/services/enums/user_type.dart';
import 'package:heartless/shared/models/activity.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/demonstration.dart';

class StaticData {
  static final AppUser user = AppUser.getInstance(UserType.patient)
    ..name = 'John Doe'
    ..email = 'johndoe2000@gmail.com'
    ..password = 'password'
    ..imageUrl =
        'https://img.freepik.com/free-photo/outdoor-shot-young-caucasian-man-with-beard-relaxing-open-air-surrounded-by-beautiful-mountain-setting-rainforest_273609-1855.jpg?size=626&ext=jpg&ga=GA1.1.553209589.1714435200&semt=ais';

  static final List<Activity> activityList = [
    Activity()
      ..name = 'Peas with Porridge'
      ..description = 'Eat peas with porridge'
      ..time = DateTime(2021, 10, 10, 6, 30)
      ..type = ActivityType.diet
      ..status = ActivityStatus.completed,
    Activity()
      ..name = 'Apixaban'
      ..description = 'take 2.5 milligrams of the drug'
      ..time = DateTime(2021, 10, 10, 12, 30)
      ..type = ActivityType.medicine
      ..status = ActivityStatus.upcoming,
    Activity()
      ..name = 'Evening Walk'
      ..description = 'Walk for 30 minutes'
      ..time = DateTime(2021, 10, 10, 17, 0)
      ..type = ActivityType.exercise
      ..status = ActivityStatus.upcoming,
  ];

  static final List<AppUser> supervisorList = [
    AppUser()
      ..name = 'Dr. Thomas Reus'
      ..imageUrl =
          'https://www.stockvault.net/data/2015/09/01/177580/preview16.jpg',
  ];

  static List<Demonstration> previewList = [
    Demonstration(
        title: "Deep Breathing",
        imageUrl: "assets/illustrations/demonstration/deepBreathing.jpeg",
        videoUrl: "",
        sections: []),
    Demonstration(
        title: "Cycling",
        imageUrl: "assets/illustrations/demonstration/cycling.jpeg",
        videoUrl: "",
        sections: []),
    Demonstration(
        title: "Squats",
        imageUrl: "assets/illustrations/demonstration/squat.jpg",
        videoUrl: "",
        sections: []),
    Demonstration(
        title: "Arm Raises",
        imageUrl: "assets/illustrations/demonstration/armRaises.jpeg",
        videoUrl: "",
        sections: []),
    Demonstration(
        title: "Stretching",
        imageUrl: "assets/illustrations/demonstration/stretching.jpeg",
        videoUrl: "",
        sections: []),
    Demonstration(
        title: "CPR",
        imageUrl: "assets/illustrations/demonstration/cpr.jpeg",
        videoUrl: "",
        sections: []),
  ];

  static List<Demonstration> protocols = [
    Demonstration(
        title: "CPR",
        imageUrl: "assets/illustrations/demonstration/cpr.jpeg",
        videoUrl:
            "https://firebasestorage.googleapis.com/v0/b/heartless-17b56.appspot.com/o/demos%2FArc%20on%20Windows.%20Download%20now..mp4?alt=media",
        sections: [
          Section(
            title: 'Instructions',
            points: [
              "CHECK the scene for safety, form an initial impression and use personal protective equipment (PPE)",
              "If the person appears unresponsive, CHECK for responsiveness, breathing, life-threatening bleeding or other life-threatening conditions using shout-tap-shout",
              "If the person does not respond and is not breathing or only gasping, CALL emergency and get equipment, or tell someone to do so",
              "Kneel beside the person. Place the person on their back on a firm, flat surface",
              "Give 30 chest compressions",
              "Hand position: Two hands centered on the chest",
              "Body position: Shoulders directly over hands; elbows locked",
              "Depth: At least 2 inches",
              "Rate: 100 to 120 per minute",
              "Allow chest to return to normal position after each compression"
                  "Give 2 breaths",
              "Open the airway to a past-neutral position using the head-tilt/chin-lift technique",
              "Pinch the nose shut, take a normal breath, and make complete seal over the person’s mouth with your mouth.",
              "Ensure each breath lasts about 1 second and makes the chest rise; allow air to exit before giving the next breath",
              "Note: If the 1st breath does not cause the chest to rise, retilt the head and ensure a proper seal before giving the 2nd breath If the 2nd breath does not make the chest rise, an object may be blocking the airway",
              "Continue giving sets of 30 chest compressions and 2 breaths. Use an AED as soon as one is available! Minimize interruptions to chest compressions to less than 10 seconds."
            ],
          ),
          Section(title: 'When to use', points: [
            "Use CPR when an adult is not breathing at all. For a child or infant, use CPR when they are not breathing normally. Always use CPR if the adult or child is not responding when you talk to them or tap them.",
            "If someone is not breathing, giving CPR can ensure that oxygen-rich blood reaches the brain. This is important, as without oxygen, someone can sustain permanent brain damage or die in under 8 minutes.",
            "A person might need CPR if they stop breathing in any of the following circumstances:",
            "a cardiac arrest or heart attack",
            "choking",
            "a road traffic accident",
            "near-drowning",
            "suffocation",
            "poisoning",
            "a drug or alcohol overdose",
            "smoke inhalation",
            "electrocution",
            "suspected sudden infant death syndrome",
          ]),
          Section(title: 'References', points: [
            "video: Victor Chang Cardiac Research Institute",
            "https://www.medicalnewstoday.com/articles/324712",
            "https://www.redcross.org/take-a-class/cpr/performing-cpr/cpr-steps",
          ])
        ]),
  ];

  static List<Demonstration> breathingDemos = [
    Demonstration(
        title: "Deep Breathing",
        imageUrl: "assets/illustrations/demonstration/deepBreathing.jpeg",
        videoUrl:
            "https://firebasestorage.googleapis.com/v0/b/heartless-17b56.appspot.com/o/demos%2FArc%20on%20Windows.%20Download%20now..mp4?alt=media",
        sections: [
          Section(title: "Benefits", points: [
            " In particular, engaging in aerobic exercise that increases your heart rate (such as walking, jogging, or swimming) is a leading way to promote a healthy heart. ",
            "Deep breathing, also known as high-resistance inspiratory muscle strength training (IMST), is a form of exercise that can bring several different benefits to your heart health. ",
            "your cardiovascular and nervous systems are closely connected, such that the areas of your brain that dictate and regulate your heart rate and blood pressure closely align with those of your brain that regulate your breathing patterns.",
            "The changes in your heart chambers and blood vessels can cause your blood vessels to expand, thanks to endothelial cells. Endothelial cells line your blood vessels, and these cells promote nitric oxide production.",
            "When your body produces more nitric oxide, you can experience increased blood flow to your heart and throughout your body. In turn, the elevated blood flow can improve your overall circulation, lower your blood flow, and even has the potential to prevent the buildup of heart-disease-causing plaque in your arteries. ",
            "The study found that doing 30 breaths per day, as part of a breathing exercise routine, for just six weeks already lowered patients' systolic blood pressure by about 9 mm of mercury (9 mmHg).",
            "The study also found that six weeks of IMST breath exercises can also increase endothelial cell function by up to 45%.",
            "These results align with how much aerobic exercise can lower blood pressure.",
          ]),
          Section(title: "Slow Breathing", points: [
            "To engage in slow breathing, take a deep breath in through your nose and count to four.",
            "Pause, then exhale for four seconds.",
            "Next, inhale for five seconds, and exhale for five seconds.",
            "Now that you’ve warmed up for two breath cycles, alter your breath patterns such that your exhales slowly become longer than your inhales.",
            "So, the next time you inhale, inhale for five seconds again, but this time exhale for six to seven seconds. Gradually increase your exhale-to-inhale ratio as you engage in slow, deep breaths for this exercise. "
          ]),
          Section(title: "References", points: [
            "https://www.cardahealth.com/post/breathing-exercises-to-strengthen-heart",
          ]),
        ]),
    Demonstration(
        title: "Alternate Nostril Breathing",
        imageUrl:
            "assets/illustrations/demonstration/alternateNostrilBreathing.png",
        videoUrl:
            "https://firebasestorage.googleapis.com/v0/b/heartless-17b56.appspot.com/o/demos%2FArc%20on%20Windows.%20Download%20now..mp4?alt=media",
        sections: [
          Section(title: "Instructions", points: [
            "Often part of yoga or meditation routines, alternate nostril breathing is a calming technique that can help center your breaths and promote cardiovascular strength.",
            "With this technique, begin by placing a left finger on your left nostril. Inhale, and hold your breath.",
            "Before you exhale, move your left finger over to cover your right nostril.",
            "Then, exhale, letting the air out of the opposite nostril from which you inhaled.",
            "Repeat this technique with your right nostril covered as you inhale and your left nostril covered as you exhale. "
          ]),
          Section(title: "References", points: [
            "https://www.cardahealth.com/post/breathing-exercises-to-strengthen-heart",
            "intosport-Alternate Nostril Breathing Yoga",
            "https://clarity.app/alternate-nostril-breathing/"
          ]),
        ]),
    Demonstration(
        title: "Diaphragm Breathing",
        imageUrl: "assets/illustrations/demonstration/diaphragmBreathing.jpeg",
        videoUrl:
            "https://firebasestorage.googleapis.com/v0/b/heartless-17b56.appspot.com/o/demos%2FArc%20on%20Windows.%20Download%20now..mp4?alt=media",
        sections: [
          Section(title: "Benefits", points: [
            "Chronic stress can have harmful effects on the mind and body by activating the body’s fight-or-flight response. Techniques like diaphragmatic breathing can counteract this effect.",
            "Diaphragmatic breathing — also called belly breathing — is a type of breathing that signals your body to calm down. It is slow and deep, and your belly rises and falls with each breath.",
            "The benefits of diaphragmatic breathing go beyond mental health. It can lower heart rate, blood pressure, and may also be helpful in certain health conditions."
          ]),
          Section(title: "Instructions", points: [
            "Diaphragm breathing, or belly breathing, begins by taking a deep breath through your nose.",
            "As you deeply inhale, notice the air filling your belly, causing it to rise.",
            "It may help to place your hand on your stomach so that you can tangibly notice it rise as you fill your lungs with air.",
            "After you take a long, deep breath in through your nose, slowly exhale through your mouth, letting the air out.",
            "Try to draw out your exhale to be even longer than your inhale, and throughout the process, feel your belly slowly falling as the air exits your lungs and mouth."
          ]),
          Section(title: "References", points: [
            "https://www.cardahealth.com/post/breathing-exercises-to-strengthen-heart",
            "Group HIIT-Diaphragmatic Breathing (Standing) - How to Demo",
            "https://www.goodrx.com/conditions/stress/diaphragmatic-breathing-exercises"
          ]),
        ]),
    Demonstration(
        title: "Pursed Lip Breathing",
        imageUrl: "assets/illustrations/demonstration/pursedLipBreathing.jpeg",
        videoUrl:
            "https://firebasestorage.googleapis.com/v0/b/heartless-17b56.appspot.com/o/demos%2FArc%20on%20Windows.%20Download%20now..mp4?alt=media",
        sections: [
          Section(title: "Benefits", points: [
            "Improves ventilation.",
            "Releases trapped air in your lungs.",
            "Keeps your airways open longer and decreases your effort to breathe.",
            "Prolongs breathing out to slow your breathing rate.",
            "Improves breathing patterns by moving old air out of your lungs and allowing new air to enter.",
            "Relieves shortness of breath.",
            "Causes general relaxation."
          ]),
          Section(title: "Instructions", points: [
            "Relax your neck and shoulder muscles.",
            "Breathe in (inhale) slowly through your nose for two seconds with your mouth closed. You don’t need to take a deep breath; a normal breath is OK. It may be helpful to count to yourself. You should feel your stomach slowly get larger as you inhale. Some find it helpful to put their hands on their stomach."
                "Purse (pucker) your lips as though you’re going to whistle or gently blow on a hot drink.",
            "Breathe out (exhale) slowly and gently through your pursed lips for four or more seconds. It may be helpful to count to yourself. You should feel your stomach slowly shrink as you exhale.",
            "Pursed lip breathing may feel awkward or uncomfortable at first. However, with regular practice, the technique will become easier. The following tips will help pursed lip breathing become more natural for you:",
            "Don’t force the air out of your lungs.",
            "Always breathe out longer than you breathe in.",
            "Breathe slowly and easily — in and out — until you’re in complete control of your breathing."
          ]),
          Section(title: "References", points: [
            "https://www.cardahealth.com/post/breathing-exercises-to-strengthen-heart",
            "FullScript-Pursed Lip Breathing 101",
            "https://www.goodrx.com/conditions/stress/diaphragmatic-breathing-exercises",
            "https://my.clevelandclinic.org/health/treatments/9443-pursed-lip-breathing"
          ]),
        ]),
  ];

  static List<Demonstration> cardioWorkoutDemos = [
    Demonstration(
        title: "Stretching",
        imageUrl: "assets/illustrations/demonstration/stretching.jpeg",
        videoUrl:
            "https://firebasestorage.googleapis.com/v0/b/heartless-17b56.appspot.com/o/demos%2FArc%20on%20Windows.%20Download%20now..mp4?alt=media",
        sections: [
          Section(title: 'Benefits', points: [
            "stretching promotes blood flow to the regions being stretched",
            "Having adequate flexibility plays an integral role in your ability to do day-to-day tasks and ensures mobility and a full range of motion across your joints.",
            "it can help prevent injuries",
            "Holding static stretches can also constitute a light exercise and be a great way of getting your heart rate up.",
            "Stretching also helps improve flexibility in muscle groups that tend to become less flexible due to age and a sedentary lifestyle",
            "Stretches like hamstring or calf stretches can be particularly helpful for mobility and are worth adding to your regular exercise program",
          ]),
          Section(title: 'Instructions', points: [
            "Warm up before stretching",
            "Hold each stretch for 15-30 seconds",
            "Repeat each stretch 2-4 times",
            "Stretch both sides",
            "Breathe deeply and slowly while stretching",
            "Don’t bounce",
            "Don’t stretch to the point of pain",
            "Don’t hold your breath",
            "Don’t stretch injured muscles",
          ]),
          Section(title: "Self-Myofascial Release (SMR)", points: [
            "This form of stretching involves using items such as a foam roller, lacrosse balls, and similar objects to reduce trigger points, or “knots”, within muscles.",
            "When muscles are tight or have “knots”, gentle pressure can help release these “knots” to allow the muscle fibers to return to a straighter alignment and release pressure.",
            "When performing a myofascial release, it’s important that when you find a “trigger point”, that you hold pressure on that area for a minimum of 30 seconds.",
            " This is a great form of stretching to use before exercise and even before other forms of stretching!",
          ]),
          Section(title: "Static Stretching", points: [
            "Static stretching is probably the most commonly known form of stretching.",
            "It involves lengthening a muscle to its furthest point and holding that position for a minimum of 30 seconds.",
            "This type of stretching can help lengthen overactive, or tight muscles, and there’s evidence to show this type of stretching increases flexibility over time if performed daily.",
          ]),
          Section(title: "Active Stretching", points: [
            "Active stretching is a form of stretching in which you use the strength of a certain muscle group to lengthen or stretch an opposing muscle group.",
            "Yoga is a great example in which certain poses require activation or contraction of certain muscle groups as a way to stretch the opposing muscle.",
            "Active stretching can help increase range of motion and is a great warm-up activity before initiating high-intensity exercise or sports competition.",
          ]),
          Section(title: "Dynamic Stretching", points: [
            "Dynamic stretching is movement-based stretching.",
            "It requires working muscles through a range of motion to increase flexibility and mobility.",
            "Unlike static and active stretching, these poses are not held.",
            "Dynamic stretching is also a great form of stretching to warm up muscle groups before initiating high-intensity exercise or sports competition."
          ]),
          Section(title: 'References', points: [
            "https://www.cardahealth.com/post/cardiac-rehab-exercises",
            "yes2next",
            "https://blog.nasm.org/the-benefits-of-stretching",
          ]),
        ]),
    Demonstration(
        title: "Cycling",
        imageUrl: "assets/illustrations/demonstration/cycling.jpeg",
        videoUrl:
            "https://firebasestorage.googleapis.com/v0/b/heartless-17b56.appspot.com/o/demos%2FArc%20on%20Windows.%20Download%20now..mp4?alt=media",
        sections: [
          Section(title: "Benefits", points: [
            "Cardio is an essential aspect of cardiac rehabilitation, and cycling is an excellent low-impact exercise that people can do at nearly all fitness levels.",
            "Upright stationary bikes, recumbent stationary bikes, and cycling bikes are just some of the options available.",
            "These machines can be great for placing your cardiovascular system at a healthy stress level.",
            "These bikes work the large muscle groups of the legs, which can help retain strength in these muscles necessary for mobility.",
            "The legs, however, are not the only part of the body that can benefit from cycling. An arm ergometer is a form of cycling that targets the upper body by having your arms move in a circular or elliptical movement.",
            "Aids Digestion: Studies show that cycling reduces the time food takes to pass through the large intestine. This leads to less water being absorbed by the body and the formation of softer stools. Moreover, it prevents bloating.",
            "Improves Mental Health: Cycling is a great way to reduce stress, anxiety, and depression. It releases endorphins, which are known as the happy hormones. It also boosts self-esteem and confidence.",
          ]),
          Section(title: "Studies", points: [
            "Study published in the journal Circulation, it was discovered that regular cyclists suffer 15 per cent fewer heart attacks than non-cyclists. Researchers also found that even a small amount of time spent on cycling activity reduces the risk of heart disease.",
            "particularly beneficial for those who are overweight or have joint and muscle problems, according to the British Cycling Federation (BCF). The BCF encourages cyclists to take up a sport that involves weight-bearing exercise, such as cycling. Besides improving endurance and aerobic capacity, cycling also strengthens muscles like calves, thighs, and backs. Furthermore, it is a great stress reliever.",
            "The Copenhagen Heart Study, which tracked over 5000 people for 14 years, showed a dramatic reduction in coronary heart disease death rates associated with high-intensity cycling.",
            "According to reports, between 3.2 million and 5.3 million people worldwide die each year because they do not get enough physical activity. Physical activity lowers the risk of many health problems, including heart disease, type 2 diabetes, cancer, and depression.",
          ]),
          Section(
            title: "Beginner Instructions",
            points: [
              "Warm up before cycling",
              "Adjust the seat height so that your legs are almost straight when the pedals are at the lowest point",
              "Adjust the handlebars so that you can reach them comfortably",
              "Start pedaling slowly and gradually increase your speed",
              "Keep your back straight and your shoulders relaxed",
              "Keep your head up and look straight ahead",
              "Use the resistance settings to increase the intensity of your workout",
              "Cool down after cycling",
            ],
          ),
          Section(title: 'References', points: [
            "https://www.cardahealth.com/post/cardiac-rehab-exercises",
            "https://www.polygonbikes.com/can-cycling-help-you-lose-weight-heres-the-right-way-to-do-it/"
          ]),
        ]),
    Demonstration(
      title: "Arm Raises",
      imageUrl: "assets/illustrations/demonstration/armRaises.jpeg",
      videoUrl:
          "https://firebasestorage.googleapis.com/v0/b/heartless-17b56.appspot.com/o/demos%2FArc%20on%20Windows.%20Download%20now..mp4?alt=media",
      sections: [
        Section(
          title: "Beginner Instructions",
          points: [
            "Stand with the feet shoulder width apart or less and grasp the dumbbells with an overhand grip. The dumbbells may rest on the thighs but they should be relatively in-line with each respective shoulder.",
            "Either perform one arm at a time (all the repetitions straight through for one set) or alternate sides for this exercise. It is uncommon to raise both dumbbells at the same time, though it may be performed in that manner.",
            "Raise the arm to horizontal (or slightly above), exhaling throughout the movement.",
            "Lower the arm to the starting position (to the thigh), inhaling throughout the movement. For an additional challenge, when in the lowered position do not allow the dumbbell to rest on the thigh, instead keep the dumbbell slightly in front of it (an inch or so).",
            "Repeat steps 3-4 for as many repetitions as are desired either alternating arms between each repetition or exercising each shoulder individually. (Sets should generally fall between 3 to 6 with 6-12 repetitions.)"
          ],
        ),
        Section(title: 'References', points: [
          "https://sworkit.com/exercise/arm-raises",
          "https://bak.una.edu.ar/enx/lateral-dumbbell-raise/"
        ]),
      ],
    ),
    Demonstration(
        title: "Squats",
        imageUrl: "assets/illustrations/demonstration/squat.jpg",
        videoUrl:
            "https://firebasestorage.googleapis.com/v0/b/heartless-17b56.appspot.com/o/demos%2FArc%20on%20Windows.%20Download%20now..mp4?alt=media",
        sections: [
          Section(title: "Instructions", points: [
            "Start with feet slightly wider than hip-width apart, toes turned slightly out.",
            "Keeping your chest up and out and the pressure even in your feet, engage your abdominals and shift your weight back into your heels as you push your hips back.",
            "Lower yourself into a squat until either your heels begin to lift off the floor, or until your torso begins to round or flex forward. Your depth should be determined by your form.",
            "Keep your chest out and core tight as you push through your heels to stand back up to your starting position. Squeeze your glutes at the top.",
            "Perform 10–15 reps. Work up to 3 sets"
          ]),
          Section(title: "Benefits", points: [
            "Strengthens your core: Having strong core muscles can make everyday movements like turning, bending, and even standing easier. Not only that, but a strong core can improve your balance, ease pain in your low back, and also make it easier to maintain good posture.",
            "Reduces risk of injury:  you’re better able to execute full-body movements with correct form, balance, mobility, and posture",
            "Crushes Calories: For example, according to Harvard Medical School, a 155-pound person can burn approximately 223 calories doing 30-minutes of vigorous strength or weight training exercises, like squats.",
            "Boosts athletic ability and strength",
            "Strengthens the muscles of your lower body",
          ]),
          Section(title: 'References', points: [
            "Rogue Fitness-Movement Demo - The Squat",
            "https://www.healthline.com/health/exercise-fitness/squats-benefits#What-benefits-can-you-get-from-squat-variations?",
            "https://barbend.com/what-muscles-do-squats-work/"
          ]),
        ]),
  ];
}
