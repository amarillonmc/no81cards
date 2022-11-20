--混乱纷争
function c10113019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10113019,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113019,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c10113019.condition)
	e2:SetTarget(c10113019.target)
	e2:SetOperation(c10113019.activate)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)	
end
function c10113019.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp and c:IsPreviousLocation(LOCATION_EXTRA) and c:GetPreviousControler()~=tp
end
function c10113019.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10113019.cfilter,1,nil,tp)
end
function c10113019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10113019.filter,tp,0,LOCATION_EXTRA,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_EXTRA)
end
function c10113019.filter(c,e,tp)
	return c:IsFacedown() and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c10113019.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c10113019.filter,tp,0,LOCATION_EXTRA,nil,e,tp)
	if g:GetCount()>0 then
	   local tc=g:RandomSelect(tp,1):GetFirst()
	   if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetRange(LOCATION_MZONE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCountLimit(1)
			e1:SetOperation(c10113019.retop)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
	   end
	end
end
function c10113019.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end