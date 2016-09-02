import { ajax } from 'discourse/lib/ajax'

const Feed = Ember.Object.extend({
  asJSON () {
    return {
      url: this.get('url'),
      category_id: this.get('category.id'),
      username: this.get('user.username'),
      interval: this.get('interval'),
      regexp_title_pattern: this.get('regexp_title_pattern'),
      regexp_title_options: this.get('regexp_title_options'),
      regexp_title_replacement: this.get('regexp_title_replacement'),
      regexp_body_pattern: this.get('regexp_body_pattern'),
      regexp_body_options: this.get('regexp_body_options'),
      regexp_body_replacement: this.get('regexp_body_replacement'),
      add_link: this.get('add_link'),
      link_text: this.get('link_text')
    }
  },

  create () {
    return ajax('/admin/plugins/rss-poster/feeds', { type: 'POST', data: this.asJSON() })
  },

  update () {
    var id = this.get('id')
    return ajax(`/admin/plugins/rss-poster/feeds/${id}`, { type: 'PATCH', data: this.asJSON() })
  },

  destroy () {
    var id = this.get('id')
    return ajax(`/admin/plugins/rss-poster/feeds/${id}`, { type: 'DELETE' })
  }
})

Feed.reopenClass({
  find (id) {
    return ajax(`/admin/plugins/rss-poster/feeds/${id}`).then(result => {
      return Feed.create(result)
    })
  },

  findAll () {
    return ajax('/admin/plugins/rss-poster/feeds').then(result => {
      return result.map(feed => Feed.create(feed))
    })
  }
})

export default Feed
