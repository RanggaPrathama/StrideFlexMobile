import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:strideflex_application_1/model/shoesModelAPI.dart';
import 'package:strideflex_application_1/services/wishlistService.dart';

class ShoesCard extends StatefulWidget {
  const ShoesCard({
    Key? key,
    required this.shoes,
    required this.action,
    required this.idUser,
    required this.isLiked,
    required this.refreshPage,
  }) : super(key: key);

  final ShoesModel shoes;
  final VoidCallback action;
  final bool isLiked;
  final int idUser;
  final VoidCallback refreshPage;

  @override
  _ShoesCardState createState() => _ShoesCardState();
}

class _ShoesCardState extends State<ShoesCard> {
  late bool isFavorite;
  final WishListService wishlistService = WishListService();

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isLiked ?? false;
  }

  Future<void> toggleLiked() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    // try {
    if (isFavorite) {
      print("tambah like");
      await wishlistService.addWishlist(
        widget.idUser,
        widget.shoes.idDetailSepatu!,
      );
    } else {
      print("hapuslIKED");
      await wishlistService.deleteWishlist(
        widget.idUser,
        widget.shoes.idDetailSepatu!,
      );
    }
    widget.refreshPage();
    // } catch (e) {
    /// setState(() {
    //isFavorite = !isFavorite;
    //});
    //print(e);
    //ScaffoldMessenger.of(context).showSnackBar(
    // SnackBar(content: Text('Failed to update wishlist: $e')),
    //);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.action,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                InkWell(
                  onTap: widget.action,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: CachedNetworkImage(
                      imageUrl: widget.shoes.imageUrl,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.3,
                  child: IconButton(
                    onPressed: toggleLiked,
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFavorite ? Colors.red : null,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Text(
                "${widget.shoes.nameShoes}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                "${widget.shoes.nameShoes} - ${widget.shoes.warna}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Rp.${widget.shoes.hargaSepatu}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.blue.shade700,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.add_shopping_cart_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
