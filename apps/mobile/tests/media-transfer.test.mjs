import { createBoundedMediaTransfer } from '../src/services/media/BoundedMediaTransfer.ts';
import test from 'node:test';
import assert from 'node:assert/strict';

test('bounded transfer aborts overflow before writing bytes past expected size',async()=>{
  const chunks=[];let signal;let redirect;
  const transfer=createBoundedMediaTransfer(async(_url,init)=>{signal=init.signal;redirect=init.redirect;return new Response(new Uint8Array(9),{headers:{'Content-Type':'image/jpeg'}});},async()=>({write:b=>chunks.push(...b),close(){}}));
  await assert.rejects(transfer('https://media.example.com/a','staged',8),/size/i);
  assert.equal(chunks.length,0);assert.equal(signal.aborted,true);assert.equal(redirect,'error');
});
test('bounded transfer writes complete bytes and rejects HTTP errors',async()=>{
  const chunks=[];const transfer=createBoundedMediaTransfer(async()=>new Response(new Uint8Array([1,2,3]),{headers:{'Content-Type':'image/png','Content-Length':'3'}}),async()=>({write:b=>chunks.push(...b),close(){}}));
  assert.equal((await transfer('https://media.example.com/a','staged',3)).mimeType,'image/png');assert.deepEqual(chunks,[1,2,3]);
  const failed=createBoundedMediaTransfer(async()=>new Response('error',{status:403}),async()=>{throw Error('should not open');});
  await assert.rejects(failed('https://media.example.com/a','staged',3),/HTTP 403/);
});

test('content length mismatch rejects before opening a staging file',async()=>{
  const transfer=createBoundedMediaTransfer(async()=>new Response(new Uint8Array(9),{headers:{'Content-Length':'9'}}),async()=>{throw Error('should not open');});
  await assert.rejects(transfer('https://media.example.com/a','staged',8),/size/i);
});
test('an interrupted body closes the writer and cancels the request',async()=>{
  let closed=false;let signal;
  const transfer=createBoundedMediaTransfer(async(_url,init)=>{
    signal=init.signal;
    return new Response(new ReadableStream({pull(controller){controller.error(Error('connection lost'));}}));
  },async()=>({write(){},close(){closed=true;}}));
  await assert.rejects(transfer('https://media.example.com/a','staged',8),/connection lost/);assert.equal(closed,true);assert.equal(signal.aborted,true);
});
