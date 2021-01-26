import 'package:places/domain/sight.dart';

/// сохраненные пользователем данные
/// для раздела Избранное (хочу посетить / посетил)
List<Sight> favoritesSight = [
  Sight(
    id: 2,
    name: 'Бункер-42 на Таганке',
    lat: 55.742583,
    lon: 37.649447,
    url: 'http://bunker42.com',
    type: 'Музей',
    details:
        'Военно-исторический музей и развлекательный комплекс в Москве в 5-м Котельническом переулке рядом со станцией метро «Таганская». Основан в 2006 году. Расположен в подземном бункере площадью более 7000 м² на глубине 65 метров на территории бывшего засекреченного военного объекта СССР - Запасного командного пункта дальней авиации.',
    imgPreview:
        'https://rests.afisha.ru/uploads/images/1/22/122eb468a03f4baea1d3b7cf002d9744.jpg',
    images: [
      'https://rests.afisha.ru/uploads/images/1/22/122eb468a03f4baea1d3b7cf002d9744.jpg',
      'https://picsum.photos/1000/600?random=1',
      'https://picsum.photos/1000/600?random=2',
      'https://picsum.photos/1000/600?random=3',
      'https://picsum.photos/1000/600?random=4',
      'https://picsum.photos/1000/600?random=5',
      'https://picsum.photos/1000/600?random=6',
    ],
    favorites: WhereShowCard.visited,
    date: '12 окт. 2020',
  ),
  Sight(
    id: 3,
    name: 'Нереальное место',
    lat: 55.762781,
    lon: 37.664158,
    url: 'https://nerealnoemesto.ru',
    type: 'Особое место',
    details:
        'Клуб виртуальной реальности, парк аттракционов. У нас 70 лучших VR-игр, всех жанров и для всех возрастов.',
    imgPreview:
        'https://p0.zoon.ru/preview/55NGyQJjzPSdiR00tr1F6w/2400x1500x75/1/c/7/original_5dd7f5384d21d433b76cde7b_5dd7f577dea48.jpg',
    images: [
      'https://p0.zoon.ru/preview/55NGyQJjzPSdiR00tr1F6w/2400x1500x75/1/c/7/original_5dd7f5384d21d433b76cde7b_5dd7f577dea48.jpg',
      'https://picsum.photos/1000/600?random=1',
      'https://picsum.photos/1000/600?random=2',
      'https://picsum.photos/1000/600?random=3',
      'https://picsum.photos/1000/600?random=4',
      'https://picsum.photos/1000/600?random=5',
      'https://picsum.photos/1000/600?random=6',
    ],
    favorites: WhereShowCard.planned,
    date: '12 янв. 2021',
  ),
  Sight(
    id: 4,
    name: 'Московский кремль',
    lat: 55.751549,
    lon: 37.618879,
    url: 'https://www.kreml.ru',
    type: 'Музей',
    details:
        'Московский Кремль — один из крупнейших архитектурно-градостроительных ансамблей мира. Он раскинулся в центре столицы России на высоком холме над Москвой-рекой. Высота стен Кремля, узкие бойницы, площадки боя, мерный шаг башен — все говорит о том, что прежде всего это крепость. Но стоит войти в Кремль — и впечатление меняется.',
    imgPreview: 'https://ptoday.ru/wp-content/uploads/2019/09/rusya.jpg',
    images: [
      'https://ptoday.ru/wp-content/uploads/2019/09/rusya.jpg',
      'https://picsum.photos/1000/600?random=1',
      'https://picsum.photos/1000/600?random=2',
      'https://picsum.photos/1000/600?random=3',
      'https://picsum.photos/1000/600?random=4',
      'https://picsum.photos/1000/600?random=5',
      'https://picsum.photos/1000/600?random=6',
    ],
    favorites: WhereShowCard.planned,
    date: '25 янв. 2021',
  ),
  Sight(
    id: 6,
    name: 'Государственная Третьяковская галерея',
    lat: 55.742251,
    lon: 37.620522,
    url: 'https://www.tretyakovgallery.ru',
    type: 'Музей',
    details:
        'Московский художественный музей, основанный в 1856 году купцом Павлом Третьяковым. В 1867-м галерея была открыта для посещения, а в 1892 году передана в собственность Москве. На момент передачи коллекция музея насчитывала 1276 картин, 471 рисунок, десять скульптур русских художников, а также 84 картины иностранных мастеров.',
    imgPreview:
        'https://www.culture.ru/storage/images/2088745eed4913add79e040040f3484d/6ef8c1a4082924ba7cfe7f065825a278.jpeg',
    images: [
      'https://www.culture.ru/storage/images/2088745eed4913add79e040040f3484d/6ef8c1a4082924ba7cfe7f065825a278.jpeg',
      'https://picsum.photos/1000/600?random=1',
      'https://picsum.photos/1000/600?random=2',
      'https://picsum.photos/1000/600?random=3',
      'https://picsum.photos/1000/600?random=4',
      'https://picsum.photos/1000/600?random=5',
      'https://picsum.photos/1000/600?random=6',
    ],
    favorites: WhereShowCard.planned,
    date: '4 янв. 2021',
  ),
  Sight(
    id: 8,
    name: 'Часовня Смоленской иконы Божией Матери в Чиверево',
    lat: 55.988344,
    lon: 37.608042,
    url: 'https://yandex.ru',
    type: 'Особое место',
    details:
        'Первая деревянная часовня здесь была построена в 1844 году. Впоследствии она сгорела и на ее месте в 1902 году по проекту епархиального архитектора Николая Николаевича Благовещенского была построена кирпичная часовня.',
    imgPreview: 'https://sobory.ru/pic/09160/09168_20081121_230953.jpg',
    images: [
      'https://sobory.ru/pic/09160/09168_20081121_230953.jpg',
      'https://picsum.photos/1000/600?random=1',
      'https://picsum.photos/1000/600?random=2',
      'https://picsum.photos/1000/600?random=3',
      'https://picsum.photos/1000/600?random=4',
      'https://picsum.photos/1000/600?random=5',
      'https://picsum.photos/1000/600?random=6',
    ],
    favorites: WhereShowCard.visited,
    date: '10 окт. 2020',
  ),
];
