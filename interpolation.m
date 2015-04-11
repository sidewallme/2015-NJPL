function [z1, z2, z3, z4] = interpolation(z, g1, g2, g3, g4, dx , dy)
    z1 = z + g1 * [-0.5 * dx; -0.5 * dy];
    z2 = z + g2 * [0.5 * dx; -0.5 * dy];
    z3 = z + g3 * [-0.5 * dx; 0.5 * dy];
    z4 = z + g4 * [0.5 * dx; 0.5 * dy];
end