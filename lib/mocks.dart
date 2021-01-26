import 'package:flutter/material.dart';
import 'package:places/domain/categories.dart';
import 'package:places/ui/screen/res/assets.dart';

import 'domain/sight.dart';

final List<Sight> mocks = [
  Sight(
    id: 1,
    name: 'Триумфальная арка',
    lat: 55.737064,
    lon: 37.520018,
    url: 'https://architectureguru.ru/triumfalnaya-arka-v-moskve/',
    type: 'Особое место',
    details:
        'Триумфальная арка или Триумфальные ворота в Москве – объект культурного наследия, расположенный на Кутузовском проспекте. Памятник воздвигнут в честь победы русского народа над Наполеоном в 1812 году. Достопримечательность относится к самым известным триумфальным воротам и аркам мира.',
    imgPreview:
        'https://i1.photo.2gis.com/images/geo/32/4503599659565451_527f.jpg',
    images: [
      'https://i1.photo.2gis.com/images/geo/32/4503599659565451_527f.jpg',
      'https://picsum.photos/1000/600?random=1',
      'https://picsum.photos/1000/600?random=2',
      'https://picsum.photos/1000/600?random=3',
      'https://picsum.photos/1000/600?random=4',
      'https://picsum.photos/1000/600?random=5',
      'https://picsum.photos/1000/600?random=6',
    ],
  ),
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
  ),
  Sight(
    id: 5,
    name: 'Выставка достижений народного хозяйства',
    lat: 55.826690,
    lon: 37.637578,
    url: 'https://vdnh.ru',
    type: 'Парк',
    details:
        'Выставочный комплекс в Останкинском районе Северо-Восточного административного округа города Москвы, второй по величине выставочный комплекс в городе. Входит в 50 крупнейших выставочных центров мира. Ежегодно ВДНХ посещают 30 млн гостей.',
    imgPreview: 'https://turisticum.ru/img/moscow/vdnh/9.jpg',
    images: [
      'https://turisticum.ru/img/moscow/vdnh/9.jpg',
      'https://picsum.photos/1000/600?random=1',
      'https://picsum.photos/1000/600?random=2',
      'https://picsum.photos/1000/600?random=3',
      'https://picsum.photos/1000/600?random=4',
      'https://picsum.photos/1000/600?random=5',
      'https://picsum.photos/1000/600?random=6',
    ],
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
  ),
  Sight(
    id: 7,
    name: 'Государственный академический Большой театр России',
    lat: 55.760245,
    lon: 37.618832,
    url: 'https://www.bolshoi.ru',
    type: 'Особое место',
    details:
        'Один из крупнейших в России и один из самых значительных в мире театров оперы и балета. Комплекс зданий театра расположен в центре Москвы, на Театральной площади.',
    imgPreview:
        'https://i1.photo.2gis.com/images/branch/0/30258560047532609_3605.jpg',
    images: [
      'https://i1.photo.2gis.com/images/branch/0/30258560047532609_3605.jpg',
      'https://picsum.photos/1000/600?random=1',
      'https://picsum.photos/1000/600?random=2',
      'https://picsum.photos/1000/600?random=3',
      'https://picsum.photos/1000/600?random=4',
      'https://picsum.photos/1000/600?random=5',
      'https://picsum.photos/1000/600?random=6',
    ],
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
  ),
  Sight(
    id: 9,
    name: 'Ресторан Дружба',
    lat: 55.760245,
    lon: 37.618832,
    url: 'https://www.bolshoi.ru',
    type: 'Ресторан',
    details:
        'Генерация рыбатекста происходит довольно просто: есть несколько фиксированных наборов фраз и словочетаний, из которых в опредёленном порядке формируются предложения. Предложения складываются в абзацы – и вы наслаждетесь очередным бредошедевром.',
    imgPreview: 'https://img2.fonwall.ru/o/vs/blyudo-eda-pishcha-chwf.jpg',
    images: [
      'https://img2.fonwall.ru/o/vs/blyudo-eda-pishcha-chwf.jpg',
      'https://picsum.photos/1000/600?random=1',
      'https://picsum.photos/1000/600?random=2',
      'https://picsum.photos/1000/600?random=3',
      'https://picsum.photos/1000/600?random=4',
      'https://picsum.photos/1000/600?random=5',
      'https://picsum.photos/1000/600?random=6',
    ],
  ),
  Sight(
    id: 10,
    name: 'Кафе Привет',
    lat: 55.760245,
    lon: 37.618832,
    url: 'https://www.bolshoi.ru',
    type: 'Кафе',
    details:
        'Идейные соображения высшего порядка, а также перспективное планирование прекрасно подходит для реализации прогресса профессионального сообщества. Кстати, представители современных социальных резервов будут функционально разнесены на независимые элементы.',
    imgPreview:
        'https://img.fonwall.ru/o/25/shashlyik_myaso_shpajka_sosiski_kolbaski_91.jpg',
    images: [
      'https://img.fonwall.ru/o/25/shashlyik_myaso_shpajka_sosiski_kolbaski_91.jpg',
      'https://picsum.photos/1000/600?random=1',
      'https://picsum.photos/1000/600?random=2',
      'https://picsum.photos/1000/600?random=3',
      'https://picsum.photos/1000/600?random=4',
      'https://picsum.photos/1000/600?random=5',
      'https://picsum.photos/1000/600?random=6',
    ],
  ),
  Sight(
    id: 11,
    name: 'Кафе Натюрморт',
    lat: 55.760245,
    lon: 37.618832,
    url: 'https://www.bolshoi.ru',
    type: 'Кафе',
    details:
        'Банальные, но неопровержимые выводы, а также предприниматели в сети интернет являются только методом политического участия и смешаны с не уникальными данными до степени совершенной неузнаваемости, из-за чего возрастает их статус бесполезности. Интерактивные прототипы призваны к ответу.',
    imgPreview: 'https://img2.fonwall.ru/o/ht/cake-dessert-food-sweet.jpeg',
    images: [
      'https://img2.fonwall.ru/o/ht/cake-dessert-food-sweet.jpeg',
      'https://picsum.photos/1000/600?random=1',
      'https://picsum.photos/1000/600?random=2',
      'https://picsum.photos/1000/600?random=3',
      'https://picsum.photos/1000/600?random=4',
      'https://picsum.photos/1000/600?random=5',
      'https://picsum.photos/1000/600?random=6',
    ],
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
