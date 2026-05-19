--贪龙断章族·阿特摩斯哈特
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,89490234,s.matfilter,1,true,true)
	aux.AddContactFusionProcedure(c,aux.FilterBoolFunction(Card.IsReleasable,REASON_SPSUMMON),LOCATION_MZONE,0,Duel.Release,REASON_SPSUMMON+REASON_MATERIAL)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetValue(s.atkval)
	c:RegisterEffect(e5)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(s.reptg)
	c:RegisterEffect(e4)
end
function s.matfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsFusionSetCard(0xc3c)
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function s.quick_filter(e)
	return e:IsHasCategory(CATEGORY_EQUIP)
end
function s.eqfilter(c,tp)
	return c:IsSetCard(0xc3c) and c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:IsOriginalEffectProperty(s.quick_filter)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
		local tc=g:GetFirst()
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(c)
		e1:SetValue(s.eqlimit2)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(89490234,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function s.eqlimit2(e,c)
	return c==e:GetLabelObject()
end
function s.atkval(e,c)
	return e:GetHandler():GetEquipCount()
end
function s.repfilter(c,e)
	return not c:IsStatus(STATUS_DESTROY_CONFIRMED) and not c:IsImmuneToEffect(e) and c:IsFaceup() and c:IsSetCard(0xc3c) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and Duel.IsExistingMatchingCard(s.repfilter,tp,LOCATION_ONFIELD,0,1,c,e) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.repfilter,tp,LOCATION_ONFIELD,0,1,1,c,e)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
