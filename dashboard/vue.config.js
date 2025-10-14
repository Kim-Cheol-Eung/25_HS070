const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    proxy: { // proxyTable 설정
        '/api': { 
            target: 'http://localhost:3000', // 주소
            changeOrigin: true, // /api로 호출시 target으로 변경할 건지
            pathRewrite: {
              "^/api":"/api"
            }
        }
    }
  }
})
