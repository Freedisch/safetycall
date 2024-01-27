import asyncio
import websockets.server as server

async def echo(websocket):
    async for message in websocket:
        await websocket.send(message)

async def main():
    async with server(echo, "localhost", 8745):
        await asyncio.Future()

asyncio.run(main())