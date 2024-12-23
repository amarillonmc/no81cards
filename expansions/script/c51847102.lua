--幽火军团·潜伏者
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,3,s.mfilter,aux.Stringid(id,0),2,s.altop)
	c:EnableReviveLimit()
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.chk)
		Duel.RegisterEffect(ge1,0)
	end
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetCost(s.spcost)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)

end
function s.chk(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) then return end
	Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
	if Duel.GetFlagEffect(rp,id)>=3 then
		Duel.RegisterFlagEffect(1-rp,id+o,RESET_PHASE+PHASE_END,0,2)
	end
end
function s.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_XYZ)~=SUMMON_TYPE_XYZ then return true end
	return Duel.GetTurnPlayer()~=tp
end
function s.exxyzfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xa67)
end
function s.mfilter(c,e,tp)
	local g=Duel.GetMatchingGroup(s.exxyzfilter,tp,LOCATION_MZONE,0,nil)
	return g and #g>0 and g:IsContains(c)
end
function s.altop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id+o)>0 end
end
function s.filter(c)
	return c:IsFacedown()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,1-tp,LOCATION_EXTRA,0,1,e:GetHandler()) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(s.filter,1-tp,LOCATION_EXTRA,0,e:GetHandler())
	if tg and c:IsRelateToEffect(e) and c:IsFaceup() then
		local tc=tg:RandomSelect(tp,1):GetFirst()
		local code=tc:GetOriginalCode()
		local ba=tc:GetBaseAttack()
		local bd=tc:GetBaseDefense()
		Duel.ConfirmCards(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetLabelObject(e1)
		e2:SetCode(EFFECT_SET_BASE_ATTACK_FINAL)
		e2:SetValue(ba)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_SET_BASE_DEFENSE_FINAL)
		e3:SetValue(bd)
		c:RegisterEffect(e3)

		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	end
end
