unsigned int isqrt(unsigned int number);

void main(void)
{
    unsigned int answer;
    answer = isqrt(82);
    answer = isqrt(100);
    answer = isqrt(64);
    while(1);
}

unsigned int isqrt(unsigned int number)
{
    register unsigned int regNumber, mask, answer, temp;
    regNumber = number;
    mask = 1 << 30;
    answer = 0;
    
    while (mask > regNumber)
        mask >>= 2;
    
    while (mask != 0)
    {
        temp = answer | mask;
        answer >>= 1;
        if (regNumber >= temp) 
        {
            regNumber -= temp;
            answer |= mask;
        }
        mask >>= 2;
    }

    return answer;
}
