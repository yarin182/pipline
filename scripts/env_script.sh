#!/bin/bash
app_base_dir=/ctkroot.${JOB_BASE_NAME}
svn_base=svn://svn.communitake.com/svn.ct
build_strict=false
svn_rep=${JOB_NAME//\/*//}
svn_rep=${svn_rep//\//}
if [ "${svn_rep}" == "ctprod" ]; then
	SVN_REL_URL="versions/ctprod"
	SVN_FULL_URL="${svn_base}/versions/ctprod"
	build_strict=true
elif [ "${svn_rep}" == "staging" ]; then
	SVN_REL_URL="versions/staging"
	SVN_FULL_URL="${svn_base}/versions/staging"
	build_strict=true
elif [ "${svn_rep}" == "trunk" ]; then
       	SVN_FULL_URL="${svn_base}/trunk"
	SVN_REL_URL="trunk"
elif [ "${svn_rep}" == "trunk174" ]; then
        SVN_FULL_URL="${svn_base}/branches/trunk174"
	SVN_REL_URL="branches/trunk174"
elif [ "${svn_rep}" == "ctprod-comctk" ]; then
	SVN_REL_URL="versions/ctprod-comctk"
	SVN_FULL_URL="${svn_base}/versions/ctprod-comctk"
	build_strict=true
fi

if [ ! -z $svnrevision ]; then
	SVN_FULL_URL="$SVN_FULL_URL@$svnrevision"
fi
deploy_name=${JOB_NAME/${svn_rep}//}
deploy_name=${deploy_name:2}
deploy_name2=${deploy_name//\//_}


mkdir -p /tmp/${JOB_NAME}
propfile=/tmp/${JOB_NAME}/props
echo "app_base_dir=$app_base_dir" > $propfile
echo "svn_base=$svn_base" >> $propfile
echo "build_strict=$build_strict" >> $propfile
echo "svn_rep=$svn_rep" >> $propfile
echo "SVN_REL_URL=$SVN_REL_URL" >> $propfile
echo "SVN_FULL_URL=$SVN_FULL_URL" >> $propfile
echo "deploy_name=$deploy_name" >> $propfile
echo "deploy_name2=$deploy_name2" >> $propfile

