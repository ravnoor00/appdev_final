import 'package:flutter/material.dart';

import 'models/question.dart';

String appName = "Study App";

Color bgColor = Color.fromARGB(255, 246, 245, 240);
Color yellow = Color.fromARGB(255, 247, 242, 227);
Color redorange = const Color(0xffEB5E27);
Color textField = const Color(0xffF2EDDF);

void navigate(
  Widget w,
  BuildContext context,
) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => w),
  );
}

String fillerNetworkImage =
    "https://i.seadn.io/gae/2hDpuTi-0AMKvoZJGd-yKWvK4tKdQr_kLIpB_qSeMau2TNGCNidAosMEvrEXFO9G6tmlFlPQplpwiqirgrIPWnCKMvElaYgI-HiVvXc?auto=format&w=1000";

QuestionsList temporaryUtil = QuestionsList([
  {'question': 'is jeffrey gay', 'answer': 'yes he is'},
  {'question': 'is jeffrey gay', 'answer': 'yes he is'},
  {'question': 'is jeffrey gay', 'answer': 'yes he is'}
], 'hi', false, 'random');


