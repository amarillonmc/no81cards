--Protoss·机械哨兵
function c65870065.initial_effect(c)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCountLimit(1,65870065)
	e3:SetTarget(c65870065.desreptg)
	e3:SetValue(c65870065.desrepval)
	e3:SetOperation(c65870065.desrepop)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65870065+1)
	e1:SetTarget(c65870065.target1)
	e1:SetOperation(c65870065.activate1)
	c:RegisterEffect(e1)
end

function c65870065.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField() and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c65870065.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c65870065.repfilter,1,c,tp) and c:IsAbleToRemove() and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c65870065.desrepval(e,c)
	return c65870065.repfilter(c,e:GetHandlerPlayer())
end
function c65870065.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end

function c65870065.spfilter(c,e,tp)
	return c:IsSetCard(0x3a37) and c:IsType(TYPE_MONSTER) and aux.NecroValleyFilter() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65870065.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65870065.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c65870065.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65870065.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local tc=g:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_DECK)
			tc:RegisterEffect(e1,true)
		end
	end
end