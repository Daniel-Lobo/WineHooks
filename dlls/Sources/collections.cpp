#include <windows.h>
//#include "console.h"
#include "collections.h"
#include <map>
#include <string>
using std::map;

/*
struct POINTER_DICTIONARY {
    /* Here we intend keys to be pointers and values to be pointers to
     * data related to the corresponding keys but not pointed by it


    DWORD     count;
    LPVOID *  keys;
    LPVOID *  values;
*/
#define POINTER_DICTIONARY_USE_CPP_MAP
#ifndef POINTER_DICTIONARY_USE_CPP_MAP
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
#else //POINTER_DICTIONARY_USE_CPP_MAP

POINTER_DICTIONARY::POINTER_DICTIONARY(void)
{
    count = 0;
    m_map = (LPVOID) new std::map<LPVOID, LPVOID>();    
}

DWORD POINTER_DICTIONARY::insert(LPVOID key, LPVOID value)
{
    auto map = (std::map<LPVOID, LPVOID> *)m_map;
    if (Value(key)) {
        remove(key);
    }
    map->insert( std::pair<LPVOID,LPVOID>(key, value) );    
    count    = map->size();
    return count;
}

DWORD POINTER_DICTIONARY::insert_disposable(LPVOID key, LPVOID value)
{
    auto map = (std::map<LPVOID, LPVOID> *)m_map;
    if (Value(key)) {
        map->operator[](key) = value; // Update existing value
        return map->size();
    }
    map->insert( std::pair<LPVOID,LPVOID>(key,value) );    ;    
    count    = map->size();
    return count;
}


DWORD POINTER_DICTIONARY::remove(LPVOID key)
{
    auto map = (std::map<LPVOID, LPVOID> *)m_map;
    auto it  = map->find(key);
    if (it != map->end()) {
        VirtualFree(it->second, 0, MEM_RELEASE);
        map->erase(it);
    }   
    count    = map->size();
    return count;
}

DWORD POINTER_DICTIONARY::discard(LPVOID key)
{
    auto map = (std::map<LPVOID, LPVOID> *)m_map;
    auto it  = map->find(key);
    if (it != map->end()) {
        map->erase(it);
    }   
    count    = map->size();
    return count;
}

LPVOID POINTER_DICTIONARY::Value(LPVOID key)
{
    auto map = (std::map<LPVOID, LPVOID> *)m_map;
    auto it  = map->find(key);
    return it != map->end() ? map->operator[](key) : nullptr;
}

LPVOID POINTER_DICTIONARY::Key(LPVOID value)
{
    auto map = (std::map<LPVOID, LPVOID> *)m_map;
    for (const auto& pair : *(std::map<LPVOID, LPVOID> *)m_map) {
        if (pair.second == value) {
            return pair.first;
        }
    }
    return nullptr;
}

LPVOID POINTER_DICTIONARY::ValueAt(size_t index)
{
    auto map = (std::map<LPVOID, LPVOID> *)m_map;
    if (index >= map->size()) return (LPVOID) map->size();
    auto it = std::next(map->begin(), index);
    return it->second;
}

LPVOID POINTER_DICTIONARY::KeyAt(size_t index)
{
    auto map = (std::map<LPVOID, LPVOID> *)m_map;
    if (index >= map->size()) return (LPVOID)index;
    auto it = std::next(map->begin(), index);
    return it->first;
}

DWORD POINTER_DICTIONARY::Count()
{    
    auto map = (std::map<LPVOID, LPVOID> *)m_map;
    return map->size();
}

LPVOID POINTER_DICTIONARY::Data(LPVOID key, DWORD size)
{
    auto map   = (std::map<LPVOID, LPVOID> *)m_map;
    LPVOID val = Value(key);
    if (val) {
        LPVOID mem = malloc(size);
        memcpy(mem, val, size);
        return mem;
    }
    return nullptr;
}

POINTER_DICTIONARY::~POINTER_DICTIONARY()
{
    return;
}

#endif

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
