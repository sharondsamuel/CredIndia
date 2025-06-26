from flask import *

from database import *
import os



api=Blueprint('api',__name__)

@api.route('/login',methods=['post'])
def login():
	Uname=request.form['username1']
	Paswd=request.form['password']
	
	
	q="select * from login where username='%s' and password='%s'" % (Uname, Paswd)
	res=select(q)
	print("ddddddddd",q)
	if res:
		login_id=res[0]['login_id']
		
		return jsonify(status="true", lid=res[0]['login_id'], type=res[0]["usertype"])
	else:
		
		return jsonify(status="false")


@api.route('/admin_view_user',methods=['get','post'])
def admin_view_user():
	data={}
	t="select * from users"
	res=select(t)
	print(res)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/admin_view_financecompany',methods=['get','post'])
def admin_view_financecompany():
	data={}
	t="select * from finance_company"
	res=select(t)
	print(res)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/admin_view_finance',methods=['get','post'])
def admin_view_finance():
	data={}
	fid=request.form['fid']
	print("KKKKKKKKKKKKK",fid)
	t="select * from finance where finance_company_id='%s'"%(fid)
	res=select(t)
	print(res)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/admin_view_feedback',methods=['get','post'])
def admin_view_feedback():
	data={}
	
	t="select * from feedback inner join users using(user_id)"
	res=select(t)
	print(res)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")

# =================finance_company===================================


@api.route('/finance_company_reg',methods=['get','post'])
def finance_company_reg():
	cname=request.form['cname']
	place=request.form['place']
	phone=request.form['phone']
	email=request.form['email']
	uname=request.form['username']
	pwd=request.form['password']
	i="insert into login VALUES(null,'%s','%s','company')"%(uname,pwd)
	log=insert(i)
	ii="insert into finance_company values(null,'%s','%s','%s','%s','%s')"%(log,cname,place,phone,email)
	res=insert(ii)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/manage_finance',methods=['get','post'])
def manage_finance():
	finance=request.form['finance']
	details=request.form['details']
	lid=request.form['lid']
	y="insert into finance values(null,(select finance_company_id from finance_company where login_id='%s' limit 1),'%s','%s',curdate())"%(lid,finance,details)
	res=insert(y)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/company_view_finance',methods=['get','post'])
def company_view_finance():
	lid=request.form['lid']
	t="select * from finance where finance_company_id=(select finance_company_id from finance_company where login_id='%s' limit 1)"%(lid)
	res=select(t)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/company_delete_finance',methods=['get','post'])
def company_delete_finance():
	fid=request.form['finance_id']
	t="delete from finance where finance_id='%s'"%(fid)
	res=delete(t)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")

@api.route('/manage_instructions',methods=['get','post'])
def manage_instructions():
	finance_id=request.form['finance_id']
	instructions=request.form['instruction']
	y="insert into instructions values(null,'%s','%s')"%(finance_id,instructions)
	res=insert(y)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/company_view_instructions',methods=['get','post'])
def company_view_instructions():
	finance_id=request.form['finance_id']
	t="select * from instructions where finance_id='%s'"%(finance_id)
	res=select(t)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/company_delete_instructions',methods=['get','post'])
def company_delete_instructions():
	instructions_id=request.form['instructions_id']
	t="delete from instructions where instructions_id='%s'"%(instructions_id)
	res=delete(t)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/company_view_request',methods=['get','post'])
def company_view_request():
	lid=request.form['lid']

	t="select *,request.date as req_date from request inner join finance using(finance_id) inner join users using(user_id) where finance_company_id=(select finance_company_id from finance_company where login_id='%s' limit 1)"%(lid)
	res=select(t)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/company_accept_request',methods=['get','post'])
def company_accept_request():
	request_id=request.form['request_id']
	u="update request set status='Accepted' where request_id='%s'"%(request_id)
	res=update(u)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/company_reject_request',methods=['get','post'])
def company_reject_request():
	request_id=request.form['request_id']
	u="update request set status='Rejected' where request_id='%s'"%(request_id)
	res=update(u)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/company_update_status',methods=['get','post'])
def company_update_status():
	request_id=request.form['request_id']
	u="update request set status='amount as send to account number' where request_id='%s'"%(request_id)
	res=update(u)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/company_view_account',methods=['get','post'])
def company_view_account():
	lid=request.form['lid']
	u="select * from account_details where user_id='%s'"%(lid)
	res=select(u)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/comp_view_query',methods=['get','post'])
def comp_view_query():
	lid=request.form['lid']

	t="select * from querires where finance_company_id=(select finance_company_id from finance_company where login_id='%s' limit 1)"%(lid)
	res=select(t)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/comp_send_query',methods=['get','post'])
def comp_send_query():
	lid=request.form['lid']
	query_id=request.form['query_id']
	reply=request.form['reply']

	t="update querires set reply='%s' where querires_id='%s'"%(reply,query_id)
	res=update(t)
	print(t)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")







# ===============================user===============================

@api.route('/user_reg',methods=['get','post'])
def user_reg():
	fname=request.form['fname']
	lname=request.form['lname']
	place=request.form['place']
	phone=request.form['phone']
	email=request.form['email']
	uname=request.form['username']
	pwd=request.form['password']
	i="insert into login VALUES(null,'%s','%s','user')"%(uname,pwd)
	log=insert(i)
	ii="insert into users values(null,'%s','%s','%s','%s','%s','%s')"%(log,fname,lname,place,phone,email)
	res=insert(ii)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/add_account',methods=['get','post'])
def add_account():
	lid=request.form['lid']
	acc_no=request.form['acc_no']
	ifsc=request.form['ifsc']
	bank_name=request.form['bank_name']
	i="insert into account_details values(null,(select user_id from users where login_id='%s'),'%s','%s','%s')"%(lid,acc_no,ifsc,bank_name)
	res=insert(i)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/view_account',methods=['get','post'])
def view_account():
	lid=request.form['lid']

	i="select * from account_details where user_id=(select user_id from users where login_id='%s')"%(lid)
	res=select(i)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/delete_account',methods=['get','post'])
def delete_account():
	acc_id=request.form['acc_id']
	y="delete from account_details where account_details_id='%s'"%(acc_id)
	res=delete(y)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/user_view_finance',methods=['get','post'])
def user_view_finance():
	data={}
	u="select * from finance inner join finance_company using(finance_company_id)"
	res=select(u)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")

@api.route('/user_view_instructions',methods=['get','post'])
def user_view_instructions():
	data={}
	fid=request.form['fid']
	u="select * from instructions where finance_id='%s'"%(fid)
	res=select(u)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/send_query',methods=['get','post'])
def send_query():
	lid=request.form['lid']
	query=request.form['query']
	cid=request.form['cid']
	i="insert into querires values(null,(select user_id from users where login_id='%s'),'%s','%s','pending',curdate())"%(lid,cid,query)
	res=insert(i)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/user_view_query',methods=['get','post'])
def user_view_query():
	
	lid=request.form['lid']
	cid=request.form['cid']
	
	u="select * from querires inner join finance_company using(finance_company_id) where finance_company_id='%s'"%(cid)
	res=select(u)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/user_view_request',methods=['get','post'])
def user_view_request():
	
	lid=request.form['lid']
	
	
	u="select *,request.date as req_date from request inner join finance using(finance_id) where user_id=(select user_id from users where login_id='%s') "%(lid)
	res=select(u)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/send_feedback',methods=['get','post'])
def send_feedback():
	lid=request.form['lid']
	feedback=request.form['feedback']
	
	i="insert into feedback values(null,(select user_id from users where login_id='%s'),'%s',curdate())"%(lid,feedback)
	res=insert(i)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")

@api.route('/user_view_feedback',methods=['get','post'])
def user_view_feedback():
	
	lid=request.form['lid']

	
	u="select * from feedback where user_id=(select user_id from users where login_id='%s')"%(lid)
	res=select(u)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")
@api.route('/send_request',methods=['get','post'])
def send_request():
	lid=request.form['lid']
	finance_id=request.form['finance_id']
	message=request.form['message']
	
	i="insert into request values(null,'%s',(select user_id from users where login_id='%s'),'%s',curdate(),'pending')"%(finance_id,lid,message)
	res=insert(i)
	if res:
		return jsonify(status="true",data=res)
	else:
		return jsonify(status="false")

