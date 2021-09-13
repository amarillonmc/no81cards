--超越同调
local m=35300155
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.filter0(c,mlv)
	local mg=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	return c:IsFaceup() and c:IsLevelBelow(mlv-1) and c:IsType(TYPE_TUNER) and mg:CheckWithSumEqual(Card.GetLevel,mlv-c:GetLevel(),1,#mg) and c:IsAbleToDeck()
end
function cm.filter1(c)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER) and c:IsAbleToDeck() and c:IsLevelAbove(1)
end
function cm.filter2(c,e,tp)
	local mlv=c:GetLevel()
	local mg=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_MZONE,LOCATION_MZONE,nil,mlv)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c:IsRace(RACE_DRAGON)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and #mg>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp)
	local g=sg1:Select(tp,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	local tc=g:GetFirst()
	local mlv=tc:GetLevel()
	local mg=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_MZONE,LOCATION_MZONE,nil,mlv)
	local mc=mg:Select(tp,1,1,nil):GetFirst()
	local tg=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=tg:SelectWithSumEqual(tp,Card.GetLevel,mlv-mc:GetLevel(),1,#tg)
	sg:AddCard(mc)
	if tc and Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CHANGE_DAMAGE)
		e3:SetTargetRange(0,1)
		e3:SetValue(0)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
end