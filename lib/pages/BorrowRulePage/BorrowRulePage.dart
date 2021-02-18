import 'package:flutter/material.dart';

const List<String> _rules = [
  "凡持有本馆读者证者，均可凭证借阅图书。",
  "本馆图书采取开架为主闭架为辅的借阅方法。读者可进入规定开架书库选借图书，借书手续在借书处（出纳台）办理。入库时必须遵守《读者入库选书守则》和有关规定。",
  "持证读者，教工每证借书量不超过15册，研究生不超过10册，本、专科生不超过5册，成教生不超过3册，临时借书证不超过2册。",
  "借书期限：为1个月。借阅期满可续借1次。",
  "馆藏线装书、善本书、近10年进口原版书、部分工具书等珍贵图书以及期刊不外借，只限在阅览室阅览。馆藏机密资料（地形图）按照国家机密资料管理办法和学校机密资料借阅规定办理借阅手续。",
  "读者应按期归还所借图书。如过期不还也不办理续借手续， 从过期当天起计算借书逾期费，每册每天5分，累计到还书日止。所借书刊到期时适逢法定节假日、寒暑假，不计逾期费。",
  "预约借书。读者所需图书已被他人借走时，可填写\"预约借书单\"或电话、网上预约，书到后即通知预约人来馆办理借书手续。读者应在一周内到借书处办理借书手续，逾期不予保留。",
  "遇有特殊需要时，本馆有权随时催还借出的图书。"
      "本省其他高校师生持馆际互借介绍信来馆借阅图书资料者，按\"关于执行'湖北省高校图书馆通借通阅和文献传递协议'的试行办法\"执行，每次限借2册，按书刊价的3倍收取押金，借期1个月。逾期1天，收逾期费0.2元，逾期2个月不还者，押金抵偿所借书刊，并通知担保馆（发证馆）催还所借书刊。",
  "所借图书如有损坏遗失等情况，按《书刊遗失、损坏赔偿办法》处理。",
];

class BorrowRulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("借阅规则"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                _rules.length, (index) => Text("  $index、${_rules[index]}")),
          ),
        ),
      ),
    );
  }
}
