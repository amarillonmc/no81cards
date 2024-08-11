--布洛妮娅-存护之志-
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x629,LOCATION_ONFIELD)
	c:SetUniqueOnField(1,0,m)
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(50,m)
	e1:SetOperation(cm.cgop)
	c:RegisterEffect(e1)
end
if not cm.cnum then
	cm.cnum=0
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message(cm.cnum)
	local c=e:GetHandler()
	local i=c:GetControler()
	--Debug.Message(Duel.GetCounter(i,LOCATION_ONFIELD,0,0x629)-c:GetCounter(0x629))
	local nnum=Duel.GetCounter(i,LOCATION_ONFIELD,0,0x629)-c:GetCounter(0x629)
	if cm.cnum~=nnum then
		cm.cnum=nnum
		Duel.RaiseEvent(c,EVENT_CUSTOM+m,nil,0,i,i,0)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsCanRemoveCounter(tp,1,0,0x629,1,REASON_EFFECT)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		c:AddCounter(0x629,1)
	end
end
function cm.cgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local i=1
	if Duel.IsPlayerAffectedByEffect(tp,m+1) then
		i=2
	end
	e:GetHandler():AddCounter(0x629,i)
end