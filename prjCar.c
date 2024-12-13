/*******************************************************
This program was created by the CodeWizardAVR V3.49a 
Automatic Program Generator
© Copyright 1998-2022 Pavel Haiduc, HP InfoTech S.R.L.
http://www.hpinfotech.ro

Project : RCCAR
Version : 1.1.0
Date    : 2024-12-12
Author  : κ°κ²½μ, μ±νΈμ¬
Company : κ²½μκ΅­λ¦½λνκ΅ μμ νμ
Comments: I want μ’κ° 


Chip type               : ATmega128
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*******************************************************/

// I/O Registers definitions
#define F_CPU 8000000UL
#define BAUD 9600
#define U2X_S 2
#define MYUBRR ((F_CPU * U2X_S) / (16L * BAUD) - 1)

#include <mega128.h>
#include <delay.h>
#include <stdio.h>
#include <stdint.h>

// ν¨μ μ μΈ
void timer0_init(void);
void timer2_init(void);
void USART0_Init(unsigned int ubrr);
void Go_Straight(void);
void Turn_Left(void);
void Turn_Right(void);
void Back(void);
void Stop(void);

// μ μ­ λ³μ
volatile uint16_t total_count = 0;
char ch;

interrupt [TIM1_COMPA] void timer1_compa_isr(void) {
    total_count++;
}

// USART0 μ΄κΈ°ν ν¨μ
void USART0_Init(unsigned int ubrr) {
    UBRR0H = (unsigned char)(ubrr >> 8);
    UBRR0L = (unsigned char)ubrr;
    UCSR0B = (1 << RXEN0) | (1 << TXEN0);
    UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);
}

// νμ΄λ¨Έ0 μ΄κΈ°ν ν¨μ
void timer0_init(void) {
    TCCR0 = 0b01101100;  // Fast PWM λͺ¨λ μ€μ 
}

// νμ΄λ¨Έ2 μ΄κΈ°ν ν¨μ
void timer2_init(void) {
    TCCR2 = 0b01101011;  // Fast PWM λͺ¨λ μ€μ 
}

// μ΄λ ν¨μλ€
void Go_Straight(void) {
    OCR0 = 90;
    PORTB.2 = 0;
    PORTB.3 = 1;

    OCR2 = 90;
    PORTB.0 = 0;
    PORTB.1 = 1;
}

void Back(void) {
    OCR0 = 90;
    PORTB.2 = 1;
    PORTB.3 = 0;

    OCR2 = 90;
    PORTB.0 = 1;
    PORTB.1 = 0;
}

void Turn_Right(void) {
    OCR0 = 90;
    PORTB.2 = 1;
    PORTB.3 = 0;

    OCR2 = 90;
    PORTB.0 = 0;
    PORTB.1 = 1;
}

void Turn_Left(void) {
    OCR0 = 90;
    PORTB.2 = 0;
    PORTB.3 = 1;

    OCR2 = 90;
    PORTB.0 = 1;
    PORTB.1 = 0;
}

void Stop(void) {
    OCR0 = 0;
    PORTB.2 = 0;
    PORTB.3 = 0;

    OCR2 = 0;
    PORTB.0 = 0;
    PORTB.1 = 0;
}

void main(void) {
    DDRB = 0xFF;      // PORTBλ₯Ό μΆλ ₯μΌλ‘ μ€μ 
    timer0_init();    // νμ΄λ¨Έ0 μ΄κΈ°ν
    timer2_init();    // νμ΄λ¨Έ2 μ΄κΈ°ν
    USART0_Init(MYUBRR);  // USART0 μ΄κΈ°ν

    #asm("sei")  // μ μ­ μΈν°λ½νΈ νμ±ν

//main


while (1)
      {    
                     //νμ€νΈ λͺ©μ 
          delay_ms(5000);       // 5μ΄ λμ λκΈ°   
           Go_Straight();  // μ§μ§
        delay_ms(2000); // 2μ΄ λμ μ§μ§
        Stop();
        delay_ms(500);  // 0.5μ΄ λμ μ μ§

        Turn_Right();   // μ°νμ 
        delay_ms(2000); // 2μ΄ λμ μ°νμ 
        Stop();
        delay_ms(500);

        Turn_Left();    // μ’νμ 
        delay_ms(2000); // 2μ΄ λμ μ’νμ 
        Stop();
        delay_ms(500);

        Back();         // νμ§
        delay_ms(2000); // 2μ΄ λμ νμ§
        Stop();
        delay_ms(500);

      
           if (UCSR0A & (1 << RXC0)) {
                ch = UDR0;

                if (ch == '8') {
                    Go_Straight(); 
                } else if (ch == '2') {
                    Back();
                } else if (ch == '4') {
                    Turn_Left();
                } else if (ch == '6') {
                    Turn_Right();
                } else if (ch == '5') {
                    Stop();
                }
            }       
        }
        
      // Place your code here

      
}
