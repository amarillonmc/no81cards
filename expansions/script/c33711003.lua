--疑虚拟YouTuber 星野尼亚
function c33711003.initial_effect(c)
	--fusion
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c33711003.ffilter,2,true)   
	--SpecialSummonLIMIT
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33711003.sslimit)
	c:RegisterEffect(e1)
	--Special Summon other
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33711003, 0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c33711003.sptg2)
	e2:SetOperation(c33711003.spop2)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33711003,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c33711003.spcost)
	e3:SetTarget(c33711003.sptg)
	e3:SetOperation(c33711003.spop)
	c:RegisterEffect(e3)
end
function c33711003.ffilter(c,fc,sub,mg,sg)
	return not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute())
end
function c33711003.sslimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsCode(e:GetHandler():GetCode())
end
function c33711003.spfilter(c, e, tp, code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function c33711003.sptg2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
			Duel.IsExistingMatchingCard(c33711003.spfilter, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, e:GetHandler():GetCode())
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, nil, tp, LOCATION_HAND + LOCATION_GRAVE)
end
function c33711003.spop2(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	local num=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then num=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp,c33711003.spfilter,tp,LOCATION_EXTRA,0,1,num,nil,e,tp,e:GetHandler():GetCode())
	if #g > 0 then
		Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
	end
end
function c33711003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,33711003) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,33711003)
	Duel.Release(g,REASON_COST)
end
function c33711003.spfilter(c,e,tp)
	return c:IsCode(33711003) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsAttack(2000) and c:IsDefense(2000)
end
function c33711003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c33711003.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33711003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c33711003.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			if Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
			Duel.SpecialSummonComplete()
		end
	end
end