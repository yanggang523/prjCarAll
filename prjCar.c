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
  /*
// I/O Registers definitions
#include <mega128.h>
#include <delay.h>
// Declare your global variables here

void main(void)
{
    unsigned char buff; // LED ���� �����Ͱ� ����� 8BIT ���� ����
    PORTA=0xff; // Port A �ʱⰪ
    DDRA=0xff; // Port A �������.
    PORTC = 0xff; // Port C �ʱⰪ
    DDRC = 0x00; // Port C �Է�����.

    PORTB = 0xFF; // Port B ����, supply �뵵 5V 
while (1)
      {
    buff = PINC; // Port C�� ���� �Է� ��� ����
    PORTA = buff; // LED ���

      }
}






*/
#define F_CPU 16000000UL  // 클럭 주파수를 16MHz로 설정
#define BAUD 9600         // 원하는 보드레이트를 9600으로 설정
#define MYUBRR ((F_CPU / (8UL * BAUD)) - 1)  // 더블 속도 모드 활성화 시 UBRR 값 계산

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
void removeNewline(char *str);
void USART0_SendFlashString(const flash char *str);
void Go_Straight(void);
void Turn_Left(void);
void Turn_Right(void);
void Back(void);
void Stop(void);
uint16_t measureDistance(void);

// 전역 변수
volatile uint16_t total_count = 0;
char ch;
char receivedString[20];  //문자열 담는 변수
uint8_t obstacleDetected = 0;  // 장애물 감지 상태 (0: 없음, 1: 있음)


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
flash char msg_go_straight[] = "go_straight";

flash char msg_go_straight_func[] = "go_straight_func";
flash char msg_back[] = "back";
flash char msg_back_func[] = "back_func";
flash char msg_turn_right[] = "turn_right";
flash char msg_turn_right_func[] = "turn_right_func";
flash char msg_turn_left[] = "turn_left";
flash char msg_turn_left_func[] = "turn_left_func";
flash char msg_stop[] = "stop";
flash char msg_stop_func[] = "stop_func";

flash char msg_inIf[] = "inIf";
flash char msg_obstacle_detected[] = "Obstacle Detected: Within 15cm\n";
flash char msg_obstacle_cleared[] = "Obstacle Cleared: Beyond 15cm\n";



// USART0 초기화 함수
void USART0_Init(unsigned int ubrr) {
    UBRR0H = (unsigned char)(ubrr >> 8);   // 상위 8비트 설정
    UBRR0L = (unsigned char)ubrr;          // 하위 8비트 설정
    UCSR0A = (1 << U2X0);                  // 더블 속도 모드 활성화
    UCSR0B = (1 << RXEN0) | (1 << TXEN0);  // 송신 및 수신 활성화
    UCSR0C = (1 << UCSZ01) | (1 << UCSZ00); // 8비트 데이터 설정
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


// 문자열 송신 함수
void USART0_SendString(const char *str) {
    while (*str) {
        USART0_Transmit(*str++);
    }
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

void removeNewline(char *str) {
    char *pos;
    if ((pos = strchr(str, '\r')) != NULL) *pos = '\0';
    if ((pos = strchr(str, '\n')) != NULL) *pos = '\0';
}

// 타이머0 초기화 함수
void timer0_init(void) {
    TCCR0 = 0b01101100;  // Fast PWM 모드 설정
}

// 타이머2 초기화 함수
void timer2_init(void) {
    TCCR2 = 0b01101100;  // Fast PWM 모드 설정
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


// measureDistance 함수 선언 및 정의 추가
uint16_t measureDistance(void) {
    uint16_t count = 0;
    uint16_t distance = 0;

    // 트리거 핀으로 펄스 발생 (10us)
    PORTB |= (1 << 0); // 트리거 핀 HIGH (예: PB0)
    delay_us(10);
    PORTB &= ~(1 << 0); // 트리거 핀 LOW

    // 에코 핀의 상승 에지 대기
    while (!(PINB & (1 << 1))); // 에코 핀 HIGH 대기 (예: PB1)

    // 에코 핀의 펄스 폭 측정
    while (PINB & (1 << 1)) {
        count++;
        delay_us(1);
    }

    // 거리 계산: (음속 * 시간) / 2
    distance = count * 0.0343 / 2;

    return distance;
}



// 메인 함수
void main(void) {
    DDRB = 0xFF;      // PORTB를 출력으로 설정
    timer0_init();    // 타이머0 초기화
    timer2_init();    // 타이머2 초기화
    USART0_Init(MYUBRR);  // USART0 초기화 

    
    
    // 타이머1 초기화 (60ms마다 인터럽트 발생)
    TCCR1B = (1 << WGM12) | (1 << CS12); // CTC 모드, 256 분주
    OCR1A = 3749;  // 60ms 주기 (16MHz / 256 / (3749 + 1) = 60ms)
    TIMSK = (1 << OCIE1A);  // 타이머1 컴페어 매치 인터럽트 활성화
    #asm("sei")  // 전역 인터럽트 활성화  
    
    Go_Straight();  // 모터 직진 테스트
    delay_ms(2000); // 2초 동안 직진
    Stop();         // 모터 정지
    delay_ms(1000); // 1초 동안 정지

    Back();         // 모터 후진 테스트
    delay_ms(2000); // 2초 동안 후진
    Stop();
    delay_ms(1000);
                          
        
    while (1) {          
        uint16_t distance = measureDistance(); 
        memset(receivedString, 0, sizeof(receivedString));

        // 문자열 수신 및 처리 반복
        USART0_SendFlashString(msg_prompt);
        USART0_ReceiveString(receivedString, sizeof(receivedString));

        // 입력받은 문자열이 비어있지 않으면 출력
        if (receivedString[0] != '\0') {
            USART0_SendString("You entered: ");
            USART0_SendString(receivedString);
            USART0_Transmit('\n');
        }

        // 개행 문자 제거 후 처리
        removeNewline(receivedString);

        if (strcmp_P(receivedString, msg_hello_flash) == 0) {
            USART0_SendFlashString(msg_hello);
        } else {
            USART0_SendFlashString(msg_unknown);
        }

        // 리셋 메시지 출력
        USART0_SendFlashString(msg_ready);
                 
        // 입력 문자열에 따라 처리
        if (strcmp_P(receivedString, PSTR("W")) == 0 || strcmp_P(receivedString, PSTR("w")) == 0) {
            Go_Straight();
            USART0_SendFlashString(msg_go_straight);
        } 
        else if (strcmp_P(receivedString, PSTR("S")) == 0 || strcmp_P(receivedString, PSTR("s")) == 0) {
            Back();
            USART0_SendFlashString(msg_back);
        } 
        else if (strcmp_P(receivedString, PSTR("A")) == 0 || strcmp_P(receivedString, PSTR("a")) == 0) {
            Turn_Left();
            USART0_SendFlashString(msg_turn_left);
        } 
        else if (strcmp_P(receivedString, PSTR("D")) == 0 || strcmp_P(receivedString, PSTR("d")) == 0) {
            Turn_Right();
            USART0_SendFlashString(msg_turn_right);
        } 
        else if (strcmp_P(receivedString, PSTR("R")) == 0 || strcmp_P(receivedString, PSTR("r")) == 0) {
            Stop();
            USART0_SendFlashString(msg_stop);
        } 
        else {
            USART0_SendFlashString(msg_invalid);
        }
                   

        distance = measureDistance();
       if (obstacleDetected) {
            obstacleDetected = 0;  // 플래그 리셋

            if (distance <= 15 && !obstacleDetected) {
                obstacleDetected = 1;
                USART0_SendFlashString(msg_obstacle_detected);
            } else if (distance > 15 && obstacleDetected) {
                obstacleDetected = 0;
                USART0_SendFlashString(msg_obstacle_cleared);
            }
        }

 
    

    }
}
