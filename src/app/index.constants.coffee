'use strict'

angular.module('homemademessClient')
  # @ifdef API_URL
  .constant 'apiUrl', location.protocol+'//'+'
    # @echo API_URL
    '
  # @endif
  # @ifndef API_URL
  .constant 'apiUrl', location.protocol+'//localhost:8666'
  # @endif
  # @ifndef DEBUG
  .constant 'debug', false
  # @endif
  # @ifdef DEBUG
  .constant 'debug',
    # @echo DEBUG
  # @endif

