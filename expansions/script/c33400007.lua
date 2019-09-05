--时崎狂三-祈福
function c33400007.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,nil,2,2,c33400007.lcheck)
	c:EnableReviveLimit()
	 --activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(c33400007.afilter))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400007,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetValue(c33400007.sumval)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400007,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,33400007)
	e3:SetLabel(2)
	e3:SetCost(c33400007.thcost)
	e3:SetTarget(c33400007.thtg)
	e3:SetOperation(c33400007.thop)
	c:RegisterEffect(e3)
end
function c33400007.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3341)
end
function c33400007.afilter(c)
	return c:IsSetCard(0x3340) and c:IsType(TYPE_QUICKPLAY)
end
function c33400007.sumval(e,c)
		local sumzone=e:GetHandler():GetLinkedZone()
		local relzone=-bit.lshift(1,e:GetHandler():GetSequence())
		return 0,sumzone,relzone
end
function c33400007.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) 
	and Duel.IsCanRemoveCounter(tp,1,0,0x34f,ct,REASON_COST)
	end   
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x34f,ct,REASON_COST)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c33400007.thfilter(c)
	return c:IsSetCard(0x3341) and c:IsType(TYPE_MONSTER)  and c:IsAbleToHand()
end
function c33400007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400007.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33400007.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33400007.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end