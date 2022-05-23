unsigned int isqrt(unsigned int number);

void _start(void)
{
    unsigned int answer;
    answer = isqrt(82);
    answer = isqrt(100);
    answer = isqrt(64);
    while(1);
}

unsigned int isqrt(unsigned int number)
{
    unsigned int mask, answer, temp;
    mask = 0x40000000;
    answer = 0;
    while (mask != 0)
    {
        temp = answer | mask;
        answer >>= 1;
        if (number >= temp) 
        {
            number -= temp;
            answer |= mask;
        }
        mask >>= 2;
    }

    return answer;
}
