--天井伊吕波
local s,id,o=GetID()
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--scale
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_LSCALE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(s.sccon)
	e2:SetValue(s.scvl)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_RSCALE)
	e3:SetValue(s.scvr)
	c:RegisterEffect(e3)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtra() and (Duel.GetLocationCountFromEx(1-tp,1-tp,nil,TYPE_PENDULUM)>0 or c:IsAbleToGrave()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,1-tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,1-tp,0)
end
function s.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoExtraP(c,1-tp,REASON_COST)>0 and c:IsLocation(LOCATION_EXTRA) then
		local b1=Duel.GetLocationCountFromEx(1-tp,1-tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEDOWN_DEFENSE)
		local b2=c:IsAbleToGrave()
		local op=aux.SelectFromOptions(1-tp,{b1,aux.Stringid(id,3)},{b2,aux.Stringid(id,4)})
		if op==1 then
			Duel.SpecialSummon(c,0,1-tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
		end
		if op==2 then
			if Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetCategory(CATEGORY_DISABLE_SUMMON)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_SPSUMMON)
				e1:SetCountLimit(1)
				e1:SetLabel(c:GetDefense())
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetCondition(s.necon)
				e1:SetOperation(s.neop)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function s.nefilter(c,e)
	return not (c:GetDefense()>e:GetLabel())
end
function s.necon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.nefilter,1,nil,e)
end
function s.neop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.NegateSummon(eg:Filter(s.nefilter,nil,e))
end
function s.sccon(e)
	return Duel.IsExistingMatchingCard(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())
end
function s.scvl(e)
	local tc=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler()):GetFirst()
	if tc then return -tc:GetLeftScale() end
	return 0
end
function s.scvr(e)
	local tc=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler()):GetFirst()   
	if tc then return -tc:GetRightScale() end
	return 0
end