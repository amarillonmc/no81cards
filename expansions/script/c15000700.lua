local m=15000700
local cm=_G["c"..m]
cm.name="环下的故事"
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.condition)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function cm.atkfilter(c)
	return c:IsFaceup() and c:GetRace()~=0
end
function cm.atkval(e,c)
	local g=Duel.GetMatchingGroup(cm.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)
	local att=0
	local tc=g:GetFirst()
	while tc do
		att=bit.bor(att,tc:GetRace())
		tc=g:GetNext()
	end
	local ct=0
	while att~=0 do
		if bit.band(att,0x1)~=0 then ct=ct+1 end
		att=bit.rshift(att,1)
	end
	return ct*200
end
function cm.sp1filter(c,race,att)
	return c:IsFaceup() and (bit.band(race,c:GetOriginalRace())~=0 or bit.band(att,c:GetOriginalAttribute())~=0)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,eg)
	local ac=eg:GetFirst()
	local bg=Group.CreateGroup()
	while ac do
		if not Duel.IsExistingMatchingCard(cm.sp1filter,tp,LOCATION_MZONE,0,1,eg,ac:GetOriginalRace(),ac:GetOriginalAttribute()) then bg:AddCard(ac) end
		ac=eg:GetNext()
	end
	return ag:GetCount()~=0 and bg:GetCount()~=0
end
function cm.lookfilter(c,e,tp)
	return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,c:GetOriginalRace(),c:GetOriginalAttribute()) and not c:IsPublic()
end
function cm.spfilter(c,e,tp,race,att)
	return c:IsSetCard(0x3f38) and bit.band(race,c:GetOriginalRace())==0 and bit.band(att,c:GetOriginalAttribute())==0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.lookfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.lookfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	g:KeepAlive()
	e:SetLabelObject(g)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleExtra(tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 end
	local tc=e:GetLabelObject():GetFirst()
	local ag=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,tc:GetOriginalRace(),tc:GetOriginalAttribute())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,ag,1,tp,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject():GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local ag=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetOriginalRace(),tc:GetOriginalAttribute())
		if ag:GetCount()~=0 then
			Duel.SpecialSummon(ag,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return Duel.IsExistingMatchingCard(cm.sp1filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,c:GetOriginalRace(),c:GetOriginalAttribute())
end