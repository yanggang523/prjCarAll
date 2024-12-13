/*******************************************************
This program was created by the CodeWizardAVR V3.49a 
Automatic Program Generator
� Copyright 1998-2022 Pavel Haiduc, HP InfoTech S.R.L.
http://www.hpinfotech.ro

Project : RCCAR
Version : 1.1.0
Date    : 2024-12-12
Author  : 강경아, 성호재
Company : 경상국립대학교 소속 학생
Comments: I want 종강 


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

// 함수 선언
void timer0_init(void);
void timer2_init(void);
void USART0_Init(unsigned int ubrr);
void Go_Straight(void);
void Turn_Left(void);
void Turn_Right(void);
void Back(void);
void Stop(void);

// 전역 변수
volatile uint16_t total_count = 0;
char ch;

interrupt [TIM1_COMPA] void timer1_compa_isr(void) {
    total_count++;
}

// USART0 초기화 함수
void USART0_Init(unsigned int ubrr) {
    UBRR0H = (unsigned char)(ubrr >> 8);
    UBRR0L = (unsigned char)ubrr;
    UCSR0B = (1 << RXEN0) | (1 << TXEN0);
    UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);
}

// 타이머0 초기화 함수
void timer0_init(void) {
    TCCR0 = 0b01101100;  // Fast PWM 모드 설정
}

// 타이머2 초기화 함수
void timer2_init(void) {
    TCCR2 = 0b01101011;  // Fast PWM 모드 설정
}

// 이동 함수들
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
    DDRB = 0xFF;      // PORTB를 출력으로 설정
    timer0_init();    // 타이머0 초기화
    timer2_init();    // 타이머2 초기화
    USART0_Init(MYUBRR);  // USART0 초기화

    #asm("sei")  // 전역 인터럽트 활성화

//main


while (1)
      {    
                     //테스트 목적
          delay_ms(5000);       // 5초 동안 대기   
           Go_Straight();  // 직진
        delay_ms(2000); // 2초 동안 직진
        Stop();
        delay_ms(500);  // 0.5초 동안 정지

        Turn_Right();   // 우회전
        delay_ms(2000); // 2초 동안 우회전
        Stop();
        delay_ms(500);

        Turn_Left();    // 좌회전
        delay_ms(2000); // 2초 동안 좌회전
        Stop();
        delay_ms(500);

        Back();         // 후진
        delay_ms(2000); // 2초 동안 후진
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