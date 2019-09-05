--黑白视界·镜面
function c77771008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77771008)
	e1:SetTarget(c77771008.target)
	e1:SetOperation(c77771008.activate)
	c:RegisterEffect(e1)
	 --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,80007777)
	e2:SetCondition(c77771008.tdcon)	
	e2:SetTarget(c77771008.tdtg)
	e2:SetOperation(c77771008.tdop)
	c:RegisterEffect(e2)
end
function c77771008.filter(c)
	return c:IsSetCard(0x77a) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(77771008) and c:IsSSetable()
end
function c77771008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c77771008.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c77771008.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c77771008.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c77771008.tdfilter(c,tp)
	return c:IsSetCard(0x77a) and c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE) and not c:IsReason(REASON_DRAW)
end
function c77771008.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77771008.tdfilter,1,nil,tp) and aux.exccon(e)
end
function c77771008.thfilter(c)
	return c:IsSetCard(0x77a) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(77771008) and c:IsAbleToHand()
end
function c77771008.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c77771008.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>0 then
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c77771008.thfilter),tp,LOCATION_GRAVE,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(77771008,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

