import Feed from '../../discourse/models/feed'

export default Discourse.Route.extend({
  model (params) {
    return Feed.find(params.feed_id).then(result => {
      return result
    })
  }
})
