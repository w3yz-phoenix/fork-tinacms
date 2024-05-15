/** @type {import('next').NextConfig} */
export default {
  images: {
    remotePatterns: [
      {
        hostname: "*",
      },
    ],
  },
  async rewrites() {
    return [
      {
        source: "/",
        destination: "/home",
      },
      {
        source: "/admin/:path*",
        destination: `http://localhost:3200/admin/:path*`,
      },
      {
        source: "/api/tina/:path*",
        destination: `http://localhost:3200/api/tina/:path*`,
      },
    ];
  },
};
