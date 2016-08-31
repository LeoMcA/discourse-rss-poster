import Feed from '../../discourse/models/feed'

export default Ember.Controller.extend({
  actions: {
    new () {
      this.transitionToRoute('adminPlugins.rss-poster.feeds.new')
    },

    refresh () {
      Feed.findAll().then(result => {
        this.set('model', result)
      })
    }
  }
})
