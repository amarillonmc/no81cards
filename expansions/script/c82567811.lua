--方舟骑士·牧歌奏者 风笛
function c82567811.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c82567811.linkfilter),1,3)
	c:EnableReviveLimit()
	--link success
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c82567811.spcon)
	e1:SetTarget(c82567811.sptg)
	e1:SetOperation(c82567811.spop)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c82567811.ctcon)
	e2:SetOperation(c82567811.ctop)
	c:RegisterEffect(e2)
	--add counter2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c82567811.ctcon2)
	e3:SetOperation(c82567811.ctop2)
	c:RegisterEffect(e3)
	--Draw
	local e5=Effect.CreateEffect(c)
	
	e5:SetDescription(aux.Stringid(82567811,1))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,82567811)
	e5:SetCondition(c82567811.dwcon)
	e5:SetCost(c82567811.dwcost)
	e5:SetTarget(c82567811.dwtg)
	e5:SetOperation(c82567811.dwop)
	c:RegisterEffect(e5)
end
function c82567811.linkfilter(c)
	return c:IsSetCard(0x825)  
end
function c82567811.spfilter(c,e,tp)
	return c:IsSetCard(0x825) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c82567811.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and Duel.IsExistingMatchingCard(c82567811.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c82567811.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) and chkc:IsSetCard(0x825) and  chkc:IsLevelBelow(4) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c82567811.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c82567811.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if g:GetCount()>0 then
	local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	   if tc then local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	  end
	 end
end
function c82567811.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c82567811.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	 c:AddCounter(0x5825,1)
	end
function c82567811.ctfilter(c,tp,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsFaceup() and c:IsControler(tp) and ec:GetLinkedGroup():IsContains(c)
	else
		return  c:IsPreviousPosition(POS_FACEUP)
			and c:GetPreviousControler()==tp and bit.extract(ec:GetLinkedZone(tp),c:GetPreviousSequence())~=0
	end
end
function c82567811.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c82567811.ctfilter,1,nil,tp,e:GetHandler())
end
function c82567811.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	 c:AddCounter(0x5825,1)
	end
function c82567811.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82567811.thfilter(c)
	return c:IsSetCard(0x825) and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
	end
function c82567811.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567811.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c82567811.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82567811.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c82567811.cfilter(c,g)
	return g:IsContains(c) and c:IsSetCard(0x825)
end
function c82567811.dwcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetCounter(0x5825)>0 
end
function c82567811.dwcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c82567811.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c82567811.cfilter,1,1,nil,lg)
	Duel.SendtoHand(g,tp,1)
end
function c82567811.dwtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local dwc=c:GetCounter(0x5825)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,dwc) end
	
	Duel.SetTargetPlayer(tp)
	if dwc<3 then
	Duel.SetTargetParam(dwc)
	else 
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dwc)
end
end
function c82567811.dwop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end