import Feed from '../../discourse/models/feed'

export default Ember.Controller.extend({
  status: '',

  actions: {
    save () {
      this.set('status', 'Saving...')
      var feed = Feed.create(this.get('model'))
      feed.create().then(() => {
        this.set('status', '')
        this.transitionToRoute('adminPlugins.rss-poster.feeds')
      })
    },

    destroy () {
      this.transitionToRoute('adminPlugins.rss-poster.feeds')
    }
  }
})
