/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    swcPlugins: [['fluentui-next-appdir-directive', { paths: ['@griffel', '@fluentui'] }]],
  },
  images: {
    minimumCacheTTL: 60,
  },
  reactStrictMode: false,
};

module.exports = nextConfig;
