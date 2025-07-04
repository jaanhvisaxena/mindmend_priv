import type { NextRequest } from "next/server"

export async function GET(req: NextRequest) {
    // This endpoint can be used for health checks
    return Response.json({
        status: "Socket.IO server running",
        timestamp: new Date().toISOString(),
    })
}