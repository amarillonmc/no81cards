--炼狱之魔王 斯达迪亚波罗斯
function c40008110.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),8,2,c40008110.ovfilter,aux.Stringid(40008110,0),2,c40008110.xyzop)
	c:EnableReviveLimit()
	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)
	--to deck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40008110,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,40008110)
	e5:SetCost(c40008110.tdcost)
	e5:SetTarget(c40008110.tdtg)
	e5:SetOperation(c40008110.tdop)
	c:RegisterEffect(e5)	
end
function c40008110.ovfilter(c)
	return c:IsFaceup() and c:IsCode(64414267)
end
function c40008110.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40008110)==0 end
	Duel.RegisterFlagEffect(tp,40008110,RESET_PHASE+PHASE_END,0,1)
end
function c40008110.filter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup() and c:IsReleasable()
end
function c40008110.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(c40008110.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c40008110.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil) 
	Duel.Release(g,REASON_COST)
end
function c40008110.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil) end
end
function c40008110.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,1-tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SelectOption(1-tp,aux.Stringid(40008110,2),aux.Stringid(40008110,3))==0 then
			Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		else
			Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
		end
	end
end
