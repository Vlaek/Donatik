# [Donatik](https://github.com/Vlaek/Donatik/archive/refs/heads/master.zip)

**Donatik** - это lua скрипт, функционал которого направлен на попрошайничество денег у игроков, составления топов донатеров, а также сбора статистики. Имеется возможность отправления скриншотов с донатами в телеграм, а также выполнение функций скрипта.

## Зависимости
- [SAMP 0.3.7 R1](http://files.sa-mp.com/sa-mp-0.3.7-install.exe)
- [CLEO 4](https://cleo.li)
- [SAMPFUNCS v5.4.1](https://www.blast.hk/threads/17/)
- [Moonloader v026.5](https://www.blast.hk/threads/13305/)
- [Screenshot.asi](https://www.blast.hk/threads/46045/)
  
## Установка
- Установить зависимости из пункта выше
- Переместить папку ***lib*** в папку ***Moonloader***
- Переместить файл скрипта ***donatik.lua*** в папку ***Moonloader***
- Переместить папку ***rsc*** в папку ***Moonloader*** (опционально, отвечает за звуки при донатах)

## Поддерживаемые проекты
- [X] Samp-Rp
- [X] Evolve Role Play
- [X] Arizona Role Play
___

## Стандартные горячие клавиши
- ***ALT + 1*** - вывести топ донатеров за текущий день
- ***ALT + 2*** - вывести топ донатеров за все время
- ***ALT + 3*** - вывести топ донатеров за все время на текущую цель (стандарт 1кк)
- ***ALT + 4*** - вывести количество заработанных денег за текущий день
- ***ALT + 5*** - вывести количество заработанных денег за все время
- ***ALT + 6*** - вывести количество заработанных денег на текущую цель
- ***ALT + H*** - включить/выключить худ
  
## Команды
- ***/dmenu*** - меню настроек скрипта
- ***/donaters*** - топ донатеров за текущий день
- ***/topdonaters*** - топ донатеров за все время
- ***/topdonatersziel*** - топ донатеров за все время на текущую цель
- ***/todaydonatemoney*** - заработанные деньги за текущий день
- ***/donatemoney*** - заработанные деньги за все время
- ***/donatemoneyziel*** - заработанные деньги на текущую цель
- ***/dhud*** - худ
- ***/donatername*** - вывести статистику донатера по его имени
- ***/donaterid*** - вывести статистику донатера по его иду
- ***/donater [ник игрока]*** - вывести информацию о донатере (для себя)
- ***/donater [ник игрока] [сумма]*** - добавить/убавить деньги игроку
- ***/dziel [название] [сумма]*** - поменять цель сбора
- ***/dtop [количество]*** - вывести топ донатеров до определенного места
- ***/dtopziel [количество]*** - вывести топ донатеров на текущую цель до определенного места

## Скриншоты
### Меню, страница с функциями
![MENU](https://i.imgur.com/GlnaIIo.png)
### Список донатеров
![DONATERS](https://i.imgur.com/Edz9mZO.png)
### История донатов
![HISTORY](https://i.imgur.com/1jUqG10.png)
### Информация
![INFORMATION](https://i.imgur.com/YSt8m55.png)
### Своя тема
![THEMA](https://i.imgur.com/I96z2X8.png)
### HUD (позицию можно поменять)
![HUD](https://i.imgur.com/s5pTSap.png)
### Вывод топа донатеров за все время
![DONATERS](https://i.imgur.com/6qz79KK.png)
### Отображение доната и место в топе сверху игрока (опционально)
![TEXTLABEL](https://i.imgur.com/PrfAUw1.png)
### Сообщение в чат при донате (зависит от суммы)
![DONATE](https://i.imgur.com/br2gJzu.png)
### Телеграм
![TELEGRAM](https://i.imgur.com/e07SbrM.png)
