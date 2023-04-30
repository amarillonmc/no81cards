--对凯文武装
function c32131332.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetTarget(c32131332.target)
	e1:SetOperation(c32131332.operation)
	c:RegisterEffect(e1) 
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c32131332.reptg)
	e2:SetValue(c32131332.repval)
	e2:SetOperation(c32131332.repop)
	c:RegisterEffect(e2) 
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(function(e) 
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsCode(32131314) end) 
	e2:SetValue(1000)
	c:RegisterEffect(e2)
end 
c32131332.SetCard_HR_flame13=true 
function c32131332.spfilter(c)
	return c.SetCard_HR_flame13 and c:IsFaceup() 
end
function c32131332.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c32131332.spfilter,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c32131332.spfilter,tp,LOCATION_MZONE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end 
function c32131332.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then 
		Duel.Equip(tp,c,tc)
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetLabelObject(tc)
		e1:SetValue(function(e,c)
		return e:GetLabelObject()==c end) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)
	end
end
function c32131332.repfilter(c,e)
	return e:GetHandler():GetEquipTarget()==c and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c32131332.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and eg:IsExists(c32131332.repfilter,1,nil,e) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c32131332.repval(e,c)
	return c32131332.repfilter(c,e)
end
function c32131332.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE) 
	Duel.Hint(HINT_CARD,0,32131332)
end




