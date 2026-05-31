--天工之折纸使
function c9910023.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c9910023.lcheck)
	c:EnableReviveLimit()
	--sort
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c9910023.stcon)
	e1:SetTarget(c9910023.sttg)
	e1:SetOperation(c9910023.stop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c9910023.tdtg)
	e2:SetOperation(c9910023.tdop)
	c:RegisterEffect(e2)
end
function c9910023.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3950)
end
function c9910023.stcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9910023.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 or Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=3 end
end
function c9910023.stop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3
	local b2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=3
	if not b1 and not b2 then return end
	local op=nil
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(9910023,0),aux.Stringid(9910023,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(9910023,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9910023,1))+1
	end
	local p=op==0 and tp or 1-tp
	Duel.SortDecktop(tp,p,3)
end
function c9910023.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9910023.tdfilter(c,tp)
	local b1=c:IsAbleToDeck()
	local b2=c:IsCanOverlay() and Duel.IsExistingMatchingCard(c9910023.xfilter,tp,LOCATION_MZONE,0,1,nil)
	return c:IsFaceup() and c:IsSetCard(0x3950,0x5950) and (b1 or b2)
end
function c9910023.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c9910023.tdfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9910023.tdfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9910023.tdfilter,tp,LOCATION_REMOVED,0,2,2,nil)
end
function c9910023.locfilter(c,sp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(sp)
end
function c9910023.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	if #tg~=2 then return end
	local b1=tg:FilterCount(Card.IsAbleToDeck,nil)==2
	local b2=tg:FilterCount(Card.IsCanOverlay,nil)==2 and Duel.IsExistingMatchingCard(c9910023.xfilter,tp,LOCATION_MZONE,0,1,nil)
	if not (b1 or b2) then return end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(9910023,2),1},{b2,aux.Stringid(9910023,3),2})
	if op==1 then
		aux.PlaceCardsOnDeckBottom(tp,tg)
		if not Duel.GetOperatedGroup():IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then return end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local xg=Duel.SelectMatchingCard(tp,c9910023.xfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(xg)
		if xg:GetFirst():IsImmuneToEffect(e) then return end
		Duel.Overlay(xg:GetFirst(),tg)
	end
	if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(9910023,4)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
