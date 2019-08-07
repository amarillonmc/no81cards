--同调之门
function c10150030.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10150030+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10150030.cost)
	e1:SetTarget(c10150030.target)
	e1:SetOperation(c10150030.activate)
	c:RegisterEffect(e1)	   
end
function c10150030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10150030.spfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c10150030.cfilter(c)
	return Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c10150030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(c10150030.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		local b2=Duel.CheckReleaseGroup(tp,c10150030.cfilter,1,nil)
		if e:GetLabel()~=100 then 
		   e:SetLabel(0)
		   return b1 and Duel.GetLocationCountFromEx(tp)>0
		end 
		return b1 and b2
	end
	if e:GetLabel()==100 then
	   e:SetLabel(0)
	   local g=Duel.SelectReleaseGroup(tp,c10150030.cfilter,1,1,nil)
	   Duel.Release(g,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10150030.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp)>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local tc=Duel.SelectMatchingCard(tp,c10150030.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_ATTACK)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3,true)
			Duel.SpecialSummonComplete()
		end
	end
end