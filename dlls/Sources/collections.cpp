#include <windows.h>
//#include "console.h"
#include "collections.h"

/*
struct POINTER_DICTIONARY {
    /* Here we intend keys to be pointers and values to be pointers to
     * data related to the corresponding keys but not pointed by it


    DWORD     count;
    LPVOID *  keys;
    LPVOID *  values;
*/

POINTER_DICTIONARY::POINTER_DICTIONARY(void)
{
    this->keys   = 0;
    this->values = 0;
    this->count  = 0;
}

DWORD POINTER_DICTIONARY::insert(LPVOID key, LPVOID value)
{
    if (this->Value(key)) this->remove(key);
    LPVOID * newkeys   = (LPVOID *) malloc(sizeof(size_t *) * (this->count+1));
    LPVOID * newvalues = (LPVOID *) malloc(sizeof(size_t *) * (this->count+1));
    LPVOID * loop_newkeys = newkeys;
    LPVOID * loop_newvalues = newvalues;
    LPVOID * loop_oldkeys = this->keys;
    LPVOID * loop_oldvalues = this->values;

    size_t i;
    for (i=0; i<this->count; i++)
    {
        *loop_newkeys = *loop_oldkeys;
        *loop_newvalues = *loop_oldvalues;
        loop_newkeys ++ ;
        loop_newvalues ++ ;
        loop_oldkeys ++ ;
        loop_oldvalues ++ ;
    }

    if (this->count > 0)
    {
        free(this->keys);
        free(this->values);
    }

    *loop_newkeys   = key;
    *loop_newvalues = value;
    this->keys   = newkeys;
    this->values = newvalues;
    this->count += 1;
    return this->count;
}

DWORD POINTER_DICTIONARY::insert_disposable(LPVOID key, LPVOID value)
{
    if (this->Value(key)) this->discard(key);
    LPVOID * newkeys   = (LPVOID *) malloc(sizeof(size_t *) * (this->count+1));
    LPVOID * newvalues = (LPVOID *) malloc(sizeof(size_t *) * (this->count+1));
    LPVOID * loop_newkeys = newkeys;
    LPVOID * loop_newvalues = newvalues;
    LPVOID * loop_oldkeys = this->keys;
    LPVOID * loop_oldvalues = this->values;

    size_t i;
    for (i=0; i<this->count; i++)
    {
        *loop_newkeys = *loop_oldkeys;
        *loop_newvalues = *loop_oldvalues;
        loop_newkeys ++ ;
        loop_newvalues ++ ;
        loop_oldkeys ++ ;
        loop_oldvalues ++ ;
    }

    if (this->count > 0)
    {
        free(this->keys);
        free(this->values);
    }

    *loop_newkeys   = key;
    *loop_newvalues = value;
    this->keys   = newkeys;
    this->values = newvalues;
    this->count += 1;
    return this->count;
}

DWORD POINTER_DICTIONARY::remove(LPVOID key)
{
    if (!this->Value(key)) return this->count;
    LPVOID * newkeys   = (LPVOID *) malloc(sizeof(size_t *) * (this->count-1));
    LPVOID * newvalues = (LPVOID *) malloc(sizeof(size_t *) * (this->count-1));
    LPVOID * loop_newkeys = newkeys;
    LPVOID * loop_newvalues = newvalues;
    LPVOID * loop_oldkeys = this->keys;
    LPVOID * loop_oldvalues = this->values;

    size_t i;
    for (i=0; i<this->count; i++)
    {
        if (*loop_oldkeys != key)
        {
            *loop_newkeys = *loop_oldkeys;
            *loop_newvalues = *loop_oldvalues;
            loop_newkeys ++ ;
            loop_newvalues ++ ;
        } else VirtualFree((LPVOID)this->values[i], 0, MEM_RELEASE);

        loop_oldkeys ++ ;
        loop_oldvalues ++ ;
    }

    if (this->count > 0)
    {
        free(this->keys);
        free(this->values);
    }

    this->keys   = newkeys;
    this->values = newvalues;
    this->count -= 1;
    return this->count;
}

DWORD POINTER_DICTIONARY::discard(LPVOID key)
{
    if (!this->Value(key)) return this->count;
    LPVOID * newkeys   = (LPVOID *) malloc(sizeof(size_t *) * (this->count-1));
    LPVOID * newvalues = (LPVOID *) malloc(sizeof(size_t *) * (this->count-1));
    LPVOID * loop_newkeys = newkeys;
    LPVOID * loop_newvalues = newvalues;
    LPVOID * loop_oldkeys = this->keys;
    LPVOID * loop_oldvalues = this->values;

    size_t i;
    for (i=0; i<this->count; i++)
    {
        if (*loop_oldkeys != key)
        {
            *loop_newkeys = *loop_oldkeys;
            *loop_newvalues = *loop_oldvalues;
            loop_newkeys ++ ;
            loop_newvalues ++ ;
        } //else VirtualFree((LPVOID)this->values[i], 0, MEM_RELEASE);

        loop_oldkeys ++ ;
        loop_oldvalues ++ ;
    }

    if (this->count > 0)
    {
        free(this->keys);
        free(this->values);
    }

    this->keys   = newkeys;
    this->values = newvalues;
    this->count -= 1;
    return this->count;
}


LPVOID POINTER_DICTIONARY::Value(LPVOID key)
{
    size_t i;
    if (this->count == 0) {return 0;}
    for (i=0; i<this->count; i++)
    {
        if (key == this->keys[i])
            return this->values[i];
    }return 0;
}

LPVOID POINTER_DICTIONARY::Key(LPVOID value)
{
    size_t i;
    if (this->count == 0) {return 0;}
    for (i=0; i<this->count; i++)
    {
        if (value == this->values[i])
            return this->keys[i];
    }return 0;
}


LPVOID POINTER_DICTIONARY::ValueAt(size_t index)
{
    if (index >= this->count)
        return 0;
    return this->values[index];
}

LPVOID POINTER_DICTIONARY::KeyAt(size_t index)
{
    if (index >= this->count)
        return 0;
    return this->keys[index];
}

DWORD POINTER_DICTIONARY::Count()
{
    return this->count;
}

LPVOID POINTER_DICTIONARY::Data(LPVOID key, DWORD size)
{
    LPVOID val;
    if (val = this->Value(key))
    {
        LPVOID mem = malloc(size);
        memcpy(mem, val, size);
        return mem;
    }
    return 0;
}

POINTER_DICTIONARY::~POINTER_DICTIONARY() {
    free(this->keys);
    free(this->values);;
}

extern "C" __declspec(dllexport)
POINTER_DICTIONARY * PointerCollectionCreate() {
    return new POINTER_DICTIONARY();
}

/*
extern "C" __declspec(dllexport)
DWORD PointerCollectionInsert(POINTER_DICTIONARY * pd, LPVOID key, LPVOID value){
    return pd->insert(key, value);
}

extern "C" __declspec(dllexport)
DWORD PointerCollectionInsertDisposable(POINTER_DICTIONARY * pd, LPVOID key, LPVOID value){
    return pd->insert_disposable(key, value);
}

extern "C" __declspec(dllexport)
DWORD PointerCollectionRemove(POINTER_DICTIONARY * pd, LPVOID key){
    return pd->remove(key);
}

extern "C" __declspec(dllexport)
DWORD PointerCollectionDiscard(POINTER_DICTIONARY * pd, LPVOID key){
    return pd->discard(key);
}

extern "C" __declspec(dllexport)
LPVOID PointerCollectionValue(POINTER_DICTIONARY * pd, LPVOID key){
    return pd->Value(key);
}

extern "C" __declspec(dllexport)
LPVOID PointerCollectionKey(POINTER_DICTIONARY * pd, LPVOID value){
    return pd->Key(value);
}

extern "C" __declspec(dllexport)
LPVOID PointerCollectionValueAt(POINTER_DICTIONARY * pd, size_t index){
    return pd->ValueAt(index);
}

extern "C" __declspec(dllexport)
LPVOID PointerCollectionKeyAt(POINTER_DICTIONARY * pd, size_t index){
    return pd->KeyAt(index);
}

extern "C" __declspec(dllexport)
size_t PointerCollectionCount(POINTER_DICTIONARY * pd){
    return pd->count;
}
*/
