import Feed from '../../discourse/models/feed'

export default Discourse.Route.extend({
  model () {
    return Feed.findAll().then(result => {
      return result
    })
  }
})
