--骑士王 阿尔弗雷德
function c40009152.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_LIGHT),2)
	c:EnableReviveLimit()  
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009152,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,40009152+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c40009152.thcon)
	e2:SetTarget(c40009152.atkktg)  
	e2:SetOperation(c40009152.atkop)
	c:RegisterEffect(e2)  
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(40009152,1))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1,40009153) 
	e1:SetCost(c40009152.cost) 
	e1:SetTarget(c40009152.target)  
	e1:SetOperation(c40009152.operation)  
	c:RegisterEffect(e1) 
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c40009152.atkcon)
	e3:SetValue(2000)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4) 
end
function c40009152.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c40009152.atkktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c40009152.chlimit)
end
function c40009152.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c40009152.discon)
	e1:SetTarget(c40009152.atktg)
	e1:SetValue(2000)
	Duel.RegisterEffect(e1,tp)
	--Duel.SetChainLimit(c40009152.chlimit)
end
function c40009152.chlimit(e,ep,tp)
	return tp==ep
end
function c40009152.discon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE 
end
function c40009152.atktg(e,c)
	return c:GetSequence()>=5
end
function c40009152.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD) 
end  
function c40009152.filter(c,e,tp,zone)  
	return c:IsCode(40009154) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)  
end  
function c40009152.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		local zone=e:GetHandler():GetLinkedZone(tp)  
		return zone~=0 and Duel.IsExistingMatchingCard(c40009152.filter,tp,LOCATION_DECK,0,1,nil,e,tp,zone)  
	end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end  
function c40009152.operation(e,tp,eg,ep,ev,re,r,rp)  
		local zone=e:GetHandler():GetLinkedZone(tp)
		if zone==0 then return end  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c40009152.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
		local tc=sg:GetFirst()
		if tc and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,zone) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		end
	Duel.SpecialSummonComplete()
end  
function c40009152.atkfilter(c)
	return c:IsFaceup() and c:IsCode(40009154)
end
function c40009152.atkcon(e)
	return Duel.IsExistingMatchingCard(c40009152.atkfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
