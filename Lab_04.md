
## Lab 5: Implementing Ansible Variables

---------------------------------------------------------------------------------------------
### Task 1: Configuring packages in ansible using variables
```
cd ~/ansible-labs/
```
```
mkdir file && cd file
```
```
vi implement-vars.yml
```

We are using variables, hostname, package1, package2, portno, and path. We are not directly specifying 
the value of these variables at their places

Add the given content, by pressing "INSERT" 
```
---
- hosts: '{{ hostname }}'
  become: yes
  vars:
    hostname: all
    package1: httpd
    destination: /var/www/html/index.html 
    source: /home/ec2-user/ansible-labs/index.html
  tasks:
    - name: Install defined package
      yum:
        name: '{{ package1 }}'
        update_cache: yes
        state: latest
    - name: Start desired service
      service:
        name: '{{ package1 }}'
        state: started
    - name: copy required index.html to the document folder for httpd. 
      copy:
        src: '{{ source }}'
        dest: '{{ destination }}'
```

**save the file using** `ESCAPE + :wq!`


**save the file using** `ESCAPE + :wq!`
```
ansible-playbook implement-vars.yml
```

Go to aws console. Copy 'Public IPv4 DNS' name from the instance details.
Paste that into a browser and observe that the web page is coming up
The web page should display the message "This is the Selected Home Page"

-------------------------------------------------------------------------------------------------
### Task 2 : Create an alternate index_new.html file

create index1.html 

```
vi index1.html
```
```
<html>
  <body>
  <h1>This is the alternate Home Page</h1>
  </body>
</html>
```
**save the file using** `ESCAPE + :wq!`
```
ansible-playbook implement-vars.yml --extra-vars "source=/home/ec2-user/ansible-labs/file/index1.html"
```

Check the home page on browser. It should show the new page now
It should show "This is the revised Home Page !!"

------------------------------------------------------------------------------------------
### Task 3 : Use separate variables file

Move variables to new separate file 
```
vi myvariables.yml
```
add the folowing in the myvariables.yml file.
```
---
hostname: all
package1: httpd
destination: /var/www/html/index.html
source: /home/ec2-user/ansible-labs/index.html
...
```
save the file using "ESCAPE + :wq!"

Add the given content, by pressing "INSERT" 

Now edit implement-vars.yml playbook. Replace vars block with vars_file reference.
```
vi implement-vars.yml
```
```
---
- hosts: '{{ hostname }}'
  become: yes
  vars_files:
    - myvariables.yml
  tasks:
    - name: Install defined package
      yum:
        name: '{{ package1 }}'
        update_cache: yes
        state: latest
    - name: Start desired service
      service:
        name: '{{ package1 }}'
        state: started
    - name: copy required index.html to the document folder for httpd. 
      copy:
        src: '{{ source }}'
        dest: '{{ destination }}'
```
**save the file using** `ESCAPE + :wq!`
```
$ansible-playbook implement-vars.yml
```
Check the home page on browser. 
It should show the original page with msg "This is the Selected Home Page"