--救世之旅-偏离的真相
function c16401580.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,16401580)
	e1:SetCondition(c16401580.condition)
	e1:SetTarget(c16401580.target)
	e1:SetOperation(c16401580.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16401580,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,16401580+1)
	e2:SetCondition(c16401580.rmcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c16401580.rmtg)
	e2:SetOperation(c16401580.rmop)
	c:RegisterEffect(e2)
end
function c16401580.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,e:GetHandler(),1-tp)
end
function c16401580.spfilter(c)
	return c:IsLinkSummonable(nil) and c:IsSetCard(0x5ce1)
end
function c16401580.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16401580.spfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c16401580.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c16401580.spfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,nil)
	end
end
function c16401580.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return aux.exccon(e) and Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c16401580.tfilter(c)
	return c:IsSetCard(0x6ce1) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c16401580.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c16401580.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16401580.tfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectTarget(tp,c16401580.tfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,1,0,0)
end
function c16401580.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(0x20) and atk>0 then
		Duel.BreakEffect()
		Duel.Recover(tp,atk,REASON_EFFECT)
	end
end
