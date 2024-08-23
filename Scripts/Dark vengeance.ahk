/* 3D accelleration fix: nopes a "je..." after a "test eax, eax" which is the returnb adress
 * for a IDirectDraw::GetAvailableVidMem call. The GetAvailableVidMem hook should fix this,
 * no ideo why i doesn' t
 */

;write_process_memory(Get_process_handle(g_.target_name),  0x441eae, "array",  [0x90, 0x90])
;REMOTE SCRIPT START
