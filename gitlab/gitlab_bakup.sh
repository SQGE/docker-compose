#!/bin/bash
backdir=/data/gitlab/data/backups
gitlab_back(){
/usr/bin/docker exec -i gitlab /opt/gitlab/bin/gitlab-rake gitlab:backup:create
}

delete_back(){
find $backdir -mtime +2 -type f | xargs rm -f  
}

rsync_back(){
rsync -avz $backdir --delete -e 'ssh -p 22' root@10.26.190.102:/data/gitlab_backup
}

sync(){
   rsync_back
if [ $? -ne 0 ]; then
   rsync_back 
else
   cd $backdir && du -sh *  | mail -s "gitlab备份状态" duanzh30198@hsyuntai.com
fi

}
gitlab_back 
delete_back
sync
