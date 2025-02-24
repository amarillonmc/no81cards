--坠落之春 鹿乃
function c75646421.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x32c4),3)
	c:EnableReviveLimit()
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c75646421.cost)
	e1:SetTarget(c75646421.tg)
	e1:SetOperation(c75646421.op)
	c:RegisterEffect(e1)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c75646421.tgcon)
	e4:SetTarget(c75646421.tgtg)
	e4:SetOperation(c75646421.tgop)
	c:RegisterEffect(e4)
end
function c75646421.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,2)
	if chk==0 then return g:FilterCount(Card.IsAbleToGraveAsCost,nil)==2 end
	e:SetLabel(g:FilterCount(Card.IsSetCard,nil,0x32c4))
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g,REASON_COST)
end
function c75646421.filter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0x32c4) and c:IsAbleToDeck()
end
function c75646421.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c75646421.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c75646421.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	if e:GetLabel()==0 then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
	elseif e:GetLabel()==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75646421.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end

function c75646421.spfilter(c,e,tp)
	return c:IsSetCard(0x32c4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c75646421.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	if e:GetLabel()==0 and e:GetHandler():IsAbleToRemove() then
	   Duel.BreakEffect()
	   Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_EFFECT)
	elseif e:GetLabel()==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75646421.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(75646421,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75646421.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	elseif e:GetLabel()==2 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.DisableShuffleCheck()
			Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		end
	end
end
function c75646421.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
end
function c75646421.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)-Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(1-tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,ct)
end
function c75646421.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)-Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct>0 then
		Duel.DiscardDeck(1-tp,ct,REASON_EFFECT)
	end
end