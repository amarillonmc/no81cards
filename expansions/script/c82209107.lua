--清莲仙的祈流
local m=82209107
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCondition(cm.actcon)  
	c:RegisterEffect(e1)  
	--atk&def  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc298))  
	e2:SetValue(cm.atkval)  
	c:RegisterEffect(e2)  
	local e3=e2:Clone()  
	e3:SetCode(EFFECT_UPDATE_DEFENSE)  
	c:RegisterEffect(e3)
	--effect 2
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))  
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e4:SetCode(EVENT_BATTLE_START)  
	e4:SetRange(LOCATION_SZONE)  
	e4:SetCondition(cm.con) 
	e4:SetTarget(cm.tg)  
	e4:SetOperation(cm.op)  
	c:RegisterEffect(e4)   
	--effect 3  
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)  
	e5:SetCountLimit(1,m) 
	e5:SetCost(cm.cost2)
	e5:SetCondition(cm.con2) 
	e5:SetTarget(cm.tg2)  
	e5:SetOperation(cm.op2)  
	c:RegisterEffect(e5) 
end
function cm.actfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.atkval(e,c)
	return Duel.GetTurnCount()*300
end
--effect 2
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetAttacker()  
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end  
	return tc and tc:IsFaceup() and tc:IsSetCard(0xc298) 
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end  
--effect 3
function cm.confilter(c)
	return c:IsSetCard(0xc298) and c:IsFaceup()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.confilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end 
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.spfilter(c,e,tp)  
	return c:IsFaceup() and c:IsSetCard(0xc298) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0  
end  
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)  
end  
function cm.op2(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)  
	local tc=g:GetFirst()  
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end 