for f in hblf*; do
  name="$f"
  rm "$f"
  curl -L "https://drive.usercontent.google.com/download?id=1aoh4Yq3Uwj4l12kyiOXxe6CgbWag46KG&export=download&authuser=7&confirm=t&uuid=e7163ae0-1849-4e7f-91b3-bbcabeb23024&at=APcmpowk5zuGxn69VZvEM6wT_5uk:1744350908612" -o "$name"
done
