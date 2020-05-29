function assign9 = assign9()
    load PZoutput;
    [audio,FS] = audioread('black.wav');
    result = filter(real(pz_poles),real(pz_zeros),audio);
    sound(result,FS);