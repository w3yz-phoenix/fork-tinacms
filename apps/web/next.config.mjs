/** @type {import('next').NextConfig} */
export default {
  async rewrites() {
    return [
      {
        source: "/",
        destination: "/home",
      },
    ];
  },
};
