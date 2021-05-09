--死灵舞者·爱丽丝
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100101
local cm=_G["c"..m]
local code1=0x7d7 --死者
local code2=0x7d8 --死灵舞者
local code3=0x17d7 --行动力指示物
function cm.initial_effect(c)
	c:EnableCounterPermit(code3)
	--counter
	local e1=bm.b.ce(c,nil,CATEGORY_COUNTER,EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS,EVENT_SUMMON_SUCCESS,nil,nil,bm.b.con,bm.b.cost,bm.b.tar,function(e,tp,eg,ep,ev,re,r,rp) e:GetHandler():AddCounter(code3,7) end,nil)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--set 
	local e3=bm.b.ce(c,bm.hint.set,CATEGORY_COUNTER,EFFECT_TYPE_IGNITION,nil,{1,EFFECT_COUNT_CODE_SINGLE},mz,bm.b.con,cm.cost(3),cm.tar,cm.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_CUSTOM+71100104)
	c:RegisterEffect(e4)
end
function cm.cost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,code3,ct,REASON_COST) end
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		e:GetHandler():RemoveCounter(tp,code3,ct,REASON_COST)
	end
end
function cm.sf(c,e,tp)
	return bm.c.cpos(c,code1) and bm.c.go(c,sz,e,tp,bm.re.e) and not c:IsType(TYPE_FIELD)
end
function cm.f(c,e,tp)
	local seq=aux.MZoneSequence(c:GetSequence())
	return Duel.CheckLocation(tp,sz,seq) and bm.c.get(e,tp,cm.sf,dk,0,nil,e,tp):GetCount()>0 and bm.c.cpos(c,code2)
end
function cm.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bm.c.get(e,tp,cm.f,mz,0,nil,e,tp):GetCount()>0 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.secon)
	e1:SetOperation(cm.seop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.secon(e,tp,eg,ep,ev,re,r,rp)
	return bm.c.get(e,tp,cm.f,mz,0,nil,e,tp):GetCount()>0
end
function cm.seop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local tg=bm.c.get(e,tp,cm.f,mz,0,nil,e,tp)
	local sg=bm.c.get(e,tp,cm.sf,dk,0,nil,e,tp)
	if tg:GetCount()<0 or tg:GetCount()<0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=sg:Select(tp,1,1,nil):GetFirst()
	if sc then
		local seq=tg:GetSum(Card.GetColumnZone,sz)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		seq=Duel.SelectField(tp,1,sz,0,~seq)>>8
		Duel.MoveToField(sc,tp,tp,sz,POS_FACEUP,false,seq)
		Duel.ChangePosition(sc,POS_FACEDOWN)
		Duel.RaiseEvent(sc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		Duel.ConfirmCards(1-tp,sc)
	end
end



																		 


