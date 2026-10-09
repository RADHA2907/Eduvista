import 'package:flutter/material.dart';

void main() => runApp(const EduVistaApp());
const navy = Color(0xFF172554);
const violet = Color(0xFF4F46E5);
const bg = Color(0xFFF4F6FF);

class EduVistaApp extends StatelessWidget {
  const EduVistaApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'EduVista', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: violet), scaffoldBackgroundColor: bg),
    home: const EduHome(),
  );
}

class EduHome extends StatefulWidget {
  const EduHome({super.key});
  @override
  State<EduHome> createState() => _EduHomeState();
}

class _EduHomeState extends State<EduHome> {
  int tab = 0, qIndex = 0, score = 0;
  bool quizDone = false;
  final noteInput = TextEditingController();
  final tutorInput = TextEditingController();
  final notes = <String>[];
  final chat = <Map<String, String>>[
    {'who':'tutor','text':'Hi! Ask me about photosynthesis, force, atoms, Ohm’s law, or quadratic equations.'}
  ];
  final questions = const [
    {'q':'Which organelle is called the powerhouse of the cell?','a':'Mitochondria','o':['Nucleus','Mitochondria','Ribosome','Golgi body']},
    {'q':'What is the SI unit of force?','a':'Newton','o':['Joule','Watt','Newton','Pascal']},
    {'q':'Which gas do plants absorb during photosynthesis?','a':'Carbon dioxide','o':['Oxygen','Nitrogen','Hydrogen','Carbon dioxide']},
    {'q':'What is the approximate value of g on Earth?','a':'9.8 m/s²','o':['3.8 m/s²','9.8 m/s²','12 m/s²','98 m/s²']},
    {'q':'What is the chemical symbol for sodium?','a':'Na','o':['So','S','Na','N']},
  ];

  @override
  void dispose() { noteInput.dispose(); tutorInput.dispose(); super.dispose(); }

  String explain(String question) {
    final s = question.toLowerCase();
    if (s.contains('photosynthesis')) return 'Photosynthesis is how green plants make food. Chlorophyll captures sunlight, and plants use water and carbon dioxide to make glucose and release oxygen. In short: carbon dioxide + water + light → glucose + oxygen.';
    if (s.contains('force') || s.contains('newton')) return 'Force is a push or pull that can change motion. Newton’s second law is F = m × a: force equals mass multiplied by acceleration. Its SI unit is the newton (N).';
    if (s.contains('ohm') || s.contains('resistance')) return 'Ohm’s law states V = I × R: voltage equals current multiplied by resistance, when physical conditions are constant.';
    if (s.contains('atom') || s.contains('electron')) return 'An atom has a nucleus containing protons and usually neutrons, with electrons around it. Protons are positive, electrons negative, and neutrons neutral.';
    if (s.contains('quadratic') || s.contains('math')) return 'For ax² + bx + c = 0, use x = (−b ± √(b² − 4ac)) / 2a. Identify a, b and c, then calculate the discriminant.';
    return 'Try breaking the topic into small steps: identify the key idea, list what you know, then solve one part at a time. This starter tutor works offline with sample explanations; open-ended AI requires connecting an AI service.';
  }

  void askTutor() {
    final text = tutorInput.text.trim();
    if (text.isEmpty) return;
    setState(() { chat.add({'who':'you','text':text}); chat.add({'who':'tutor','text':explain(text)}); tutorInput.clear(); });
  }

  Widget tile(IconData icon, String title, String sub, Color color, VoidCallback tap) => InkWell(
    onTap: tap, borderRadius: BorderRadius.circular(20),
    child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(backgroundColor: color, child: Icon(icon, color: navy)),
        const Spacer(), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4), Text(sub, style: const TextStyle(color: Colors.black54, fontSize: 12)),
      ]),
    ),
  );

  Widget home() => ListView(padding: const EdgeInsets.all(20), children: [
    const SizedBox(height: 4),
    const Text('Learn smarter.', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w800, color: navy)),
    const Text('Your ideas. Your pace. Your future.', style: TextStyle(color: Colors.black54)),
    const SizedBox(height: 20),
    Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF4338CA), Color(0xFF7C3AED)]), borderRadius: BorderRadius.circular(24)),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.auto_awesome, color: Colors.white, size: 30), SizedBox(height: 12),
        Text('Welcome to EduVista', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 7), Text('Understand concepts, practise questions, and keep your learning in one place.', style: TextStyle(color: Colors.white70, height: 1.4)),
      ])),
    const SizedBox(height: 22), const Text('Your study space', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: navy)), const SizedBox(height: 12),
    GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.15, children: [
      tile(Icons.chat_bubble_outline,'Study Tutor','Get explanations',const Color(0xFFE8E9FF),()=>setState(()=>tab=1)),
      tile(Icons.quiz_outlined,'Quick Quiz','Test your knowledge',const Color(0xFFFFEBD9),()=>setState(()=>tab=2)),
      tile(Icons.sticky_note_2_outlined,'My Notes',notes.length.toString()+' saved notes',const Color(0xFFDDF7EC),()=>setState(()=>tab=3)),
      tile(Icons.insights,'Progress',quizDone?'Last score: '+score.toString()+'/5':'Start your first quiz',const Color(0xFFE0F2FE),()=>setState(()=>tab=2)),
    ]),
    const SizedBox(height: 18), const Text('Quick tip', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: navy)),
    const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('Study for 25 minutes, then take a 5-minute break. Explain a concept in your own words to check your understanding.'))),
  ]);

  Widget tutor() => Column(children: [
    const Padding(padding: EdgeInsets.fromLTRB(20,16,20,6), child: Align(alignment: Alignment.centerLeft, child: Text('Study Tutor',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold,color:navy)))),
    const Padding(padding: EdgeInsets.symmetric(horizontal:20), child: Align(alignment:Alignment.centerLeft, child:Text('Offline sample tutor · Try photosynthesis, force, atoms, or Ohm’s law.',style:TextStyle(color:Colors.black54)))),
    Expanded(child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: chat.length, itemBuilder: (context,i) {
      final item=chat[i]; final mine=item['who']=='you';
      return Align(alignment:mine?Alignment.centerRight:Alignment.centerLeft, child: Container(constraints:const BoxConstraints(maxWidth:320),margin:const EdgeInsets.only(bottom:10),padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:mine?violet:Colors.white,borderRadius:BorderRadius.circular(18)),child:Text(item['text']!,style:TextStyle(color:mine?Colors.white:navy,height:1.4))));
    })),
    SafeArea(top:false, child:Padding(padding:const EdgeInsets.fromLTRB(12,4,12,10),child:Row(children:[
      Expanded(child:TextField(controller:tutorInput,onSubmitted:(_)=>askTutor(),decoration:const InputDecoration(hintText:'Ask a study question…',contentPadding:EdgeInsets.symmetric(horizontal:16,vertical:12)))),
      const SizedBox(width:8),IconButton.filled(onPressed:askTutor,icon:const Icon(Icons.send)),
    ]))),
  ]);

  Widget quiz() {
    if (quizDone) return Center(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,children:[
      const Icon(Icons.emoji_events,size:70,color:Color(0xFFF59E0B)),const SizedBox(height:12),
      const Text('Quiz complete!',style:TextStyle(fontSize:27,fontWeight:FontWeight.bold,color:navy)),
      Text('You scored '+score.toString()+' out of '+questions.length.toString(),style:const TextStyle(fontSize:18)),
      const SizedBox(height:18),FilledButton(onPressed:()=>setState(()=>{qIndex=0,score=0,quizDone=false}),child:const Text('Try again')),
    ])));
    final q=questions[qIndex];
    return ListView(padding:const EdgeInsets.all(20),children:[
      const SizedBox(height:8),const Text('Quick Quiz',style:TextStyle(fontSize:27,fontWeight:FontWeight.bold,color:navy)),
      const SizedBox(height:8),Text('Question '+(qIndex+1).toString()+' of '+questions.length.toString()),
      const SizedBox(height:10),LinearProgressIndicator(value:(qIndex+1)/questions.length,borderRadius:BorderRadius.circular(10)),
      const SizedBox(height:26),Text(q['q'] as String,style:const TextStyle(fontSize:21,fontWeight:FontWeight.w700,height:1.35)),
      const SizedBox(height:20),
      ...(q['o'] as List<String>).map((option)=>Padding(padding:const EdgeInsets.only(bottom:10),child:SizedBox(width:double.infinity,child:OutlinedButton(
        style:OutlinedButton.styleFrom(padding:const EdgeInsets.all(16),alignment:Alignment.centerLeft,backgroundColor:Colors.white),
        onPressed:()=>setState(()=>{if(option==q['a']) score++, if(qIndex==questions.length-1) quizDone=true else qIndex++}),
        child:Text(option,style:const TextStyle(fontSize:16)),
      )))),
      const SizedBox(height:12),Text('Score so far: '+score.toString(),style:const TextStyle(color:Colors.black54)),
    ]);
  }

  Widget notePage() => ListView(padding:const EdgeInsets.all(20),children:[
    const Text('My Notes',style:TextStyle(fontSize:27,fontWeight:FontWeight.bold,color:navy)),
    const SizedBox(height:6),const Text('Notes stay available while this app session is open.',style:TextStyle(color:Colors.black54)),
    const SizedBox(height:18),TextField(controller:noteInput,maxLines:3,decoration:const InputDecoration(hintText:'Write a concept, formula, or reminder…')),
    const SizedBox(height:10),FilledButton.icon(onPressed:(){
      final value=noteInput.text.trim(); if(value.isEmpty)return;
      setState(()=>{notes.insert(0,value),noteInput.clear()});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Note saved')));
    },icon:const Icon(Icons.save_outlined),label:const Text('Save note')),
    const SizedBox(height:18),
    if(notes.isEmpty) const Card(child:Padding(padding:EdgeInsets.all(18),child:Text('No notes yet. Add your first study note above.'))),
    ...notes.asMap().entries.map((e)=>Card(child:ListTile(leading:const Icon(Icons.sticky_note_2_outlined),title:Text(e.value),trailing:IconButton(icon:const Icon(Icons.delete_outline),onPressed:()=>setState(()=>notes.removeAt(e.key)))))),
  ]);

  Widget profile() => ListView(padding:const EdgeInsets.all(20),children:[
    const SizedBox(height:20),const CircleAvatar(radius:42,backgroundColor:Color(0xFFE0E7FF),child:Icon(Icons.school,size:42,color:violet)),
    const SizedBox(height:14),const Center(child:Text('EduVista Student',style:TextStyle(fontSize:23,fontWeight:FontWeight.bold,color:navy))),
    const Center(child:Text('Your personal learning space',style:TextStyle(color:Colors.black54))),const SizedBox(height:24),
    Card(child:Column(children:[
      const ListTile(leading:Icon(Icons.info_outline),title:Text('About EduVista'),subtitle:Text('An AI-powered visual learning platform concept.')),
      const Divider(height:1),ListTile(leading:const Icon(Icons.quiz_outlined),title:const Text('Quiz results'),subtitle:Text(quizDone?'Latest score: '+score.toString()+'/5':'Complete a quiz to see your score')),
      const Divider(height:1),ListTile(leading:const Icon(Icons.sticky_note_2_outlined),title:const Text('Saved notes'),subtitle:Text(notes.length.toString()+' notes in this session')),
    ])),
    const SizedBox(height:12),const Text('This first build is a local MVP. Login, cloud sync, persistent notes, real AI, voice learning, and diagram generation still need backend/API integration.',style:TextStyle(color:Colors.black54,height:1.45)),
  ]);

  @override
  Widget build(BuildContext context) {
    const labels=['EduVista','Study Tutor','Quick Quiz','My Notes','Profile'];
    final pages=[home(),tutor(),quiz(),notePage(),profile()];
    return Scaffold(
      appBar:AppBar(title:Row(children:[const Icon(Icons.auto_awesome,color:violet),const SizedBox(width:8),Text(labels[tab],style:const TextStyle(fontWeight:FontWeight.bold))])),
      body:SafeArea(child:pages[tab]),
      bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const[
        NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'Home'),
        NavigationDestination(icon:Icon(Icons.chat_bubble_outline),selectedIcon:Icon(Icons.chat),label:'Tutor'),
        NavigationDestination(icon:Icon(Icons.quiz_outlined),selectedIcon:Icon(Icons.quiz),label:'Quiz'),
        NavigationDestination(icon:Icon(Icons.sticky_note_2_outlined),selectedIcon:Icon(Icons.sticky_note_2),label:'Notes'),
        NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'Profile'),
      ]),
    );
  }
}
