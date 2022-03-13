--蛰伏于深层幻夜的月神
function c64800126.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_FIEND),1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64800126,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,64810126)
	e1:SetTarget(c64800126.target)
	e1:SetOperation(c64800126.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64800126,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,64800126)
	e2:SetCondition(c64800126.con)
	e2:SetTarget(c64800126.edtg)
	e2:SetOperation(c64800126.edop)
	c:RegisterEffect(e2)
end

--e1
function c64800126.spfilter(c)
	return c:IsSetCard(0x341a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c64800126.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c64800126.operation(e,tp,eg,ep,ev,re,r,rp)
	local hc=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,e:GetHandler())
	if hc:GetCount()>=1 then 
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	else
		--disable search
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_TO_HAND)
		e3:SetRange(LOCATION_MZONE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(0,1)
		e3:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e3)
		e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(64800126,2))
	end
end

--e2
function c64800126.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c64800126.thfilter(c)
	local ce=c:GetReasonEffect()
		return c:IsAbleToHand() and ce and ce:GetHandler():IsSetCard(0x341a)
end
function c64800126.edtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64800126.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c64800126.thfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c64800126.edop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c64800126.thfilter,tp,LOCATION_GRAVE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c64800126.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end