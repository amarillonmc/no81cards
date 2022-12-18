--术结天缘 忍苦魔精
function c67200452.initial_effect(c)
	--pendulum
	aux.EnablePendulumAttribute(c,false)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c67200452.mfilter,c67200452.xyzcheck,2,99)  
	c:EnableReviveLimit() 
	--Draw
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOGRAVE)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,67200452)
	e0:SetCost(c67200452.setcost)
	e0:SetTarget(c67200452.tgtg)
	e0:SetOperation(c67200452.tgop)
	c:RegisterEffect(e0)  
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200452,1))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,67200453)
	e1:SetCost(c67200452.thcost)
	e1:SetTarget(c67200452.thtg)
	e1:SetOperation(c67200452.thop)
	c:RegisterEffect(e1)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200452,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,67200454)
	e2:SetCondition(c67200452.stcon)
	e2:SetTarget(c67200452.sttg)
	e2:SetOperation(c67200452.stop)
	c:RegisterEffect(e2)	 
end
function c67200452.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsSetCard(0x5671) 
end
function c67200452.xyzcheck(g)
	return true
end
--
function c67200452.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	if c:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,c)
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c67200452.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5671) and c:IsAbleToGrave() and c:IsFaceup()
end
function c67200452.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200452.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c67200452.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67200452.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--
function c67200452.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local rt=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local ct=c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	e:SetLabel(ct)
end
function c67200452.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local ct=e:GetLabel()
	if chk==0 then return ct1>ct-1 and Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function c67200452.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct>0 then
		Duel.DiscardDeck(tp,ct,REASON_EFFECT)
	end
end
--
function c67200452.stcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function c67200452.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and not e:GetHandler():IsForbidden() end
end
function c67200452.stop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then 
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
