export default Discourse.Route.extend({
  model () {
    return {
      category: {},
      user: {}
    }
  },
  renderTemplate () {
    this.render('admin-plugins-rss-poster-feeds-edit', {
      controller: 'admin-plugins-rss-poster-feeds-new'
    })
  },
  setupController (controller, model) {
    this.controllerFor('admin-plugins-rss-poster-feeds-new').set('model', model)
  }
})
