# Auto-sync multiple GitHub repositories by comparing novelty.
    Yes, I am sure, Jhon, my code is infallible, my commits are impeccable. Sraight to production, it has to go straight to production. - Larry, the senior dev


Copy "sync_repos.sh" script to the defined path (ex. /path/to/script).
Navigate to the path.

```shell
cd /repos/sync-repos
```

chmod the script for execution.

```shell
chmod +x sync_repos.sh
```

Copy "/service-config" folder contents to "/etc/systemd/system" folder.
NOTE: change update frequency by editing sync_repos.timer as needed
Enable and start the systemd timer.

```shell
sudo systemctl enable sync_repos.timer
sudo systemctl start sync_repos.timer
```

Check the status of the timer and service to ensure everything is working correctly.

```shell
sudo systemctl status sync_repos.timer
sudo systemctl status sync_repos.service
```