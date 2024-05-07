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
    ];
  },
};
