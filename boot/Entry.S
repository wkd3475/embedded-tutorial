.text
	.code 32
	.global vector_start
	.global vector_end

	vector_start:
		MOV	R0, R1
	Vector_end:
		.space 1024, 0
.end
