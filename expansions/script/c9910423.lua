--赛博空间蓝图
function c9910423.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,9910423)
	e2:SetCost(c9910423.spcost)
	e2:SetTarget(c9910423.sptg)
	e2:SetOperation(c9910423.spop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9910423,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,9910424)
	e3:SetCondition(c9910423.thcon)
	e3:SetTarget(c9910423.thtg)
	e3:SetOperation(c9910423.thop)
	c:RegisterEffect(e3)
end
function c9910423.rfilter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsFaceup() and lv>0 and c:IsRace(RACE_CYBERSE) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c9910423.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,lv+3,e,tp)
end
function c9910423.spfilter(c,lv,e,tp)
	return c:IsLevelBelow(lv) and c:IsSetCard(0x6950) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910423.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c9910423.rfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c9910423.rfilter,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetLevel()+3)
	Duel.Release(g,REASON_COST)
end
function c9910423.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9910423.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c9910423.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e:GetLabel(),e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) and tc:IsPreviousLocation(LOCATION_HAND) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c9910423.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function c9910423.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c9910423.cfilter(c,tp,rp)
	return rp==1-tp and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsSetCard(0x6950)
end
function c9910423.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910423.cfilter,1,nil,tp,rp)
end
function c9910423.thfilter(c)
	return c:IsSetCard(0x6950) and c:IsAbleToHand()
end
function c9910423.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910423.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910423.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910423.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
