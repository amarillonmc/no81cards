--机动犬舍
function c40011437.initial_effect(c)
	c:SetUniqueOnField(1,0,40011437) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c40011437.activate)
	c:RegisterEffect(e1)
end 
function c40011437.thfilter(c)
	return c:IsFaceup() and not c:IsCode(40011437) and c:IsSetCard(0xf11) and c:IsAbleToHand()
end
function c40011437.spfil(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0xf11,TYPES_TOKEN_MONSTER,1000,1000,1,RACE_MACHINE,ATTRIBUTE_LIGHT) 
end
function c40011437.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c40011437.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil) 
	local b1=g:GetCount()>0 
	local b2=Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0xf11) end,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c40011437.spfil,tp,LOCATION_SZONE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	local xtable={}
	if b1 then table.insert(xtable,aux.Stringid(40011437,1)) end 
	if b2 then table.insert(xtable,aux.Stringid(40011437,2)) end 
	local op=Duel.SelectOption(tp,table.unpack(xtable))+1 
	if xtable[op]==aux.Stringid(40011437,1) then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
	end 
	if xtable[op]==aux.Stringid(40011437,2) then 
		local tc=Duel.SelectMatchingCard(tp,c40011437.spfil,tp,LOCATION_SZONE,0,1,1,nil,e,tp):GetFirst()
		tc:AddMonsterAttribute(TYPE_NORMAL+TYPE_SPELL+TYPE_CONTINUOUS)
		Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_DEFENSE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(ATTRIBUTE_LIGHT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)	   
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(RACE_MACHINE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local fid=tc:GetFieldID()
		tc:RegisterFlagEffect(40011437,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c40011437.pcon)
		e1:SetOperation(c40011437.pop)
		Duel.RegisterEffect(e1,tp)
		Duel.SpecialSummonComplete()
	end 
end 
function c40011437.pcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(40011437)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c40011437.pop(e,tp,eg,ep,ev,re,r,rp)
	Duel.MoveToField(e:GetLabelObject(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
