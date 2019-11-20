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
	--sps
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetCountLimit(1,33400008)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(1)
	e2:SetCost(c33400007.cost)
	e2:SetCondition(c33400007.condition)
	e2:SetTarget(c33400007.sptg1)
	e2:SetOperation(c33400007.spop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(aux.chainreg)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33400007,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,33400007)
	e4:SetLabel(2)
	e4:SetCost(c33400007.thcost)
	e4:SetTarget(c33400007.thtg)
	e4:SetOperation(c33400007.thop)
	c:RegisterEffect(e4)
end
function c33400007.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3341)
end
function c33400007.afilter(c)
	return c:IsSetCard(0x3340) and c:IsType(TYPE_QUICKPLAY)
end

function c33400007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34f,ct,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x34f,ct,REASON_COST)
end
function c33400007.condition(e,tp,eg,ep,ev,re,r,rp)
	return re  and re:IsActiveType(TYPE_QUICKPLAY) and re:GetHandler():IsSetCard(0x3340) and rp==tp and e:GetHandler():GetFlagEffect(1)>0
end 
function c33400007.spfilter1(c,e,tp)
	return  c:IsSetCard(0x3341) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400007.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33400007.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c33400007.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33400007.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
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