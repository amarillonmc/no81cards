--卡西米尔-荣光竞技场
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition2)
	e1:SetOperation(cm.activate2)
	c:RegisterEffect(e1)
	
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
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return SpaceCheck[tp]==true
end
function cm.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) and Duel.IsPlayerCanDraw(tp,1) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) and #g~=0 then
		if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT,nil)~=0 then
			if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				if g:GetCount()>0 then
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
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
	return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c:GetOriginalRace(),c:GetOriginalAttribute()) and not c:IsPublic()
end
function cm.spfilter(c,e,tp,race,att)
	return bit.band(race,c:GetOriginalRace())==0 and bit.band(att,c:GetOriginalAttribute())==0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
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
	local ag=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp,tc:GetOriginalRace(),tc:GetOriginalAttribute())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,ag,1,tp,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject():GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local ag=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetOriginalRace(),tc:GetOriginalAttribute())
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