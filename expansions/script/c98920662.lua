--星圣·三裂星云
function c98920662.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_LIGHT),2,3)
	c:EnableReviveLimit()
	 --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920662,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98930662)
	e2:SetCost(c98920662.spcost)
	e2:SetTarget(c98920662.sptg)
	e2:SetOperation(c98920662.spop)
	c:RegisterEffect(e2)
	--todh
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920662,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,98920662)
	e3:SetTarget(c98920662.thtg)
	e3:SetOperation(c98920662.thop)
	c:RegisterEffect(e3)
	 --remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920662,1))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98920662.rcon)
	e2:SetOperation(c98920662.rop)
	c:RegisterEffect(e2)
end
function c98920662.thfilter(c)
	return c:IsSetCard(0x53) and c:IsAbleToHand()
end
function c98920662.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c98920662.thfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c98920662.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
end
function c98920662.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==2 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function c98920662.ccfilter(c,g)
	return g:IsContains(c)
end
function c98920662.spfilter(c,e,tp,mc)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x53) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c98920662.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c98920662.ccfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c98920662.ccfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function c98920662.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920662.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920662.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920662.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
	local tc=g:GetFirst()
	if tc then
	   Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98920662.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsSetCard(0x53)
		and ep==e:GetOwnerPlayer() and re:GetActivateLocation()&LOCATION_MZONE~=0 and bit.extract(re:GetHandler():GetLinkedZone(tp),e:GetHandler():GetPreviousSequence())
end
function c98920662.rop(e,tp,eg,ep,ev,re,r,rp)
	return ev
end