local m=15005109
local cm=_G["c"..m]
cm.name="断空鹰刃-天市左垣六ζ"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.psplimit)
	c:RegisterEffect(e1)
	--toextra
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,15005109)
	e2:SetCondition(cm.tecon)
	e2:SetTarget(cm.tetg)
	e2:SetOperation(cm.teop)
	c:RegisterEffect(e2)
	--Equip
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetCountLimit(1,15005110)
	e3:SetCondition(cm.eqcon)
	e3:SetTarget(cm.eqtg)
	e3:SetOperation(cm.eqop)
	c:RegisterEffect(e3)
end
function cm.splimit(e,se,sp,st)
	return se:GetHandler():IsType(TYPE_EQUIP) or (e:GetHandler():IsLocation(LOCATION_EXTRA) and st&SUMMON_TYPE_PENDULUM==SUMMON_TYPE_PENDULUM)
end
function cm.psplimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x6f3f) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function cm.tecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsType),tp,LOCATION_SZONE,0,1,nil,TYPE_EQUIP)
end
function cm.tefilter(c)
	return c:IsSetCard(0x6f3f) and c:IsType(TYPE_MONSTER) and c:IsAbleToExtra()
end
function cm.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function cm.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and e:GetHandler():GetEquipCount()==0
end
function cm.eqfilter(c,tp)
	return c:IsSetCard(0x6f3f) and c:IsFaceup() and c:CheckUniqueOnField(tp)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.eqfilter,tp,LOCATION_EXTRA,0,nil,tp)
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_SZONE)),2)
	if chk==0 then return ft>0
		and g:GetCount()>0 and g:CheckSubGroup(cm.eqgcheck,1,2) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function cm.eqgcheck(g)
	return g:CheckWithSumEqual(Card.GetLevel,6,#g,#g) and aux.dncheck(g)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.eqfilter,tp,LOCATION_EXTRA,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=g:SelectSubGroup(tp,cm.eqgcheck,false,1,2)
	if sg and sg:GetCount()>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if ft<sg:GetCount() then return end
		local tc=sg:GetFirst()
		while tc do
			Duel.Equip(tp,tc,c,false,true)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetValue(cm.eqlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc=sg:GetNext()
		end
		Duel.EquipComplete()
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end