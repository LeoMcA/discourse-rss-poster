import Feed from '../../discourse/models/feed'

export default Ember.Controller.extend({
  status: '',

  actions: {
    new () {
      this.transitionToRoute('adminPlugins.rss-poster.feeds.new')
    },

    refresh () {
      this.set('status', 'Refreshing...')
      Feed.findAll().then(result => {
        this.set('model', result)
        this.set('status', '')
      })
    }
  }
})
