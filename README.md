Album Photo App Demo
==========

Basic Album iOS app in Swift :)


## Requirements

- iOS 10.3+ / Mac OS X 10.12+
- Xcode 8.3+
- Swift 3.0+


## - Network:  3 calls API LastFM
All use  this MBID identifier for loading and fetching the data
Sometimes API returns some metadata that is not with identifier I show them currently in the app
but the identifier is missing so there is no Albums in detail screen

1. search.topArtist (SearchViewController)
2. artist.getTopAlbums (AlbumsVC)
3. album.getInfo (DetailVC)

## - Persistent data: Core Data

Saving AlbumInfo object and deleting it with identifier MBID
1. fetch.albumsInfo (Main View Controller is only visible if user navigate back button as this is the storage vc)
2. delete.albumInfo managed object

## The basic user flow in place:
First screen is empty the first time used the app, after that
search is started with preferable famous artist search names (limited db).
Shows Artists name - chosen one shows albums if any. (if not the app is just white)
If albums chosen its shows the details and tracks if not the template says "no album details”
Taping on back arrow takes you to the storage screen with all albums.

required cocoapods :
Alamofire
AlamofireImage
SHSearchBar


## shortcomings:
- Connecting APIClient and APIRouter was not finished successfully so I went end finished all through
  APIClient instead ( refactoring )
- Error handling is not implemented fully
- AlbumsViewController has logic for shoving bookmark indictor from detailVC- this was required to be view controller to delete the call from saving  to core data, I was not sure on that one.  - fixed

