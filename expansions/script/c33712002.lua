local m=33712002
local cm=_G["c"..m]
cm.name="俊达萌"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Recover(tp,3000,REASON_EFFECT)
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		if Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD,0,c)==0 then
			local op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2))
			if op==0 then
				Duel.BreakEffect()
				Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)
			elseif op==1 then
				Duel.BreakEffect()
				Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
			end
		end
	end
end