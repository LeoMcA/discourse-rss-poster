import Feed from '../../discourse/models/feed'

export default Ember.Controller.extend({
  actions: {
    save () {
      var feed = Feed.create(this.get('model'))
      feed.create().then(() => {
        this.transitionToRoute('adminPlugins.rss-poster.feeds')
      })
    },

    destroy () {
      this.transitionToRoute('adminPlugins.rss-poster.feeds')
    }
  }
})
