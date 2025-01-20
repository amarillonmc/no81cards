--恶魔激斗
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,12866605)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateAttack() and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
	and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
	Duel.BreakEffect()
	local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc=sg:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)~=0 then
			if tc:IsOriginalCodeRule(12866605) then
				tc:CompleteProcedure()
			elseif not tc:IsCode(12866605) then
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetCountLimit(1)
				e2:SetLabelObject(tc)
				e2:SetCondition(s.tgcon)
				e2:SetOperation(s.tgop)
				Duel.RegisterEffect(e2,tp)
			end
		end
	end
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end