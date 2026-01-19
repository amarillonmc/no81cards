--人理朔蚀 伽内什
function c22024920.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,22024910,c22024920.mfilter,1,true,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_HAND+LOCATION_ONFIELD,0,Duel.Release,REASON_SPSUMMON+REASON_MATERIAL)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c22024920.splimit)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22024920.chaincon1)
	e2:SetOperation(c22024920.chainop1)
	c:RegisterEffect(e2) 
	--act limit 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22024920.chaincon2)
	e3:SetOperation(c22024920.chainop2)
	c:RegisterEffect(e3) 
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c22024920.reptg)
	c:RegisterEffect(e4)
end
function c22024920.mfilter(c)
	return c:IsFusionSetCard(0xff1) and c:IsLevelAbove(7)
end
function c22024920.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c22024920.cfilter1(c)
	return c:IsCode(22024930) and c:IsFaceup()
end
function c22024920.chaincon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c22024920.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function c22024920.chaincon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22024920.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function c22024920.chainop1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,22024920) 
	local flag=0 
	if re:IsActiveType(TYPE_MONSTER) then flag=bit.bor(flag,TYPE_MONSTER) end 
	if re:IsActiveType(TYPE_SPELL) then flag=bit.bor(flag,TYPE_SPELL) end 
	if re:IsActiveType(TYPE_TRAP) then flag=bit.bor(flag,TYPE_TRAP) end  
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e1:SetLabel(flag)
	e1:SetTargetRange(1,1) 
	e1:SetValue(c22024920.actlimit)
	e1:SetReset(RESET_CHAIN) 
	Duel.RegisterEffect(e1,tp) 
end 
function c22024920.chainop2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,22024920) 
	local flag=0 
	if re:IsActiveType(TYPE_MONSTER) then flag=bit.bor(flag,TYPE_MONSTER) end 
	if re:IsActiveType(TYPE_SPELL) then flag=bit.bor(flag,TYPE_SPELL) end 
	if re:IsActiveType(TYPE_TRAP) then flag=bit.bor(flag,TYPE_TRAP) end  
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e1:SetLabel(flag)
	e1:SetTargetRange(0,1) 
	e1:SetValue(c22024920.actlimit)
	e1:SetReset(RESET_CHAIN) 
	Duel.RegisterEffect(e1,tp) 
end 
function c22024920.actlimit(e,re,tp) 
	local flag=e:GetLabel() 
	return flag
end
function c22024920.repfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c22024920.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c22024920.repfilter,tp,LOCATION_HAND,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c22024920.repfilter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.Release(g,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end