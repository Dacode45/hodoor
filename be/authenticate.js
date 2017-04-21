function authenticate(name, pass, fn) {
  if (!module.parent) console.log('authenticating %s:%s', name, pass);

  try {
    const post = await db.get('SELECT * FROM Users WHERE id = ?', req.params.id),
    if (post) {
      if (post.password === pass) {
        return fn(post, null)
      }
    }
    fn(null, {msg: "Wrong password!"})
  } catch (err) {
    fn(null, err);
  }
}
