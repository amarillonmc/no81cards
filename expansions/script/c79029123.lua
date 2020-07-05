--龙门·重装干员-吽
function c79029123.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit() 
	--serch
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029123)
	e1:SetCondition(c79029123.lzcon)
	e1:SetTarget(c79029123.lztg)
	e1:SetOperation(c79029123.lzop)
	c:RegisterEffect(e1) 
	--def up 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79029123.condition)
	e2:SetOperation(c79029123.activate)
	c:RegisterEffect(e2)
	--def atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c79029123.cost)
	e3:SetOperation(c79029123.activate1)
	c:RegisterEffect(e3)   
end
function c79029123.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) or not e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c79029123.thfilter(c)
	return c:IsSetCard(0xa900) and c:IsAbleToHand()
end
function c79029123.spfilter(c,e,tp,att)
	return c:IsSetCard(0xa900) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029123.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029123.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029123.lzop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetMatchingGroup(c79029123.thfilter,tp,LOCATION_DECK,0,nil)
	local g=a:RandomSelect(tp,1)
	local att=g:GetFirst():GetAttribute()
	Duel.SendtoHand(g,tp,REASON_EFFECT)
	e:SetLabel(att)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c79029123.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,att)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c79029123.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(1-tp)
end
function c79029123.activate(e,tp,eg,ep,ev,re,r,rp)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_DEFENSE)
		e4:SetValue(400)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e4)
end
function c79029123.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029123.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
   --defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end










