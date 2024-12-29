--行进之魔棋阵
function c51931008.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--search and to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,51931008)
	e1:SetTarget(c51931008.thtg)
	e1:SetOperation(c51931008.thop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,51931009)
	e2:SetCost(c51931008.setcost)
	e2:SetTarget(c51931008.settg)
	e2:SetOperation(c51931008.setop)
	c:RegisterEffect(e2)
end
function c51931008.tfilter(c,tp)
	return c:IsSetCard(0x6258) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c51931008.tgfilter,tp,LOCATION_DECK,0,1,nil,c:GetType())
end
function c51931008.tgfilter(c,type)
	return c:IsSetCard(0x6258) and c:IsAbleToGraveAsCost() and not c:IsType(type&0x7)
end
function c51931008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c51931008.tfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c51931008.tfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c51931008.thfilter(c,tc,gc)
	return c:IsSetCard(0x6258) and not c:IsType(tc&0x7) and not c:IsType(gc&0x7) and c:IsAbleToHand()
end
function c51931008.thop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c51931008.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--operation
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local gc=Duel.SelectMatchingCard(tp,c51931008.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetType()):GetFirst()
	if gc and Duel.SendtoGrave(gc,REASON_EFFECT)~=0 and gc:IsLocation(LOCATION_GRAVE)
		and Duel.IsExistingMatchingCard(c51931008.thfilter,tp,LOCATION_DECK,0,1,nil,tc:GetType(),gc:GetType())
		and Duel.SelectEffectYesNo(tp,aux.Stringid(51931008,0)) then
		Duel.BreakEffect()
		local tg=Duel.SelectMatchingCard(tp,c51931008.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetType(),gc:GetType())
		Duel.SendtoHand(tg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c51931008.splimit(e,c)
	return not c:IsLevelAbove(1) and c:IsLocation(LOCATION_EXTRA)
end
function c51931008.rmfilter(c)
	return c:IsSetCard(0x6258) and c:IsAbleToRemoveAsCost()
end
function c51931008.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51931008.rmfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c51931008.rmfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	sg:AddCard(e:GetHandler())
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c51931008.setfilter(c,tp)
	return c:IsSetCard(0x6258) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c51931008.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c51931008.setfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c51931008.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c51931008.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
