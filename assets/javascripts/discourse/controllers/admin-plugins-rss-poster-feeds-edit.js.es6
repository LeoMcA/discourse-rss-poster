import Feed from '../../discourse/models/feed'

export default Ember.Controller.extend({
  actions: {
    save () {
      this.get('model').update().then(() => {
        this.transitionToRoute('adminPlugins.rss-poster.feeds')
      })
    },

    destroy () {
      this.get('model').destroy().then(() => {
        this.transitionToRoute('adminPlugins.rss-poster.feeds')
      })
    }
  }
})
