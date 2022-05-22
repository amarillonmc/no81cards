--炎爆战斗狂
function c9910907.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon/destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9910907)
	e1:SetCondition(c9910907.spcon)
	e1:SetTarget(c9910907.sptg)
	e1:SetOperation(c9910907.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910907,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,9910908)
	e2:SetCondition(c9910907.thcon)
	e2:SetCost(c9910907.thcost)
	e2:SetTarget(c9910907.thtg)
	e2:SetOperation(c9910907.thop)
	c:RegisterEffect(e2)
end
function c9910907.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c9910907.spfilter(c,e,tp)
	return c:IsCode(9910907) and Duel.GetMZoneCount(tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910907.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c9910907.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	local g1=Duel.GetMatchingGroup(c9910907.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	local off=1
	local ops={}
	local opval={}
	if g1:GetCount()>0 then
		ops[off]=aux.Stringid(9910907,0)
		opval[off-1]=1
		off=off+1
	end
	if g2:GetCount()>0 then
		ops[off]=aux.Stringid(9910907,1)
		opval[off-1]=2
		off=off+1
	end
	ops[off]=aux.Stringid(9910907,2)
	opval[off-1]=3
	off=off+1
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g1:Select(tp,1,1,nil):GetFirst()
		local atk=tc:GetAttack()
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(math.ceil(atk*2))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
	elseif opval[op]==2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=g2:Select(tp,1,1,nil)
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c9910907.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
		and e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE)
end
function c9910907.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c9910907.thfilter(c,tp)
	local typ=TYPE_TUNER 
	if Duel.IsExistingMatchingCard(c9910907.cfilter,tp,LOCATION_MZONE,0,1,nil) then typ=typ+TYPE_PENDULUM end
	return aux.IsCodeListed(c,9910871) and c:IsType(typ) and c:IsAbleToHand()
end
function c9910907.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function c9910907.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910907.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910907.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910907.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
