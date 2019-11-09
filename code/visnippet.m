% For each pixel
for u = 1: width-r-1
    for v = 1:height-r-1
        % Computer Ixx, Ixy and Iyy for the given neighbors in the window
        Ixx = 0; Ixy = 0; Iyy = 0;
        for i = 1:r
            for j = 1:r
               Ix = im(u + i + 1, v) - im(u + i, v);
               Iy = im(u, v + i + 1) - im(u, v + i);
               Ixx = Ixx + Ix*Ix;
               Ixy = Ixy + Ix*Iy;
               Iyy = Iyy + Iy*Iy;                   
            end
        end
        % Computer R
        R(u, v) = Ixx*Iyy - 0.03*(Ixx + Iyy)*(Ixx + Iyy);
    end
end