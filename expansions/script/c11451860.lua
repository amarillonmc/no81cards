--魔导飞行队巡逻指令
local cm,m=GetID()
function cm.initial_effect(c)
	if not PNFL_PROPHECY_FLIGHT_CHECK then
		dofile("expansions/script/c11451851.lua")
		pnfl_prophecy_flight_initial(c)
	end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_HAND)
	e1:SetOperation(cm.dsop)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		cm.column=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not re:IsHasCategory(CATEGORY_COIN) then return end
	local se=rc:RegisterFlagEffect(m,RESET_PHASE+PHASE_END,0,2)
	se:SetLabelObject(re)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetLabel(ev)
	e2:SetReset(RESET_CHAIN)
	e2:SetOperation(cm.resetop)
	Duel.RegisterEffect(e2,0)
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
	if ev==e:GetLabel() then re:GetHandler():ResetFlagEffect(m) end
end
function cm.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:GetHandler():IsSetCard(0x6e) or not c:IsSSetable() or cm.column~=0 then return end
	if Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.SSet(tp,c,tp,true)
		cm.thop(e,tp,eg,ep,ev,re,r,rp)
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fd=Duel.SelectField(tp,2,LOCATION_SZONE,0,~0x1f00)
	for i=0,4 do
		if fd&(1<<(8+i))>0 then
			local fd1=1<<(8+i)
			Duel.Hint(HINT_ZONE,tp,fd1)
			local fd2=fd
			if fd>=1<<16 then fd2=fd1>>16 else fd2=fd1<<16 end
			Duel.Hint(HINT_ZONE,1-tp,fd2)
			local cid=i+1
			if tp==1 then cid=5-i end
			cm.column=cm.column|(1<<cid)
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(m,i))
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e3:SetCode(EVENT_MOVE)
			e3:SetLabel(i)
			e3:SetCountLimit(1)
			e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
			e3:SetCondition(cm.thcon2)
			e3:SetCost(cm.thtg2)
			e3:SetOperation(cm.thop2)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function cm.clfilter(c,tp,i)
	return aux.GetColumn(c,tp)==i
end
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local ng=Duel.GetMatchingGroup(cm.clfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,e:GetLabel())
	local res=#Group.__band(ng,eg)>0
	local i=e:GetLabel()
	local cid=i+1
	if tp==1 then cid=5-i end
	cm.column=cm.column&~(1<<cid)
	return res
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return true end
	local ng=Duel.GetMatchingGroup(cm.clfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,e:GetLabel())
	local ag=ng:Filter(Card.IsCanBeEffectTarget,e)
	if #ag>0 then Duel.SetTargetCard(ag) end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g or #g==0 then return end
	g:KeepAlive()
	g:ForEach(Card.RegisterFlagEffect,m-10,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,aux.Stringid(m,10))
	for tc in aux.Next(g) do
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_SINGLE)
		ge2:SetCode(EFFECT_IMMUNE_EFFECT)
		ge2:SetRange(0x1c)
		ge2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		ge2:SetLabelObject(g)
		ge2:SetValue(cm.chkval)
		ge2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc:RegisterEffect(ge2,true)
	end
end
function cm.shfilter(c)
	return c:GetFlagEffect(m)>0
end
function cm.chkval(e,te)
	if e:GetHandler():GetFlagEffect(m-10)>0 and te and te:GetHandler() and not te:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) then
		local tp=e:GetOwnerPlayer()
		local g=e:GetLabelObject()
		g:ForEach(Card.ResetFlagEffect,m-10)
		local e3=Effect.CreateEffect(e:GetOwner())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_ADJUST)
		e3:SetOperation(cm.tdop)
		Duel.RegisterEffect(e3,tp)
	end
	return false
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local sg=Duel.GetMatchingGroup(cm.shfilter,tp,0xff,0xff,nil)
	if #sg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,5))
	local tc=sg:Select(tp,1,1,nil):GetFirst()
	local te=tc:IsHasEffect(EFFECT_FLAG_EFFECT+m):GetLabelObject()
	local op=te:GetOperation()
	op(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
end