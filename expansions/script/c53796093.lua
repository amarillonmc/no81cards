local m=53796093
local cm=_G["c"..m]
cm.name="天国蓝"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:GetPreviousControler()==tp
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	if ec:GetPreviousControler()~=tp or Duel.GetAttacker():IsControler(tp) then return false end
	e:SetLabel(ec:GetPreviousRaceOnField())
	return true
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,0,0,1,e:GetLabel(),ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,0,0,1,e:GetLabel(),ATTRIBUTE_EARTH) then return end
	c:AddMonsterAttribute(TYPE_EFFECT)
	Duel.SpecialSummonStep(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
	Duel.SpecialSummonComplete()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function cm.spfilter(c,e,tp,rac)
	if not (c:IsRace(rac) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)) then return false end
	if c:IsLocation(LOCATION_DECK) then
		return Duel.GetMZoneCount(tp,rc)>0
	else
		return Duel.GetLocationCountFromEx(tp,tp,rc,c)>0
	end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local rac=c:GetRace()
	if Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_REMOVED) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,rac)
		if #g>0 then Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP) end
	end
end
