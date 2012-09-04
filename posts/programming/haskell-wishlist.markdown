

in ghci:

  > import Data.Text

  > let xs = [pack $ "user",pack "app"]
Prelude Data.Text> splitAt 1 xs

<interactive>:19:1:
    Ambiguous occurrence `splitAt'
    It could refer to either `Data.Text.splitAt',
                             imported from `Data.Text'
                          or `Prelude.splitAt',
                             imported from `Prelude' (and originally defined in `GHC.List')

  > 
  
  Fix: call `Data.Text.splitAt`
  Wish: `Text.splitAt` should work too.

