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
    register unsigned int mask, answer, temp, input;
    input = number;
    mask = 1 << 30;
    answer = 0;
    
    while (mask > input)
        mask >>= 2;
    
    while (mask != 0)
    {
        temp = answer | mask;
        answer >>= 1;
        if (input >= temp) 
        {
            input -= temp;
            answer |= mask;
        }
        mask >>= 2;
    }

    return answer;
}
