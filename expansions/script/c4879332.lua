local s,id,o=GetID()
function s.initial_effect(c)
c:SetUniqueOnField(1,0,id)
c:SetSPSummonOnce(id)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xae6d),s.matfilter,true)
	   local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
end
function s.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc  then

	   Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
end
function s.desfilter1(c)
	return c:IsFaceup() and  c:IsType(TYPE_CONTINUOUS)
end
function s.ofilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return (b1 or b2) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_SZONE,0,1,nil) end
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(id,1)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
	else
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	 local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_SZONE,0,1,2,nil)
	 if g:GetCount()>0  then
	 Duel.HintSelection(g)
	 Duel.Destroy(g,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,g:GetCount(),nil)
		if g1:GetCount()>0 then
			Duel.HintSelection(g1)
			Duel.Destroy(g1,REASON_EFFECT)
		end
		end
	else
	   
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	 local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_SZONE,0,1,2,nil)
	 if g:GetCount()>0  then
	 Duel.HintSelection(g)
	 Duel.Destroy(g,REASON_EFFECT)
	  Duel.Draw(tp,g:GetCount(),REASON_EFFECT)
	 end
	end
end
function s.matfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:GetOriginalType()&TYPE_MONSTER~=0
end