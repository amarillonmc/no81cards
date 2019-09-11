--URBEX HINDER-沉默者
function c65010516.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c65010516.lcheck)
	c:EnableReviveLimit()
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65010516)
	e1:SetCost(c65010516.rmcost)
	e1:SetTarget(c65010516.rmtg)
	e1:SetOperation(c65010516.rmop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(0x14000)
	e4:SetCondition(c65010516.descon2)
	e4:SetTarget(c65010516.sptg)
	e4:SetOperation(c65010516.spop)
	c:RegisterEffect(e4)
end
c65010516.setname="URBEX"
function c65010516.lcfil(c)
	return c.setname=="URBEX"
end
function c65010516.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_EXTRA,0,2,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(65010516,RESET_EVENT+RESETS_STANDARD,0,1)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_EXTRA,0,nil)
	local sg=g:RandomSelect(tp,2)
	Duel.Remove(sg,POS_FACEDOWN,REASON_COST)
end
function c65010516.rmfilter(c,e,tp)
	return c:IsFacedown() and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)>0
end
function c65010516.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010516.rmfilter,tp,0,LOCATION_EXTRA,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c65010516.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65010516.rmfilter,tp,0,LOCATION_EXTRA,nil,e,tp)
	if g:GetCount()==0 then return end
	local tg=g:RandomSelect(tp,2)
	Duel.ConfirmCards(tp,tg)
	local tc=tg:FilterSelect(tp,aux.TRUE,1,1,nil):GetFirst()
	if Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
		local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e2:SetValue(LOCATION_EXTRA)
			tc:RegisterEffect(e2)
		if e:GetHandler():GetFlagEffect(65010516)>0 then
			e:GetHandler():SetCardTarget(tc)
		end
		Duel.SpecialSummonComplete()
	end
end
function c65010516.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc) and e:GetHandler():GetFlagEffect(65010516)~=0
end
function c65010516.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65010516.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end