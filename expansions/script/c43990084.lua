--噬梦的浊流
local m=43990084
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c43990084.ffilter,3,99,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c43990084.tgcon)
	e1:SetOperation(c43990084.tgop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,43990084)
	e2:SetCondition(c43990084.descon)
	e2:SetTarget(c43990084.destg)
	e2:SetOperation(c43990084.desop)
	c:RegisterEffect(e2)
	
end
function c43990084.descon(e,tp,eg,ep,ev,re,r,rp)
	local race=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE)
	return re:IsActiveType(TYPE_MONSTER) and race&RACE_ILLUSION>0
end
function c43990084.ffilter(c,fc)
	return c:IsRace(RACE_ILLUSION)
end
function c43990084.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c43990084.tgop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetValue(RACE_ILLUSION)
	if Duel.GetTurnPlayer()~=tp then 
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	else
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2) end
	Duel.RegisterEffect(e1,tp)
end
function c43990084.spfilter(c,e,tp)
	return c:IsRace(RACE_ILLUSION) and c:IsType(TYPE_MONSTER) and ((not c:IsLocation(LOCATION_DECK) and c:IsAbleToDeck()) or (not c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not c:IsLocation(LOCATION_DECK) or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1)))
end
function c43990084.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and eg:FilterCount(c43990084.spfilter,e,tp)>0 end
	Duel.SetTargetCard(eg:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c43990084.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
		if not tc:IsRelateToEffect(e) or aux.NecroValleyNegateCheck(tc) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not tc:IsAbleToDeck() or Duel.SelectOption(tp,aux.Stringid(43990084,2),1152)==1) then
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and tc:IsLocation(LOCATION_MZONE) then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		else
			if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK) then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
end