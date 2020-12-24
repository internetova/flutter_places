import 'package:places/domain/categories.dart';
import 'package:places/ui/screen/res/assets.dart';

import 'domain/sight.dart';

final List mocks = <Sight>[
  Sight(
    name: 'Триумфальная арка',
    lat: 55.737064,
    lon: 37.520018,
    url: 'https://architectureguru.ru/triumfalnaya-arka-v-moskve/',
    type: 'достопримечательность',
    details:
        'Триумфальная арка или Триумфальные ворота в Москве – объект культурного наследия, расположенный на Кутузовском проспекте. Памятник воздвигнут в честь победы русского народа над Наполеоном в 1812 году. Достопримечательность относится к самым известным триумфальным воротам и аркам мира.',
    imgPreview:
        'https://i1.photo.2gis.com/images/geo/32/4503599659565451_527f.jpg',
  ),
  Sight(
    name: 'Бункер-42 на Таганке',
    lat: 55.742583,
    lon: 37.649447,
    url: 'http://bunker42.com',
    type: 'музей',
    details:
        'Военно-исторический музей и развлекательный комплекс в Москве в 5-м Котельническом переулке рядом со станцией метро «Таганская». Основан в 2006 году. Расположен в подземном бункере площадью более 7000 м² на глубине 65 метров на территории бывшего засекреченного военного объекта СССР - Запасного командного пункта дальней авиации.',
    imgPreview:
        'https://rests.afisha.ru/uploads/images/1/22/122eb468a03f4baea1d3b7cf002d9744.jpg',
    favorites: WhereShowCard.visited,
    date: '12 окт. 2020',
  ),
  Sight(
    name: 'Нереальное место',
    lat: 55.762781,
    lon: 37.664158,
    url: 'https://nerealnoemesto.ru',
    type: 'развлечения',
    details:
        'Клуб виртуальной реальности, парк аттракционов. У нас 70 лучших VR-игр, всех жанров и для всех возрастов.',
    imgPreview:
        'https://p0.zoon.ru/preview/55NGyQJjzPSdiR00tr1F6w/2400x1500x75/1/c/7/original_5dd7f5384d21d433b76cde7b_5dd7f577dea48.jpg',
    favorites: WhereShowCard.planned,
    date: '12 янв. 2021',
  ),
  Sight(
    name: 'Московский кремль',
    lat: 55.751549,
    lon: 37.618879,
    url: 'https://www.kreml.ru',
    type: 'достопримечательность',
    details:
        'Московский Кремль — один из крупнейших архитектурно-градостроительных ансамблей мира. Он раскинулся в центре столицы России на высоком холме над Москвой-рекой. Высота стен Кремля, узкие бойницы, площадки боя, мерный шаг башен — все говорит о том, что прежде всего это крепость. Но стоит войти в Кремль — и впечатление меняется.',
    imgPreview: 'https://ptoday.ru/wp-content/uploads/2019/09/rusya.jpg',
  ),
  Sight(
    name: 'Выставка достижений народного хозяйства',
    lat: 55.826690,
    lon: 37.637578,
    url: 'https://vdnh.ru',
    type: 'достопримечательность',
    details:
        'Выставочный комплекс в Останкинском районе Северо-Восточного административного округа города Москвы, второй по величине выставочный комплекс в городе. Входит в 50 крупнейших выставочных центров мира. Ежегодно ВДНХ посещают 30 млн гостей.',
    imgPreview: 'https://turisticum.ru/img/moscow/vdnh/9.jpg',
  ),
  Sight(
    name: 'Государственная Третьяковская галерея',
    lat: 55.742251,
    lon: 37.620522,
    url: 'https://www.tretyakovgallery.ru',
    type: 'музей',
    details:
        'Московский художественный музей, основанный в 1856 году купцом Павлом Третьяковым. В 1867-м галерея была открыта для посещения, а в 1892 году передана в собственность Москве. На момент передачи коллекция музея насчитывала 1276 картин, 471 рисунок, десять скульптур русских художников, а также 84 картины иностранных мастеров.',
    imgPreview:
        'https://www.culture.ru/storage/images/2088745eed4913add79e040040f3484d/6ef8c1a4082924ba7cfe7f065825a278.jpeg',
    favorites: WhereShowCard.planned,
    date: '4 янв. 2021',
  ),
  Sight(
    name: 'Государственный академический Большой театр России',
    lat: 55.760245,
    lon: 37.618832,
    url: 'https://www.bolshoi.ru',
    type: 'театр',
    details:
        'Один из крупнейших в России и один из самых значительных в мире театров оперы и балета. Комплекс зданий театра расположен в центре Москвы, на Театральной площади.',
    imgPreview:
        'https://i1.photo.2gis.com/images/branch/0/30258560047532609_3605.jpg',
  ),
];

/// категории для фильтра поиска
final List<Categories> categories = [
  Categories(id: 1, name: 'Отель', icon: icHotel),
  Categories(id: 2, name: 'Ресторан', icon: icRestaurant),
  Categories(id: 3, name: 'Особое место', icon: icParticular),
  Categories(id: 4, name: 'Парк', icon: icPark),
  Categories(id: 5, name: 'Музей', icon: icMuseum),
  Categories(id: 6, name: 'Кафе', icon: icCafe),
];
