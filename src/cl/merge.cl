#ifdef __CLION_IDE__

#include <libgpu/opencl/cl/clion_defines.cl>

#endif

#line 6


__kernel void merge(__global float *as, __global float *buffer, unsigned int size, unsigned int arr_size)
{
    unsigned gid = get_global_id(0);
    if (gid >= size) return;

    unsigned block_id = gid % (2 * arr_size);
    unsigned l_begin = gid - block_id;
    unsigned l_end = l_begin + arr_size;
    unsigned r_begin = l_end;
    unsigned r_end = r_begin + arr_size;
    unsigned l, r;
    unsigned is_left = (gid < r_begin);
    float fixed_element = as[gid];

    if (is_left) {
        l = r_begin, r = r_end;
    } else {
        l = l_begin, r = l_end;
    }

    while (l < r) {
        int m = (l + r) / 2;
        if (is_left) {
            if (as[m] < fixed_element) {
                l = m + 1;
            } else {
                r = m;
            }
        } else {
            if (as[m] <= fixed_element) {
                l = m + 1;
            } else {
                r = m;
            }
        }
    }
    int offset = is_left ? (gid - l_begin) + (l - r_begin) : (gid - r_begin) + (l - l_begin);
    buffer[l_begin + offset] = fixed_element;
}
