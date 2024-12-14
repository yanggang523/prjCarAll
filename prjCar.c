/*******************************************************
This program was created by the CodeWizardAVR V3.49a 
Automatic Program Generator
© Copyright 1998-2022 Pavel Haiduc, HP InfoTech S.R.L.
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

#define F_CPU 16000000UL  // 클럭 주파수를 16MHz로 설정
#define BAUD 9600
#define U2X_S 2
#define MYUBRR ((F_CPU * U2X_S) / (16L * BAUD) - 1)

#include <mega128.h>
#include <delay.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <pgmspace.h>

// 함수 선언
void timer0_init(void);
void timer2_init(void);
void USART0_Init(unsigned int ubrr);
char USART0_Receive(void);
void USART0_Transmit(char data);
void USART0_ReceiveString(char *buffer, int maxLength);
void USART0_SendFlashString(const flash char *str);
void Go_Straight(void);
void Turn_Left(void);
void Turn_Right(void);
void Back(void);
void Stop(void);

// 전역 변수
volatile uint16_t total_count = 0;
char ch;
char receivedString[20]; 

// 인터럽트 서비스 루틴
interrupt [TIM1_COMPA] void timer1_compa_isr(void) {
    total_count++;
}

// FLASH에 문자열 리터럴 저장
flash char msg_ready[] = "UART Communication Ready\n";
flash char msg_invalid[] = "Invalid Command\n";
flash char msg_prompt[] = "Type a message: ";
flash char msg_hello[] = "Message Received: HELLO\n";
flash char msg_unknown[] = "Unknown Message\n";
flash char msg_hello_flash[] = "HELLO";

// USART0 초기화 함수
void USART0_Init(unsigned int ubrr) {
    UBRR0H = (unsigned char)(ubrr >> 8);
    UBRR0L = (unsigned char)ubrr;
    UCSR0B = (1 << RXEN0) | (1 << TXEN0);
    UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);
}

// 문자 수신 함수
char USART0_Receive(void) {
    while (!(UCSR0A & (1 << RXC0)));
    return UDR0;
}

// 문자 송신 함수
void USART0_Transmit(char data) {
    while (!(UCSR0A & (1 << UDRE0)));
    UDR0 = data;
}

// FLASH에서 문자열을 읽어 전송하는 함수
void USART0_SendFlashString(const flash char *str) {
    char c;
    while ((c = *str++)!= '\0') {
        USART0_Transmit(c);
    }
}

// 문자열 수신 함수
void USART0_ReceiveString(char *buffer, int maxLength) {
    int i = 0;
    char ch;

    while (1) {
        ch = USART0_Receive();

        if (ch == '\r' || ch == '\n') {
            buffer[i] = '\0';
            break;
        }

        if (i < maxLength - 1) {
            buffer[i++] = ch;
        }
    }
}

// 타이머0 초기화 함수
void timer0_init(void) {
    TCCR0 = 0b01101100;  // Fast PWM 모드 설정
}

// 타이머2 초기화 함수
void timer2_init(void) {
    TCCR2 = 0b01101011;  // Fast PWM 모드 설정
}

// 전진 함수
void Go_Straight(void) {
    OCR0 = 90;
    PORTB &= ~(1 << 5);
    PORTB |= (1 << 6);

    OCR2 = 90;
    PORTB &= ~(1 << 2);
    PORTB |= (1 << 3);
}

// 후진 함수
void Back(void) {
    OCR0 = 90;
    PORTB |= (1 << 5);
    PORTB &= ~(1 << 6);

    OCR2 = 90;
    PORTB |= (1 << 2);
    PORTB &= ~(1 << 3);
}

// 우회전 함수
void Turn_Right(void) {
    OCR0 = 90;
    PORTB |= (1 << 5);
    PORTB &= ~(1 << 6);

    OCR2 = 90;
    PORTB &= ~(1 << 2);
    PORTB |= (1 << 3);
}

// 좌회전 함수
void Turn_Left(void) {
    OCR0 = 90;
    PORTB &= ~(1 << 5);
    PORTB |= (1 << 6);

    OCR2 = 90;
    PORTB |= (1 << 2);
    PORTB &= ~(1 << 3);
}

// 정지 함수
void Stop(void) {
    OCR0 = 0;
    PORTB &= ~(1 << 5);
    PORTB &= ~(1 << 6);

    OCR2 = 0;
    PORTB &= ~(1 << 2);
    PORTB &= ~(1 << 3);
}

// 메인 함수
void main(void) {
    DDRB = 0xFF;      // PORTB를 출력으로 설정
    timer0_init();    // 타이머0 초기화
    timer2_init();    // 타이머2 초기화
    USART0_Init(MYUBRR);  // USART0 초기화

    #asm("sei")  // 전역 인터럽트 활성화

    while (1) {
        // 리셋 메시지 출력
        USART0_SendFlashString(msg_ready);

        // 단일 문자 수신 및 처리
        if (UCSR0A & (1 << RXC0)) {
            ch = USART0_Receive();

            switch (ch) {
                case 'W':
                case 'w':
                    Go_Straight();
                    break;
                case 'S':
                case 's':
                    Back();
                    break;
                case 'A':
                case 'a':
                    Turn_Left();
                    break;
                case 'D':
                case 'd':
                    Turn_Right();
                    break;
                case 'R':
                case 'r':
                    Stop();
                    break;
                default:
                    USART0_SendFlashString(msg_invalid);
                    break;
            }
        }

        // 문자열 수신 및 "HELLO" 확인
        USART0_SendFlashString(msg_prompt);
        USART0_ReceiveString(receivedString, sizeof(receivedString));

        if (strcmp_P(receivedString, msg_hello_flash) == 0) {
            USART0_SendFlashString(msg_hello);
        } else {
            USART0_SendFlashString(msg_unknown);
        }
    }
}
