import 'package:get/get.dart';

class ModeController extends GetxController {
  var mode = false.obs;
}

// Untuk pesan alert
String alertMessage = '''
To ensure a seamless experience tailored to your needs, we encourage you to initiate a conversation with the seller before placing your order.

Why Contact the Seller?
- Discuss and finalize the details of the onsite service.
- Coordinate the preferred date, time, and location.
- Confirm any specific requirements or questions you may have.

How to Contact the Seller:
1. Click on the 'Chat' button to start a conversation.
2. Introduce yourself and express your interest in the onsite service.
3. Work together with the seller to decide on the perfect arrangements.

Benefits of Communication:
- Personalized service to meet your specific requirements.
- Clarification on any doubts or queries you may have.
- Ensure a smooth and enjoyable experience for both you and the seller.
''';

String deactiveNotice = '''
Before you proceed with deactivating your account, please ensure that you have completed all your ongoing orders and have withdrawn any remaining balance in your account. This helps in maintaining a smooth transition and ensures that you fulfill your commitments to our clients.

Finish Orders: Review your active projects and make sure that you have completed all pending tasks and delivered the work to your clients.

Withdraw Balance: Transfer any remaining funds in your account to your preferred payment method. You can do this by visiting your account settings.

Once you have completed these steps, you can proceed with deactivating your account. Please note that deactivating your account will result in the loss of access to your account.
''';

String lorem =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

// Menampilkan isi data kategori dan sub kategori
List<String> listDigitalMarketing = [
  "Affiliate Marketing",
  "Book & eBook Marketing",
  "Community Management",
  "Crowdfunding",
  "Display Advertising",
  "E-Commerce Marketing",
  "Email Marketing",
  "Guest Posting",
  "Influencer Marketing",
  "Local SEO",
  "Marketing Advice",
  "Marketing Strategy",
  "Mobile App Marketing",
  "Music Promotion",
  "Podcast Marketing",
  "Public Relations",
  "Search Engine Marketing (SEM)",
  "Search Engine Optimization (SEO)",
  "Social Media Advertising",
  "Social Media Marketing",
  "Text Message Marketing",
  "Video Marketing",
  "Web Analytics",
];

List<String> listGraphicsAndDesign = [
  "AI Artists",
  "Album Cover Design",
  "App Design",
  "Architecture & Interior Design",
  "Book Design",
  "Brand Style Guides",
  "Brochure Design",
  "Building Engineering",
  "Building Information Modeling",
  "Business Cards & Stationery",
  "Cartoons & Comics",
  "Character Modeling",
  "Fashion Design",
  "Flyer Design",
  "Game Art",
  "Graphics for Streamers",
  "Illustration",
  "Image Editing",
  "Industrial & Product Design",
  "Infographic Design",
  "Jewelry Design",
  "Logo Design",
  "NFT Art",
  "Packaging & Label Design",
  "Portraits & Caricatures",
  "Presentation Design",
  "Social Media Design",
  "T-Shirts & Merchandise",
  "UX Design",
  "Website Design",
];

List<String> listWritingAndTranslation = [
  "Articles & Blog Posts",
  "Book & eBook Writing",
  "Book Editing",
  "Brand Voice & Tone",
  "Business Names & Slogans",
  "Case Studies",
  "Cover Letters",
  "Creative Writing",
  "Email Copy",
  "Grant Writing",
  "LinkedIn Profiles",
  "Podcast Writing",
  "Press Releases",
  "Product Descriptions",
  "Proofreading & Editing",
  "Research & Summaries",
  "Resume Writing",
  "Sales Copy",
  "Scriptwriting",
  "Social Media Copy",
  "Speechwriting",
  "Technical Writing",
  "Transcription",
  "Translation",
  "UX Writing",
  "Website Content",
  "White Papers",
  "eLearning Content Development",
];

List<String> listBussines = [
  "Business Consulting",
  "Business Plans",
  "CRM Management",
  "Customer Care",
  "E-Commerce Management",
  "ERP Management",
  "Event Management",
  "Fact Checking",
  "Financial Consulting",
  "Game Concept Design",
  "HR Consulting",
  "Legal Consulting",
  "Market Research",
  "Presentations",
  "Project Management",
  "Sales",
  "Supply Chain Management",
  "Virtual Assistant",
];

List<String> listProgrammingAndTech = [
  "AI Applications",
  "Blockchain & Cryptocurrency",
  "Chatbots Development",
  "Convert Files",
  "Cybersecurity & Data Protection",
  "Desktop Applications",
  "DevOps & Cloud",
  "Development for Streamers",
  "Electronics Engineering",
  "Game Development",
  "Mobile Apps",
  "NFT Development",
  "Online Coding Lessons",
  "QA & Review",
  "Support & IT",
  "User Testing",
  "Web Programming",
  "Website Development",
  "Website Maintenance",
];

List<String> listMusicAndAudio = [
  "Audio Ads Production",
  "Audio Editing",
  "Audio Logo & Sonic Branding",
  "Audiobook Production",
  "Beat Making",
  "DJ Drops & Tags",
  "DJ Mixing",
  "Meditation Music",
  "Mixing & Mastering",
  "Music & Audio Advice",
  "Music Transcription",
  "Online Music Lessons",
  "Podcast Production",
  "Producers & Composers",
  "Remixing & Mashups",
  "Session Musicians",
  "Singers & Vocalists",
  "Songwriters",
  "Sound Design",
  "Synth Presets",
  "Vocal Tuning",
  "Voice Over",
];

List<String> listVideoAndAudio = [
  "3D Product Animation",
  "Animated Explainers",
  "Animated GIFs",
  "Animation for Kids",
  "Animation for Streamers",
  "App & Website Previews",
  "Article to Video",
  "Book Trailers",
  "Character Animation",
  "Corporate Videos",
  "E-Commerce Product Videos",
  "Filmed Video Production",
  "Game Trailers",
  "Intro & Outro Videos",
  "Live Action Explainers",
  "Logo Animation",
  "Lottie & Web Animation",
  "Music Videos",
  "NFT Animation",
  "Real Estate Promos",
  "Screencasting Videos",
  "Slideshow Videos",
  "Social Media Videos",
  "Spokespersons Videos",
  "Subtitles & Captions",
  "Video Ads & Commercials",
  "Video Editing",
  "Videographers",
  "Visual Effects",
];

List<String> listData = [
  "Data Analythics",
  "Data Engineering",
  "Data Entry",
  "Data Processing",
  "Data Science & AI",
  "Data Visualization",
  "Database",
];

List<String> listPhotography = [
  "Aerial Photographers",
  "Event Photographers",
  "Food Photographers",
  "Lifestyle & Fashion Photographers",
  "Photography Advice",
  "Portrait Photographers",
  "Product Photographers",
  "Real Estate Photographers",
];

List<String> listLifestyle = [
  "Arts & Crafts",
  "Astrology & Psychics",
  "Career Counseling",
  "Collectibles",
  "Cosmetics Formulation",
  "Family & Genealogy",
  "Fitness",
  "Game Coaching",
  "Gaming",
  "Greeting Cards & Videos",
  "Life Coaching",
  "Modeling & Acting",
  "Nutrition",
  "Online Tutoring",
  "Personal Stylists",
  "Puzzle & Game Creation",
  "Traveling",
  "Trend Forecasting",
  "Wellness",
];

List<String> listOther = [
  "Other",
];

List<String> listProfession = [
  'Digital Marketing',
  'Graphics & Design',
  'Writing & Translation',
  'Business',
  'Programming & Tech',
  'Music & Audio',
  'Video & Animation',
  'Data',
  'Photography',
  'Lifestyle',
  'Other',
];
