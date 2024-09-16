--熙熙攘攘，我们的城市
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return true end cm.operation0(e,tp,eg,ep,ev,re,r,rp) end)
	e0:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return true end Duel.SetChainLimit(aux.FALSE) end)
	c:RegisterEffect(e0)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_ADJUST)
	e10:SetRange(LOCATION_FZONE)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetCondition(cm.condition0)
	e10:SetOperation(cm.operation0)
	--c:RegisterEffect(e10)
	--cannot be destroyed
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--cannot set/activate
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_SSET)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(1,0)
	e8:SetTarget(cm.setlimit)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetRange(LOCATION_FZONE)
	e9:SetTargetRange(1,0)
	e9:SetValue(cm.actlimit)
	c:RegisterEffect(e9)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_HAND+LOCATION_FZONE)
	e3:SetCondition(cm.discon)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
	--mark
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(cm.adjustop)
	c:RegisterEffect(e2)
end
function cm.ngfilter(c)
	return c:GetFlagEffect(m)>0
end
function cm.condition0(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)==0
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then Duel.SendtoGrave(c,REASON_RULE) end
end
function cm.operation0(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,2))
	local c=e:GetHandler()
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(cm.tgop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,3)
	c:SetTurnCounter(0)
	c:RegisterEffect(e1)
	cm[c]=e1
end
function cm.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function cm.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0) then
		local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft1<=0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft1=1 end
		local g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil,e,tp)
		if #g1>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			g1=g1:Select(tp,ft1,ft1,nil)
		end
		for tc in aux.Next(g1) do Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) end
		local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		if ft2<=0 then return end
		if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ft2=1 end
		local g2=Duel.GetMatchingGroup(cm.filter,1-tp,LOCATION_HAND,0,nil,e,1-tp)
		if #g2>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			g2=g2:Select(1-tp,ft1,ft1,nil)
		end
		for tc in aux.Next(g2) do Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP) end
		if #(g1+g2)>0 then Duel.SpecialSummonComplete() Duel.Readjust() end
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,ct,p,loc=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	local g=Duel.GetFieldGroup(rp,LOCATION_HAND,0)
	if not ex or #g==0 or (rp==tp and g:FilterCount(cm.filter,nil,e,tp)==0) then return false end
	if aux.GetValueType(tg)=="Card" and tg:IsLocation(LOCATION_HAND) then return true end
	if aux.GetValueType(tg)=="Group" and tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)>0 then return true end
	if loc&LOCATION_HAND>0 then return true end
	return false
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		local ft1=Duel.GetLocationCount(rp,LOCATION_MZONE)
		if ft1<=0 then return end
		if Duel.IsPlayerAffectedByEffect(rp,59822133) then ft1=1 end
		local g1=Duel.GetMatchingGroup(cm.filter,rp,LOCATION_HAND,0,nil,e,rp)
		if #g1>0 then
			Duel.Hint(HINT_SELECTMSG,rp,HINTMSG_SPSUMMON)
			g1=g1:Select(rp,ft1,ft1,nil)
		end
		for tc in aux.Next(g1) do Duel.SpecialSummonStep(tc,0,rp,rp,false,false,POS_FACEUP) end
		Duel.SpecialSummonComplete()
	end
end