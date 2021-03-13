--亡语权能 魔女
function c99988027.initial_effect(c)	
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99988027,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99988027)
	e1:SetCondition(c99988027.spcon)
	e1:SetTarget(c99988027.sptg)
	e1:SetOperation(c99988027.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)	
	--attack limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c99988027.tglimit)
	c:RegisterEffect(e3)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99988027,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,199988027)
	e4:SetCondition(c99988027.rtcon)
	e4:SetTarget(c99988027.rttg)
	e4:SetOperation(c99988027.rtop)
	c:RegisterEffect(e4)
end
function c99988027.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x20df) and c:IsType(TYPE_MONSTER) and c:IsSummonPlayer(tp)
end
function c99988027.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99988027.cfilter,1,nil,tp)
end
function c99988027.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c99988027.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99988027.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
    local g=Duel.GetMatchingGroup(c99988027.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(99988027,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,1,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
			e:SetLabel(1)
	else
		e:SetLabel(0)
		end
		if e:GetLabel()==1 then
		  Duel.Draw(tp,1,REASON_EFFECT)
	   end
    end
end
function c99988027.tglimit(e,c)
	return c:IsRace(RACE_ZOMBIE)
 end
 function c99988027.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c99988027.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x20df) and c:IsAbleToGrave()
end
function c99988027.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99988027.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function c99988027.rtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99988027.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	end
end