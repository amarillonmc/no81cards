--闪耀的棱镜之歌 星之声
function c28327394.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,28327394+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c28327394.decon)
	e1:SetCost(c28327394.decost)
	e1:SetTarget(c28327394.detg)
	e1:SetOperation(c28327394.deop)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,28327394)
	e2:SetCondition(c28327394.thcon)
	e2:SetTarget(c28327394.thtg)
	e2:SetOperation(c28327394.thop)
	c:RegisterEffect(e2)
end
function c28327394.decon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c28327394.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c28327394.cfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c28327394.detg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c28327394.cfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	e:SetLabel(0)
	local ct=Duel.GetMatchingGroupCount(c28327394.cfilter,tp,LOCATION_HAND,0,nil)
	if ct>Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD) then ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c28327394.cfilter,tp,LOCATION_HAND,0,1,ct,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,g:GetCount(),g:GetCount(),nil)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,tg:GetCount(),0,0)
end
function c28327394.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER)
end
function c28327394.deop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c28327394.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(28327394,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c28327394.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()==1 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
	end
end
function c28327394.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_RETURN)==0 and bit.band(r,REASON_EFFECT)~=0
end
function c28327394.filter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28327394.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c28327394.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c28327394.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c28327394.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c28327394.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
