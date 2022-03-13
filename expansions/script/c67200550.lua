--巧壳将 威斯海特
function c67200550.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	c:SetSPSummonOnce(67200550)
	aux.AddLinkProcedure(c,c67200550.mfilter,1,1)   
	--move & special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200550,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,67200550)
	e2:SetTarget(c67200550.sptg)
	e2:SetOperation(c67200550.spop)
	c:RegisterEffect(e2)
end
function c67200550.mfilter(c)
	return c:IsLinkSetCard(0x676) and c:IsLinkType(TYPE_PENDULUM)
end
--
function c67200550.spfilter(c,e,tp,zone)
	return c:IsFaceup() and c:IsSetCard(0x676) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c67200550.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function c67200550.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	local pseq=c:GetSequence()
	Duel.MoveSequence(c,seq)
--
	local zone=aux.GetMultiLinkedZone(tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and Duel.IsExistingMatchingCard(c67200550.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone) and Duel.SelectYesNo(tp,aux.Stringid(67200550,2)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c67200550.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
end

