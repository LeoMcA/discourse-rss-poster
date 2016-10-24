import { htmlHelper } from 'discourse-common/lib/helpers'

export default htmlHelper(feed => {
  if (feed.status === 'running') {
    return 'Running'
  } else if (feed.status === 'error') {
    return `<span style="color:#f00;" title="${feed.exception}">Failure</span>`
  } else if (feed.status === 'success') {
    var failures = feed.failures || 0
    if (failures == 0) {
      return '<span style="color:#0f0;">Success</span>'
    } else {
      var plural = (failures > 1) ? 's' : ''
      return `<span style="color:#f00;" title="${feed.exceptions}">${failures} Failure${plural}</span>`
    }
  } else {
    return feed.status
  }
})
