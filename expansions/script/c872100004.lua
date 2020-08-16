--神宝「蓬莱的玉枝　-梦色之乡-」
function c872100004.initial_effect(c)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(872100004,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c872100004.sprcon)
	e1:SetOperation(c872100004.sprop)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(c872100004.aclimit)
	c:RegisterEffect(e2)
--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(872100004,0))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,872100004)
	e5:SetCost(c872100004.thcost)
	e5:SetTarget(c872100004.destg)
	e5:SetOperation(c872100004.desop)
	c:RegisterEffect(e5)
end
function c872100004.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(872100004,2))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(872100004,3))
end
function c872100004.sprfilter(c)
	return c:IsType(TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK+TYPE_FUSION+TYPE_RITUAL) and c:IsType(TYPE_MONSTER)and c:IsSetCard(0xba1) and c:IsAbleToRemoveAsCost()
end
function c872100004.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c872100004.sprfilter,tp,LOCATION_GRAVE,0,2,nil)
end
function c872100004.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c872100004.sprfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c872100004.tdfilter(c,e,tp)
	return c:IsSetCard(0xba1) and c:IsAbleToDeck()
end
--
function c872100004.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
---
function c872100004.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(872100004,0))
end
function c872100004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c872100004.thfilter(c)
	return c:IsSetCard(0xba1) and c:IsAbleToHand()
end
function c872100004.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c872100004.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c872100004.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e))
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c872100004.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(872100004,0))
end
