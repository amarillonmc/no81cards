--魔棋的黑兵卒
function c51931015.initial_effect(c)
	--activate cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_ACTIVATE_COST)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetRange(0xff)
	e0:SetTargetRange(1,1)
	e0:SetTarget(c51931015.actarget)
	e0:SetCost(c51931015.costchk)
	e0:SetOperation(c51931015.costop)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,51931015)
	e1:SetTarget(c51931015.sptg)
	e1:SetOperation(c51931015.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,51931015)
	e2:SetTarget(c51931015.thtg)
	e2:SetOperation(c51931015.thop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(51931015,ACTIVITY_SPSUMMON,c51931015.counterfilter)
end
function c51931015.counterfilter(c)
	return not (c:IsLevelAbove(1) and c:IsSummonLocation(LOCATION_EXTRA))
end
function c51931015.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler()
end
function c51931015.costchk(e,te_or_c,tp)
	return Duel.GetCustomActivityCount(51931015,tp,ACTIVITY_SPSUMMON)==0
end
function c51931015.costop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c51931015.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c51931015.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLevelAbove(1) and c:IsLocation(LOCATION_EXTRA)
end
function c51931015.tfilter(c,tp)
	local type1=c:GetType()&0x7
	return c:IsSetCard(0x6258) and c:IsFaceup() and Duel.IsExistingMatchingCard(c51931015.tgfilter,tp,LOCATION_DECK,0,1,nil,type1)
end
function c51931015.tgfilter(c,type1)
	return not c:IsType(type1) and c:IsSetCard(0x6258) and c:IsAbleToGrave()
end
function c51931015.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c51931015.tfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c51931015.tfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c51931015.tfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c51931015.spop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	local type1=tc:GetType()&0x7
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tgc=Duel.SelectMatchingCard(tp,c51931015.tgfilter,tp,LOCATION_DECK,0,1,1,nil,type1):GetFirst()
		if tgc and Duel.SendtoGrave(tgc,REASON_EFFECT)~=0 and tgc:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c51931015.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c51931015.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if tc then
		tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
