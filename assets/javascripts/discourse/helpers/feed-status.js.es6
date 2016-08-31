import { htmlHelper } from 'discourse/lib/helpers'

export default htmlHelper(feed => {
  if (feed.status === 'success') {
    return '<span style="color:#0f0;">Success</span>'
  } else if (feed.status === 'error') {
    return `<span style="color:#f00;" title="${feed.exception}">Failure</span>`
  } else {
    return feed.status
  }
})
