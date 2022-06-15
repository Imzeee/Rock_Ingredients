% Mam za zadanie przeprowadzić analizę obrazu wykorzystując narzędzia MATLAB
% Celem jest znalezenie w analizowanym obrazie składników skalnych:
% kwarc,węglany,glaukonit. Zdjęcia zostały wykonane w ramach zajęć
% mikroskopowych na wydziale WGGIOS. W mojej pracy skupiam się na analizie
% przestrzeni barw minerałów pomijając kwestie geologiczne

% zaczynam od akwizycji czyli wczytania i wstępnego przeglądu dostępnych
% danych w postaci zdjęć wykonanych przy pojedynczym polaryzatorzez oraz
% przy skrzyżowanych dla rotacji wykonanych co 30 stopni
close all;clear;clc;
first_image=imread('1N_00.jpg');
second_image=imread('XN_00.jpg');
subplot(121),imshow(first_image);
subplot(122),imshow(second_image);

% kontynuuje analize od próby znalezienia kwarcu, który na zdjęciu 1N jest
% przeźroczysty a przy XN zmienia kolor od białego poprzez szary aż do
% czarnego.

% Wyznaczam wartości kanałów graniczne kanałów RGB które posłużą w celu
% wykonania binaryzacj obrazu

red_kwarc_lower_boarder = 165.000;
red_kwarc_upper_boarder = 196.000;

green_kwarc_lower_boarder = 169.000;
green_kwarc_upper_boarder = 197.000;

blue_kwarc_lower_boarder = 132.000;
blue_kwarc_upper_boarder = 156.000;


% dokonuję binaryzacji
kwarc_bin = (first_image(:,:,1) >= red_kwarc_lower_boarder ) & (first_image(:,:,1) <= red_kwarc_upper_boarder) & ...
    (first_image(:,:,2) >= green_kwarc_lower_boarder ) & (first_image(:,:,2) <= green_kwarc_upper_boarder) & ...
    (first_image(:,:,3) >= blue_kwarc_lower_boarder ) & (first_image(:,:,3) <= blue_kwarc_upper_boarder);


% pozbywam się najdrobniejszych fragmentów
kwarc_bin = bwareaopen(kwarc_bin,100);

imshow(kwarc_bin)

% przechodzę do poszukiwań glaukonitu, który wyróżnia się zielonymi
% odcieniami barw na obu obrazach

red_glaukonit_lower_boarder = 86.000;
red_glaukonit_upper_boarder = 137.000;

green_glaukonit_lower_boarder = 120.000;
green_glaukonit_upper_boarder = 168.000;

blue_glaukonit_lower_boarder = 23.000;
blue_glaukonit_upper_boarder = 76.000;


glaukonit_bin = (first_image(:,:,1) >= red_glaukonit_lower_boarder ) & (first_image(:,:,1) <= red_glaukonit_upper_boarder) & ...
    (first_image(:,:,2) >= green_glaukonit_lower_boarder ) & (first_image(:,:,2) <= green_glaukonit_upper_boarder) & ...
    (first_image(:,:,3) >= blue_glaukonit_lower_boarder ) & (first_image(:,:,3) <= blue_glaukonit_upper_boarder);


% pozbywam się najdrobniejszych fragmentów
glaukonit_bin = bwareaopen(glaukonit_bin,100);


% aby zwiekszyc dokladnosc algorytmu posluze sie takze obrazem drugim i
% polacze calosc logicznym OR


red_glaukonit_lower_boarder_XN = 22.000;
red_glaukonit_upper_boarder_XN = 106.000;

green_glaukonit_lower_boarder_XN = 75.000;
green_glaukonit_upper_boarder_XN = 142.000;

blue_glaukonit_lower_boarder_XN = 33.000;
blue_glaukonit_upper_boarder_XN = 76.000;


glaukonit_bin_XN = (second_image(:,:,1) >= red_glaukonit_lower_boarder_XN ) & (second_image(:,:,1) <= red_glaukonit_upper_boarder_XN) & ...
    (second_image(:,:,2) >= green_glaukonit_lower_boarder_XN ) & (second_image(:,:,2) <= green_glaukonit_upper_boarder_XN) & ...
    (second_image(:,:,3) >= blue_glaukonit_lower_boarder_XN ) & (second_image(:,:,3) <= blue_glaukonit_upper_boarder_XN);


glaukonit_bin = glaukonit_bin | glaukonit_bin_XN;

% usuwam drobne elementy
glaukonit_bin = bwareaopen(glaukonit_bin,100);
imshow(glaukonit_bin)


% ostatnim minerałem do znalezienia są węglany które wyróżniają się tym że
% przy zdjęciu XN mają kolor od pastelowego pomarańczowo-różowego po czarny


red_weglan_lower_boarder = 206.000;
red_weglan_upper_boarder = 250.000;

green_weglan_lower_boarder = 117.000;
green_weglan_upper_boarder = 153.000;

blue_weglan_lower_boarder = 104.000;
blue_weglan_upper_boarder = 149.000;


weglan_bin = (second_image(:,:,1) >= red_weglan_lower_boarder ) & (second_image(:,:,1) <= red_weglan_upper_boarder) & ...
    (second_image(:,:,2) >= green_weglan_lower_boarder ) & (second_image(:,:,2) <= green_weglan_upper_boarder) & ...
    (second_image(:,:,3) >= blue_weglan_lower_boarder ) & (second_image(:,:,3) <= blue_weglan_upper_boarder);


weglan_bin = bwareaopen(weglan_bin,10);
imshow(weglan_bin)


% po znalezieniu wszytkich minerałów, przechodzę do zebrania wyników i
% przedstawienia ich nałożonych na obraz wejściowy

binary_mask1 = kwarc_bin;
binary_mask2 = glaukonit_bin;
binary_mask3 = weglan_bin;

binary_mask_result = binary_mask1 | binary_mask2 | binary_mask3;

result_image = imoverlay(binary_mask_result,binary_mask1,[1 1 0]);
result_image = imoverlay(result_image,binary_mask2,[0 1 0]);
result_image = imoverlay(result_image,binary_mask3,[1 0 1]);

% za pomoca narzedzia imtool() zmierzylem ze około 178 pixeli na obrazi
% jest rowne 0.05mm w rzeczywistosci, mnozac razy 20 mamy ilosc pixeli
% odpowiadajacej 1mm w rzeczywistosci. Do liczenia powierzchni potrzebne
% beda milimetry kwadratowe dlatego tez wynik nalezy podniesc do kwadratu

scale_milimeters = 178*20;
scale_milimeters_squared = scale_milimeters^2;


%liczenie pol
kwarc_area=bwarea(kwarc_bin)/scale_milimeters_squared;
glaukonit_area=bwarea(glaukonit_bin)/scale_milimeters_squared;
weglan_area=bwarea(weglan_bin)/scale_milimeters_squared;


%prezentacja wynikow
subplot(121),imshow(first_image);
title('FirstImage'); 
subplot(122),imshow(second_image);
title('SecondImage');

figure;
subplot(221),imshow(binary_mask1)
title('Kwarc'); 
subplot(222),imshow(binary_mask2)
title('Glaukonit'); 
subplot(223),imshow(binary_mask3)
title('Weglan'); 
subplot(224),imshow(result_image)
title('Merged'); 

% pola w mm2:
KWARC = ['Pole kwarcu w badanej próbce: ',num2str(kwarc_area),'mm^2'];
GLAUKONIT = ['Pole glaukonitu w badanej próbce: ',num2str(glaukonit_area),'mm^2'];
WEGLAN = ['Pole kwarcu w badanej próbce: ',num2str(weglan_area),'mm^2'];

disp(KWARC)
disp(GLAUKONIT)
disp(WEGLAN)