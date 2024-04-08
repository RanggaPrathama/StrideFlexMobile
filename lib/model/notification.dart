class NotificationModel {
  late int idnotif;
  late String judul;
  late String deskripsi;
  late String tanggal;

  NotificationModel({
    required this.idnotif,
    required this.judul,
    required this.deskripsi,
    required this.tanggal,
  });
}

List<NotificationModel> notif = [
  NotificationModel(
    idnotif: 1,
    judul: 'The Nike Pegasus 40 👟',
    deskripsi: 'Check Out and Upgrade your style 😍',
    tanggal: '4 days ago',
  ),
  NotificationModel(
    idnotif: 2,
    judul: 'Promo Nike Air White',
    deskripsi: 'Check out now !!! 😊',
    tanggal: '4 days ago',
  ),
  NotificationModel(
    idnotif: 3,
    judul: 'THE NEW ADIDAS FLOW WHITE',
    deskripsi: 'WAW NEW SHOES ADIDAS 👟',
    tanggal: '4 days ago',
  ),
  NotificationModel(
    idnotif: 4,
    judul: 'PROMO 50 % All Converse Shoes',
    deskripsi: 'Check out Now !! 😍',
    tanggal: '4 days ago',
  ),
];
