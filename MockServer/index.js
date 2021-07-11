// 参考: json-serverの実装に関する参考資料
// https://blog.eleven-labs.com/en/json-server

// Mock用のJSONレスポンスサーバーの初期化設定
const jsonServer = require('json-server');
const server = jsonServer.create();

// Database構築用のJSONファイル
const router = jsonServer.router('datasource/db.json');

// 各種設定用
const middlewares = jsonServer.defaults();
const rewrite_rules = jsonServer.rewriter({
    "/api/mock/v1/summer_pieces/main_banners" : "/get_main_banners",
    "/api/mock/v1/summer_pieces/main_news" : "/get_main_news",
    "/api/mock/v1/summer_pieces/main_photos?page=:page" : "/get_main_photos?page=:page",
    "/api/mock/v1/summer_pieces/featured_contents" : "/get_featured_contents",
});

// リクエストのルールを設定する
server.use(rewrite_rules);

// ミドルウェアを設定する (※コンソール出力するロガーやキャッシュの設定等)
server.use(middlewares);

// 受信したリクエストにおいてGET送信時のみ許可する
server.use(function (req, res, next) {
    if (req.method === 'GET') {
        next();
    }
});

// ルーティングを設定する
server.use(router);

// サーバをポート3000で起動する
server.listen(3000, () => {
    console.log('NewStyle15 API Mock Server is running...');
});