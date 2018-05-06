#created by: xiaobei
#creation date:2018-03-19
#description:to get remote reposity then remove 
#           other branches except release and 
#           master,then copy branch test from release  
#parameter:none
#purpose:
#modifed:none
#operation:conifg the remote_repo_url the put the scripts under a path and execute
#config:remote_repo_url
#precondition:git clone and pull or push without inputing username and passwd

remote_repo_url="https://pms.going-link.com/diffusion/M/m.git"

#repo_dir=`echo $remote_repo_url | awk -F'/' '{print $6}' | awk -F'.git' '{print $1}'`
pwd=`pwd`
#git_dir=$pwd"/"$repo_dir"/.git"
git_dir="/d/gittest/mtest/m/.git"
function get_remote_repo()
{
git clone $remote_repo_url
}
function get_branch_list() 
{
branch_list=`GIT_DIR=$git_dir git branch -r`
len=`echo $branch_list | awk '{split($0,a,"origin/")}{print length(a)}'`
len=$[ $len - 3 ]
echo "$len"
branch_list=`echo $branch_list | awk '{split($0,a,"origin/")}{for(i=1;i<length(a)-2;i++) print a[i+3]}'`
echo "$branch_list"
}

function rm_branch()
{
branch_list=$(get_branch_list)
len=`echo $branch_list | awk -F' ' '{print $1}'`
#echo $len
for i in `seq $len`
do
	temp=`echo $branch_list | awk -F' ' '{print $i}' i=$[ i + 1 ] `
	if [ "$temp" = "master" ]||[ "$temp" = "release" ]
	then 
		echo "remain  branch $temp"
	else 
		echo "remove branch $temp"
		#GIT_DIR=$git_dir git push origin :$temp
	fi
done
}
function cp_from_release()
{
	echo "copy branch test from release"
	GIT_DIR=$git_dir git checkout -b test origin/release
	GIT_DIR=$git_dir git push origin test:test
}
function rm_all_files()
{
	rm -rf !($0)
}
#get_remote_repo
rm_branch
cp_from_release
rm_all_files

