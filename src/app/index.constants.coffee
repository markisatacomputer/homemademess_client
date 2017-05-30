'use strict'

angular.module('homemademessClient')
  # @ifdef API_URL
  .constant 'apiUrl', '
    # @echo API_URL
    '
  # @endif
  # @ifndef API_URL
  .constant 'apiUrl', 'http://localhost:8666'
  # @endif
  # @ifndef DEBUG
  .constant 'debug', false
  # @endif
  # @ifdef DEBUG
  .constant 'debug',
    # @echo DEBUG
  # @endif

