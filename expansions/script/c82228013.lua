function c82228013.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)  
	--indes  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetTarget(c82228013.indtg)  
	e2:SetValue(aux.indoval)  
	c:RegisterEffect(e2)  
	--atk
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_ATKCHANGE)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_SZONE) 
	e3:SetCost(c82228013.cost)  
	e3:SetCountLimit(1,82228013)  
	e3:SetTarget(c82228013.target)  
	e3:SetOperation(c82228013.operation)  
	c:RegisterEffect(e3)  
end

function c82228013.indtg(e,c)  
	return c:IsRace(RACE_INSECT)  
end  
 
function c82228013.cfilter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x290)  
end  

function c82228013.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckReleaseGroup(tp,c82228013.cfilter,1,nil) end  
	local sg=Duel.SelectReleaseGroup(tp,c82228013.cfilter,1,1,nil)  
	Duel.Release(sg,REASON_COST)  
end  

function c82228013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(tp) and chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) end  
	if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,aux.nzatk,tp,LOCATION_MZONE,0,1,1,nil)  
end  

function c82228013.operation(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if not e:GetHandler():IsLocation(LOCATION_SZONE) then  return end
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)  
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
		e1:SetValue(tc:GetAttack()*2)  
		tc:RegisterEffect(e1)  
	end  
end