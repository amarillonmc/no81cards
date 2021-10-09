--伪物语·抚子
function c9950320.initial_effect(c)
	  --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),4,2)
	c:EnableReviveLimit()
 --atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c9950320.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--deckdes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950320,0))
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9950320)
	e3:SetCost(c9950320.cost)
	e3:SetTarget(c9950320.target)
	e3:SetOperation(c9950320.operation)
	c:RegisterEffect(e3)
  --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950320.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950320.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950320,0))
end
function c9950320.value(e,c)
	return Duel.GetMatchingGroupCount(Card.IsAttribute,0,LOCATION_GRAVE,LOCATION_GRAVE,nil,ATTRIBUTE_DARK)*500
end
function c9950320.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9950320.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) and Duel.IsPlayerCanDiscardDeck(1-tp,5) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,PLAYER_ALL,5)
end
function c9950320.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsLocation(LOCATION_GRAVE)
end
function c9950320.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetDecktopGroup(tp,5)
	local g2=Duel.GetDecktopGroup(1-tp,5)
	g1:Merge(g2)
	local ct=g1:FilterCount(c9950320.cfilter,nil)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ct~=0 and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9950320,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sdg=dg:Select(tp,1,ct,nil)
		Duel.HintSelection(sdg)
		Duel.SendtoGrave(sdg,REASON_EFFECT)
	end
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g1,REASON_EFFECT)
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950320,0))
end
