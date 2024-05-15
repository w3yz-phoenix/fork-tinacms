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
        source: "/cms/:path*",
        destination: `http://localhost:3200/:path*`,
      },
    ];
  },
};
