--恶魔之星 布莱克星
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000119)
if rsufo then return end
rsufo = cm
rsufo.code = {}
rscf.DefineSet(rsufo,0xaf5)
function rsufo.ShowFun(c,code,ecode,cate,flag,con,excost,tg,op,checks)
	local e1=rsef.QO(c,ecode,{code,0},{1,code},cate,flag,LOCATION_HAND,cm.scon(checks,con),cm.scost(excost),tg,cm.sop(checks,op))
	rsufo.code[e1]=code 
	return e1
end
function rsufo.ShowFunT(c,code,ecode,cate,flag,con,excost,tg,op,checks)
	local e1=rsef.FTO(c,ecode,{code,0},{1,code},cate,flag,LOCATION_HAND,cm.scon(checks,con),cm.scost(excost),cm.stg(tg),cm.sop(checks,op))
	rsufo.code[e1]=code 
	return e1
end
function cm.scon(checks,con)
	return function(e,...)
		local tp=e:GetHandlerPlayer()
		return (not checks or Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)) and (not con or con(e,...))
	end
end
function cm.scost(excost)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return not c:IsPublic() and (not excost or excost(e,tp,eg,ep,ev,re,r,rp,0)) end 
		if excost then
			excost(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
end
function cm.stg(tg)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:IsAbleToDeck() and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) end
		if tg then
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	end
end
function cm.sop(checks,op)
	return function(e,tp,...)
		if not cm.scon(checks)(e,tp) then return end
		op(e,tp,...)
	end
end
function rsufo.ToDeck(e,isbreak)
	local c=rscf.GetSelf(e)
	return c and (not isbreak or aux.TRUE(Duel.BreakEffect())) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>0 and c:IsLocation(LOCATION_DECK)
end
------------------------
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	local e1=rsef.ACT(c,nil,nil,nil,"td,se,th",nil,nil,nil,rsop.target({Card.IsAbleToDeck,"td",LOCATION_HAND,0,1,1,c},{cm.thfilter,"th",LOCATION_DECK }),cm.act)
	local e2=rsef.FC(c,EVENT_CHAIN_SOLVING,nil,nil,"cd,uc",LOCATION_SZONE,cm.wincon,cm.winop)
end
function cm.thfilter(c)
	return rsufo.IsSetM(c) and c:IsAbleToHand()
end
function cm.act(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local ct,og,tc=rsop.SelectToDeck(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,c,{})
	if tc and tc:IsLocation(LOCATION_DECK) then
		rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	end
end
function cm.wincon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=rsufo.code[re]
	if code and c:GetFlagEffect(code)==0 then
		rshint.Card(code)
		c:RegisterFlagEffect(code,rsreset.est,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,0))
	end
	for code=25000121,25000132 do
		if c:GetFlagEffect(code)<=0 then return end 
	end
	Duel.Win(tp,0x4)
end
