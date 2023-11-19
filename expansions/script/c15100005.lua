--转生王女之祈愿
function c15100005.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,15100005)
	e1:SetOperation(c15100005.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15100005,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,15200005)
	e2:SetCondition(c15100005.thcon)
	e2:SetTarget(c15100005.thtg)
	e2:SetOperation(c15100005.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c15100005.chainop)
	c:RegisterEffect(e3)
end
function c15100005.thfilter1(c)
	return c:IsSetCard(0x510) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c15100005.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c15100005.thfilter1,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(15100005,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tg=Duel.SelectMatchingCard(tp,c15100005.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if tg:GetCount()<=0 then return end
		local tc=tg:GetFirst()
		if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
function c15100005.cfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_FUSION)
		and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c15100005.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c15100005.cfilter,1,nil,tp)
end
function c15100005.thfilter(c,eg)
	local tc=eg:GetFirst()
	local tg=nil
	while tc do
		if tc:IsSummonType(SUMMON_TYPE_FUSION) and c:GetReasonCard()==tc then
			tg=tc
		end
		tc=eg:GetNext()
	end
	return tg and c:IsAbleToHand() and c:GetReason()&(REASON_FUSION+REASON_MATERIAL)==(REASON_FUSION+REASON_MATERIAL) and c:IsLocation(LOCATION_GRAVE)
end
function c15100005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg and Duel.IsExistingMatchingCard(c15100005.thfilter,tp,LOCATION_GRAVE,0,1,nil,eg) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c15100005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c15100005.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,eg)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c15100005.chainop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and re:IsHasCategory(CATEGORY_FUSION_SUMMON) then
		Duel.SetChainLimit(c15100005.chainlm)
	end
end
function c15100005.chainlm(e,rp,tp)
	return tp==rp
end