export default {
  resource: 'admin.adminPlugins',
  path: '/plugins',
  map () {
    this.route('rss-poster', function () {
      this.route('feeds', function () {
        this.route('new')
        this.route('edit', { path: '/:feed_id' })
      })
    })
  }
}
