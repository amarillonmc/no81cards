--卡片读取士
--21.07.08
local m=11451550
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(cm.actarget)
	e2:SetOperation(cm.checkop)
	c:RegisterEffect(e2)
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return e:GetHandler():GetFlagEffect(m-1)==0
end
function cm.hook(f,args)
	return function(...)
				debug.sethook(function()
								local fun=debug.getinfo(2).name
								if fun=="IsCodeListed" or fun=="IsMaterialListCode" then
									for i=1,20 do
										local _,v=debug.getlocal(2,i)
										if type(v)=="number" then
											for _,eid in pairs(args) do
												if not cm[eid] or type(cm[eid])~="table" then cm[eid]={} end
												table.insert(cm[eid],v)
											end
										end
									end
								else
									local res=false
									for i=1,20 do
										local _,v=debug.getlocal(2,i)
										if v==aux.IsCodeListed or v==aux.IsMaterialListCode then res=true end
									end
									if res==false then return false end
									for i=1,20 do
										local _,v=debug.getlocal(2,i)
										if type(v)=="number" then
											for _,eid in pairs(args) do
												if not cm[eid] or type(cm[eid])~="table" then cm[eid]={} end
												table.insert(cm[eid],v)
											end
										end
									end
								end
							  end,"c")
				f(...)
			end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local eid=Duel.GetCurrentChain()+1
	if not cm[te] or type(cm[te])~="table" then
		local con=te:GetCondition() or 0
		local cost=te:GetCost() or 0
		local tg=te:GetTarget() or 0
		local op=te:GetOperation() or 0
		cm[te]={con,cost,tg,op,eid}
		if con~=0 then te:SetCondition(cm.hook(con,{eid})) end
		if cost~=0 then te:SetCost(cm.hook(cost,{eid})) end
		if tg~=0 then te:SetTarget(cm.hook(tg,{eid})) end
		if op~=0 then te:SetOperation(cm.hook(op,{eid})) end
	else
		table.insert(cm[te],eid)
		local args={}
		for i=5,#cm[te] do table.insert(args,cm[te][i]) end
		if cm[te][1]~=0 then te:SetCondition(cm.hook(cm[te][1],args)) end
		if cm[te][2]~=0 then te:SetCost(cm.hook(cm[te][2],args)) end
		if cm[te][3]~=0 then te:SetTarget(cm.hook(cm[te][3],args)) end
		if cm[te][4]~=0 then te:SetOperation(cm.hook(cm[te][4],args)) end
	end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabel(eid)
	e1:SetLabelObject(te)
	e1:SetCondition(cm.rscon)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,e:GetHandlerPlayer())
	local e2=e1:Clone()
	e2:SetCondition(cm.rscon2)
	e2:SetOperation(cm.rsop2)
	Duel.RegisterEffect(e2,e:GetHandlerPlayer())
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject() and Duel.GetCurrentChain()==e:GetLabel()
end
function cm.thfilter(c,list)
	if not list or type(list)~="table" then return false end
	for _,code in pairs(list) do
		if type(code)=="number" and c:IsCode(code) then return true end
	end
	return false
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local eid=Duel.GetCurrentChain()
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,cm[eid])
	Debug.Message(#g>0)
	if e:GetHandler():GetFlagEffect(m)~=0 and e:GetHandler():GetFlagEffect(m-1)==0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		e:GetHandler():RegisterFlagEffect(m-1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
	cm[eid]=0
end
function cm.rscon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.rsop2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not cm[te] or type(cm[te])~="table" then return end
	if cm[te][1]~=0 then te:SetCondition(cm[te][1]) end
	if cm[te][2]~=0 then te:SetCost(cm[te][2]) end
	if cm[te][3]~=0 then te:SetTarget(cm[te][3]) end
	if cm[te][4]~=0 then te:SetOperation(cm[te][4]) end
	cm[te]=0
end