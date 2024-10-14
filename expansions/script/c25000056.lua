--绮亚罗
function c25000056.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCountLimit(1,25000056+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c25000056.spcon)
	e1:SetOperation(c25000056.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c25000056.thcon)
	e2:SetTarget(c25000056.thtg)
	e2:SetOperation(c25000056.thop)
	c:RegisterEffect(e2)
end
function c25000056.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(nil,c:GetControler(),LOCATION_HAND,0,1,e:GetHandler())
end
function c25000056.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,#g,e:GetHandler())
	Duel.SendtoHand(sg,1-tp,REASON_COST)
end
function c25000056.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c25000056.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c25000056.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local check=false
	if ct1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,0,ct1,ct1,nil)
		if #g1>0 then
			Duel.HintSelection(g1)
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			if og:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)>0 then
				check=true
			end
		end
	end
	if ct2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToHand,1-tp,LOCATION_MZONE,0,ct2,ct2,nil)
		if #g2>0 then
			Duel.HintSelection(g2)
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
		end
	end
	if check then
		Duel.BreakEffect()
		local ph=Duel.GetCurrentPhase()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		if Duel.GetTurnPlayer()~=tp and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c25000056.skipcon)
			e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c25000056.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
