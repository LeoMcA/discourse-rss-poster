import Feed from '../../discourse/models/feed'

export default Ember.Controller.extend({
  status: '',

  actions: {
    save () {
      this.set('status', 'Saving...')
      this.get('model').update().then(() => {
        this.set('status', '')
        this.transitionToRoute('adminPlugins.rss-poster.feeds')
      })
    },

    destroy () {
      this.set('status', 'Deleting...')
      this.get('model').destroy().then(() => {
        this.set('status', '')
        this.transitionToRoute('adminPlugins.rss-poster.feeds')
      })
    }
  }
})
