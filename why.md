# why did you ...

## use three separate repos?

In the end I have bundled everything under [local](local), but this makes this repository effectively an online clipboard.   
Since each of these three parts could be implemented differently, they actually belong to three different sub-projects.

## use Gitlab?

If we want to protect the repository from being indexed but still want to publish deployment commands, we'll need tokens.   
I find it a little easier to use deployment tokens with Gitlab.

## use Ubuntu?

I had zero previous acquaintance with Sinatra, so I chose a distribution with the largest user / repository 
base.   
( Just in case I would have to install a gozillion dependencies or run into a gozillion issues and would have to google for related user experience. )

The choice for the orchestration server was the same simply to make it uniform. 

## use Terraform AND Ansible?

For code deployment -- again, I had little previous experience with this web stack, 
so I chose Ansible as the instrument that has the widest choice of pre-existing modules.

For such a small project, we could have used solely either of the two, 
but if we had to develop it any further -- say, add an extra LVM volume, configure HTTPS, etc -- Ansible stil excels at software configuration, 
and Terraform is clearly one of the best instruments to work with virtual infrastructure.   
And it's better to chose the best tools for the job at an early stage of a project.

## use Nginx?

I have had to quickly deploy an unknown web framework, ideally without asking too many questions.   
Since I have no apriory knowledge how safe or powerful it is -- I decided to put it behind a well-known gateway server. 
It will make it easier to configure https in a tested and relaible way, change backend components and will produce a nice boring signature for port scanners.

## configure no local firewall rules?

First, it is always less expensive to use an external firewall. 
Second, in real life I would have probably restricted incoming `ssh` to a particular ip range -- and yes, 
used a local `knockd` configuration if for some reason this is not practical -- but it is probably too much for a "hello, world" example.

Who knows, may be it will be a static app forever and then instead of investing too much effort in protecting it it might just be easier to redeploy it if it's broken.

