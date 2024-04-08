import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:strideflex_application_1/model/shoesModel.dart';

class ProductContent extends StatefulWidget {
  const ProductContent({Key? key, required this.shoes}) : super(key: key);

  final ShoesModel shoes;

  @override
  State<ProductContent> createState() => _ProductContentState();
}

class _ProductContentState extends State<ProductContent> {
  int selected = 0;
  int counter = 0;

  void counterPlus() {
    setState(() {
      counter++;
    });
  }

  void counterMinus() {
    setState(() {
      counter--;

      if (counter < 0) {
        counter = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "${widget.shoes.nameShoes}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 70,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue.shade300,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  widget.shoes.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: widget.shoes.isLiked ? Colors.red : Colors.white,
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "${widget.shoes.description}",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            children: <Widget>[
              ...List.generate(
                  widget.shoes.colors.length,
                  (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = index;
                            });
                          },
                          child: ColorDots(
                            color: widget.shoes.colors[index],
                            isSelected: selected == index,
                          ),
                        ),
                      )),
              Spacer(),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ]),
                child: IconButton(
                    onPressed: counterMinus, icon: Icon(Icons.remove)),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                child: Text("${counter}"),
              ),
              SizedBox(width: 20),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ]),
                child:
                    IconButton(onPressed: counterPlus, icon: Icon(Icons.add)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ColorDots extends StatelessWidget {
  const ColorDots({
    super.key,
    required this.color,
    required this.isSelected,
  });

  final Color color;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(
              color: isSelected ? Colors.blue.shade700 : Colors.white,
              width: 3)),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
