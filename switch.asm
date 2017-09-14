.gba
.thumb
.loadtable "encoding.tbl"
.create "output.gba",0x08000000
.close
.open "bprf.gba","output.gba",0x08000000


.org 0x08800000 // YOUR CHOICE: Where you want this routine to be included
.align 2
Switch:
	push {r0-r6,lr}
// Gender
	ldr r4, [PLAYER_DATAS_DMA]
	ldr r0, [r4, #0x4]
	ldrb r2, [r0, #0x8]
	mov r5, #0x1
	sub r5, r2
	strb r5, [r0, #0x8] // from here r5 store the gender
// Name
	ldr r2, =B_NAME
	lsl r0, r5, #0x3
	add r0, r2
	ldr r1, [r4, #0x4]
	ldr r3, [r0]
	str r3, [r1]
	ldr r3, [r0, #0x4]
	str r3, [r1, #0x4]
// Check merge
	ldr r4, =0x0806E6F4|1 // get_flag(flag_id)
	ldr r0, [MERGE_FLAG]
	bl blx
//	cmp r0, #0x0
//	bne return 
// Current Box
	ldr r2, [r2, #0x4]
	lsl r0, r5, #0x1
	add r0, r5
	lsl r0, #0x1
	strb r0, [r2]
// Party
	mov r0, #0xC
	lsl r1, r5, #0x3
	ldr r2, [PLAYER_PARTY]
	mov r3, #0x0
	ldr r4, =0x0808BD78|1 // send_poke_to_box(box_index, inbox_index, src)
@@send_party:
	cmp r3, #0x6
	bge @@send_party_done
	push {r0-r3}
	bl blx
	pop {r0-r3}
	add r1, #0x1
	add r2, #0x64
	add r3, #0x1
	b @@send_party
@@send_party_done:
	mov r1, #0x1
	sub r1, r5
	lsl r1, r1, #0x3
	ldr r2, [PLAYER_PARTY]
	mov r3, #0x0
	ldr r4, =0x0808BEB4|1 // get_poke_from_box(box_index, inbox_index, dest)
@@get_party:
	cmp r3, #0x6
	bge @@get_party_done
	push {r0-r3}
	bl blx
	pop {r0-r3}
	add r1, #0x1
	add r2, #0x64
	add r3, #0x1
	b @@get_party
@@get_party_done:
// Money
	ldr r5, [PLAYER_DATAS_DMA]
	ldr r3, [r5]
	mov r1, #0xA4
	lsl r1, #0x2
	add r3, r1
	mov r0, r3 // r3 = key
	ldr r4, =0x0809FF0C|1 // get_money(encrypt_key)
	bl blx
	ldr r1, [r5, #0x8]
	mov r2, #0x79
	lsl r2, #0x8
	add r2, #0xE4
	add r2, r1 // r2 = 14th box addr
	ldr r1, [r2]
	str r0, [r2]
	mov r0, r3
	ldr r4, =0x0809FF24|1 // set_money(encrypt_key, ammount)
	bl blx
// Bag
// Box items	
// Badges
// Pokedex
return:
	pop {r0-r6,pc}
blx:
	bx r4

.align 4
PLAYER_DATAS_DMA:
	.word 0x03004F58
PLAYER_GENDER_DMA:
	.word 0x0300500C
PLAYER_PARTY:
	.word 0x02024284
B_NAME:
	.area 0x8,0xFF
	.string "Arnik" // YOUR CHOICE: The name of the guy
	.endarea
G_NAME:
	.area 0x8,0xFF
	.string "Unifag" // YOUR CHOICE: The name of the girl
	.endarea
MERGE_FLAG:
	.word 0x0154 // YOUR CHOICE: Merge flag
.align 4
.pool

.close
