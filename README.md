В этом репозитории предложены задания для [курса по вычислениям на видеокартах в CSC](https://compscicenter.ru/courses/video_cards_computation/2021-autumn/).

[Остальные задания](https://github.com/GPGPUCourse/GPGPUTasks2021/).

# Пример OpenCL <-> CUDA

[![Build Status](https://app.travis-ci.com/GPGPUCourse/GPGPUTasks2021.svg?branch=cuda)](https://app.travis-ci.com/GPGPUCourse/GPGPUTasks2021)

Этот проект иллюстрирует как написать код для видеокарты посредством OpenCL и затем скомпилировать его в т.ч. для исполнения через CUDA. Это дает замечательную возможность использовать тулинг CUDA:

 - профилировщик (**computeprof** - он же **nvvp**, или более новый - **NsightCompute**): позволяет посмотреть timeline выполнения кернелов, операций по копированию видеопамяти, насколько какой кернел насытил пропускную способность видеопамяти/локальной памяти или ALU, число используемых регистров и локальной памяти (и соответственно насколько высока occupancy)

 - **cuda-memcheck** позволяет проверить что нет out-of-bounds обращений к памяти (если есть - укажет проблемную строку в кернеле)
 
 - **cuda-memcheck --tool racecheck** позволяет проверить что нет гонок между потоками рабочей группы при обращении к локальной памяти (т.е. что нигде не забыты барьеры). Если гонка есть - укажет на ее характер (RAW/WAR/WAW) и на строки в кернеле (обеих операций участвующих в гонке)

# Ориентиры

Здесь предложена трансляция в CUDA на примере задачи C=A+B, в целом достаточно посмотреть на последние коммиты в этой ветке - особенно на коммит **Translated to CUDA**.

Но вот дополнительные ориентиры:

 - [CMakeLists.txt](https://github.com/GPGPUCourse/GPGPUTasks2021/blob/cuda/CMakeLists.txt#L28-L32): Поиск CUDA-компилятора, добавление для NVCC компилятора флажка 'сохранять номера строк' (нужно чтобы cuda-memcheck мог указывать номера строк с ошибками), добавление ```src/cu/aplusb.cu``` в список исходников, компиляция через ```cuda_add_executable```.
 - [aplusb.cu](https://github.com/GPGPUCourse/GPGPUTasks2021/blob/cuda/src/cu/aplusb.cu): CUDA-кернел транслируется из OpenCL-кернела посредством [макросов](https://github.com/GPGPUCourse/GPGPUTasks2021/blob/cuda/libs/gpu/libgpu/cuda/cu/opencl_translator.cu), вызов кернела через функцию ```cuda_aplusb```
 - **main_aplusb.cpp**: [декларация](https://github.com/GPGPUCourse/GPGPUTasks2021/blob/cuda/src/main_aplusb.cpp#L28-L30) функции ```cuda_aplusb```, [инициализация](https://github.com/GPGPUCourse/GPGPUTasks2021/blob/cuda/src/main_aplusb.cpp#L59) CUDA-контекста, [вызов](https://github.com/GPGPUCourse/GPGPUTasks2021/blob/cuda/src/main_aplusb.cpp#L111) функции вызывающий кернел
