--假面骑士OOO 圣徽暴咬龙
function c32100020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c32100020.target)
	e1:SetOperation(c32100020.operation)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	c:RegisterEffect(e2) 
	--redirect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP) 
	e2:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)   
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,32100020)
	e3:SetTarget(c32100020.atktg) 
	e3:SetOperation(c32100020.atkop) 
	c:RegisterEffect(e3) 
	--equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c32100020.eqlimit)
	c:RegisterEffect(e4)
end
c32100020.IsSetName_HR_Kmr000_Listed=true 
function c32100020.eqlimit(e,c)
	return c.SetCard_HR_Kmr000
end
function c32100020.filter(c)
	return c:IsFaceup() and c.SetCard_HR_Kmr000 
end
function c32100020.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c32100020.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c32100020.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c32100020.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c32100020.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec and Duel.IsExistingMatchingCard(function(c) return c:IsAbleToGraveAsCost() and c:IsCode(32100001) end,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToGraveAsCost() and c:IsCode(32100001) end,tp,LOCATION_HAND,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_COST)  
	Duel.SetTargetCard(ec) 
end 
function c32100020.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local ec=e:GetHandler():GetEquipTarget() 
	if c:IsRelateToEffect(e) and ec:IsRelateToEffect(e) then   
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_ATTACK_ALL)  
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		ec:RegisterEffect(e1)  
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_PIERCE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		ec:RegisterEffect(e1)   
	end 
end 








