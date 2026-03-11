import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {

  final String reason;

  const ResultScreen({super.key, required this.reason});

  List<String> suggestions() {

    if(reason == "Hungry"){
      return [
        "Feed the child immediately",
        "Help the child rest in a calm place",
        "Observe if crying reduces after feeding"
      ];
    }

    if(reason == "Gas Pain"){
      return [
        "Gently massage baby's tummy",
        "Burp the baby after feeding",
        "Keep baby upright for some time"
      ];
    }

    if(reason == "Sleepy"){
      return [
        "Put baby in a quiet room",
        "Reduce noise and light",
        "Rock baby gently"
      ];
    }

    if(reason == "Possible fever"){
      return [
        "Remove excess clothing",
        "Keep the child hydrated",
        "Monitor body temperature closely",
        "Consult a pediatrician if symptoms persist"
      ];
    }

    return [
      "Check diaper condition",
      "Ensure comfortable clothing",
      "Hold and comfort the child"
    ];
  }

  @override
  Widget build(BuildContext context) {

    final tips = suggestions();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analysis Result"),
        backgroundColor: const Color(0xFF0F9D8F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [

                    const Icon(Icons.info,color: Colors.teal),

                    const SizedBox(width: 10),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Possible Reason",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        Text(reason)
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height:20),

            const Text(
              "Suggested Actions",
              style: TextStyle(fontSize:18,fontWeight: FontWeight.bold),
            ),

            const SizedBox(height:10),

            ...tips.map((tip)=>Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.check_circle,color: Colors.green),
                title: Text(tip),
              ),
            )),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F9D8F)),
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("Continue"),
              ),
            )

          ],
        ),
      ),
    );
  }
}