--fate·宇宙力量
function c9950450.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c9950450.cost)
	e1:SetTarget(c9950450.target)
	e1:SetOperation(c9950450.activate)
	c:RegisterEffect(e1)
end
function c9950450.cfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function c9950450.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c9950450.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c9950450.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c9950450.filter(c,e,tp)
	return ((c:IsSetCard(0x9ba6) and c:IsType(TYPE_MONSTER)) or (c:IsSetCard(0xba5) and bit.band(c:GetType(),0x81)==0x81)) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9950450.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then
		e:SetLabel(0)
		return res and Duel.IsExistingMatchingCard(c9950450.filter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9950450.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9950450.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,true,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		g:GetFirst():RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete()
end

