READ ME: Reduce temperature Program
Author: Dayde-Thomas Vincent
        Apprentice Engineer (1)(2)
Organization: (1)Conseil departemental de la Haute Garonne (Cd31) 
                Patrimonial Direction - Energy department 
              (2)INP Toulouse - ENSEEIHT (N7)
                Fluids dynamics, energy and environment department
Date of creation: 19/02/2021
Last update : 14/06/2021

%%%%
DISCLAIMER: the author bears no responsibility for any possible error,
possible malfunction or data loss using this program, and in case of
an operational use, to the users is the only responsible for his equipment
use and settings
%%%%

This program calculate the thermal parameters of a building, using the 
admittance method (Iso13786-13790)
It should be used with the free software licensed OCTAVE 
(Latest version tested for this program: Octave-6.1.0)

There is an input file name : input.txt
This file contain the datas from the building indicate below :
-Density "rho"(kg/m3)
-thickness "e"(m)
-Thermal Conductivity "Lambda" (W/(m.K))
-Calorific capacity "c" (J/(kg.K))
Those informations are in column, with the external layer on the first line and the internal layer on the last line. Each line should be enter by this order 
You can put as many layer as needed
If the value is on the formulation : x.10^Y, write it as indicates on the example below:
3.0E-7

The file call "air_properties.txt" contains :
-Density "rho"(kg/m3)
-Calorific capacity "c" (J/(kg.K))
-Ventilation value "q_a" (vol/h)
Those values are needed for the time constant calculation

The file call "general_informations.txt" contains :
-Ground surface S (m^2)
-Floor Height H (m)
-Number of Floor NF (No unit)
-The wall perimeter P(m)
-The windows rate rate_g(%)
-Power of the heating system (Boiler) Q(W)
-Confort temperature (°C)
-Reduced, temperature (°C)
-Average External temperature (°C)
Those values are needed for the time constant calculation and transmittance method
%Warning 
Be careful, the floor should be counted from 1 to NF (In french counting, the ground floor become 1, the 1st floor become 2, etc... ; In american counting, nothing to change)

There is an input file name : windows_input.txt
This file contain the datas from the windows indicate below :
-Density "rho"(kg/m3)
-thickness "e"(m)
-Thermal Conductivity "Lambda" (W/(m.K))
-Calorific capacity "c" (J/(kg.K))
Those informations are in column, with the external layer on the first line and the internal layer on the last line. Each line should be enter by this order 
Actually, the input fil is made for a two layer window, but you can put as many layer as needed
If the value is on the formulation : x.10^Y, write it as indicates on the example below:
3.0E-7

There is an input file name : input_roof.txt
This file contain the datas from the roof indicate below :
-Density "rho"(kg/m3)
-thickness "e"(m)
-Thermal Conductivity "Lambda" (W/(m.K))
-Calorific capacity "c" (J/(kg.K))
Those informations are in column, with the external layer on the first line and the internal layer on the last line. Each line should be enter by this order 
Actually, the input fil is made for a two layer window, but you can put as many layer as needed
If the value is on the formulation : x.10^Y, write it as indicates on the example below:
3.0E-7

There is an input file name : input_ground.txt
This file contain the datas from the ground indicate below :
-Density "rho"(kg/m3)
-thickness "e"(m)
-Thermal Conductivity "Lambda" (W/(m.K))
-Calorific capacity "c" (J/(kg.K))
Those informations are in column, with the external layer on the first line and the internal layer on the last line. Each line should be enter by this order 
Actually, the input fil is made for a two layer window, but you can put as many layer as needed
If the value is on the formulation : x.10^Y, write it as indicates on the example below:
3.0E-7

%%%%
USAGE TIPS 
%%%%
If you want to change the data because of the change of building, please do it on the input.txt file
If you want to change air properties, please do it on the air_properties.txt file
If you want to change general information of the building, please do it on general_informations.txt file
If you want to study harmonical response, please change the value of m directly in the code (At the time of the redaction of the program : line 33)
If the file is corrupted by non possible datas or for other reason, please create a new file input.txt, air_properties.txt or general_informations.txt by using the input_save.txt, air_porperties_save.txt, windows_input_save.txt and general_informations_save.txt in the save folder. 
DO NOT REMPLACE or change anything on the save folder, just copy/paste.



