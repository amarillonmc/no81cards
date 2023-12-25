--假面骑士OOO 圣徽斩剑
function c32100019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c32100019.target)
	e1:SetOperation(c32100019.operation)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)  
	--atk
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,32100019)
	e3:SetTarget(c32100019.atktg) 
	e3:SetOperation(c32100019.atkop) 
	c:RegisterEffect(e3) 
	--equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c32100019.eqlimit)
	c:RegisterEffect(e4)
end
c32100019.IsSetName_HR_Kmr000_Listed=true 
function c32100019.eqlimit(e,c)
	return c.SetCard_HR_Kmr000
end
function c32100019.filter(c)
	return c:IsFaceup() and c.SetCard_HR_Kmr000 
end
function c32100019.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c32100019.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c32100019.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c32100019.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c32100019.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec and Duel.IsExistingMatchingCard(function(c) return c:IsAbleToGraveAsCost() and c:IsCode(32100001) end,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToGraveAsCost() and c:IsCode(32100001) end,tp,LOCATION_HAND,0,1,3,nil) 
	local x=Duel.SendtoGrave(g,REASON_COST) 
	e:SetLabel(x) 
	if x>=2 then 
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
	end 
	Duel.SetTargetCard(ec) 
end 
function c32100019.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local ec=e:GetHandler():GetEquipTarget()
	local x=e:GetLabel()
	if c:IsRelateToEffect(e) and ec:IsRelateToEffect(e) and x then  
		if x>=1 then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			ec:RegisterEffect(e1)  
		end 
		if x>=2 and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) then 
			local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil) 
			Duel.Destroy(g,REASON_EFFECT) 
		end 
		local dg=Duel.GetMatchingGroup(function(c,atk) return c:IsFaceup() and c:GetAttack()<atk end,tp,0,LOCATION_MZONE,nil,ec:GetAttack())
		if x==3 and dg:GetCount()>0 then  
			Duel.Destroy(dg,REASON_EFFECT) 
		end 
	end 
end 






