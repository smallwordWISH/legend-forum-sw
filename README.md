# Legend Forum

## Web API

### index view all posts 
1. GET
```
/api/v1/posts  
```

### show post
1. GET
```
/api/v1/posts/:id
```
2. params:  
(a)params: auth_token  

### create post	
1. POST 
```
/api/v1/posts
```
2. params:  
(a) title: string  
(b) content: string  
(c) authority: string(all or firend or myself)  
(d) draft(choice): boolean  
(e) category_ids[](choice): integer  
*for multiple categories add anothor category_ids[] parmas, e.g. category_ids[]=3&category_ids[]=4  
(f) auth_token  

### edit post
1. PATCH
```
/api/v1/posts/:id
```
2. params: *same as above  

### delete post
1. DELETE	
```
/api/v1/posts/:id
```
2. params:  
(a)auth_token  

### login to get auth_token
1. POST
```
/api/v1/login  
```
2. params:  
(a)email  
(b)password  

### logout
1. POST
```
/api/v1/logout
```
2. params:  
(a) auth_token  
