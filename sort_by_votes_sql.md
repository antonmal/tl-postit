# Sort by voting SQL

```sql
SELECT 	posts.*,
		SUM(CASE votes.vote WHEN 't' THEN 1 WHEN 'f' THEN -1 ELSE 0 END) AS TotalVotes
FROM posts
LEFT OUTER JOIN votes
	ON votes.voteable_id = posts.id AND votes.voteable_type = 'Post'
GROUP BY posts.id
ORDER BY TotalVotes DESC, posts.updated_at DESC;
```

```sql
"SELECT 	posts.*, SUM(CASE votes.vote WHEN 't' THEN 1 WHEN 'f' THEN -1 ELSE 0 END) AS TotalVotes FROM posts LEFT OUTER JOIN votes ON votes.voteable_id = posts.id AND votes.voteable_type = 'Post' GROUP BY posts.id ORDER BY TotalVotes DESC, posts.updated_at DESC"
```

```ruby
Post.joins("LEFT OUTER JOIN votes ON votes.voteable_id = posts.id AND votes.voteable_type = 'Post'").select("posts.*, SUM(CASE votes.vote WHEN 't' THEN 1 WHEN 'f' THEN -1 ELSE 0 END) AS TotalVotes").group("posts.id").order("TotalVotes DESC", "posts.updated_at DESC")
```
