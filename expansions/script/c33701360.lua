--全灵的一扫(WIP)
local m=33701360
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function cm.filter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsPreviousLocation(LOCATION_EXTRA) and Duel.IsPlayerCanSendtoGrave(c:GetControler(),c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local p=tc:GetControler()
	local t1=false
	local t2=Duel.IsPlayerCanSendtoGrave(p,tc)
	if t1 or t2 then
		local m={}
		local n={}
		local ct=1
		if t1 then m[ct]=aux.Stringid(m,1) n[ct]=1 ct=ct+1 end
		if t2 then m[ct]=aux.Stringid(m,2) n[ct]=2 ct=ct+1 end
		local sp=Duel.SelectOption(p,table.unpack(m))
		op=n[sp+1]
	end
	if op==1 then
	elseif op==2 then
		Duel.SendtoGrave(tc,REASON_RULE)
	end
end
