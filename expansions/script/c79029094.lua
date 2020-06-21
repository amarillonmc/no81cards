--罗德岛·狙击干员-陨星
function c79029094.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99177923,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029094.spcon)
	e1:SetCost(c79029094.spcost)
	e1:SetTarget(c79029094.sptg)
	e1:SetOperation(c79029094.spop)
	c:RegisterEffect(e1)  
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5087128,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,79029094)
	e1:SetCost(c79029094.dscost)
	e1:SetTarget(c79029094.destg)
	e1:SetOperation(c79029094.desop)
	c:RegisterEffect(e1)  
end
function c79029094.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	return eg:IsContains(c)
end
function c79029094.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c79029094.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c79029094.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c79029094.dscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1099,5,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1099,5,REASON_COST)
end
function c79029094.desfilter2(c,s,tp)
	local seq=c:GetSequence()
	return seq<5 and  math.abs(seq-s)==1 and c:IsControler(tp)
end
function c79029094.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return c:IsDestructable() and g:GetCount()>0 end
	local tc=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c79029094.desop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetFirstTarget()
	local seq=a:GetSequence()
		 local dg=Group.CreateGroup()
		if seq<5 then dg=Duel.GetMatchingGroup(c79029094.desfilter2,tp,0,LOCATION_MZONE,nil,seq,a:GetControler()) end
		if  Duel.Destroy(a,REASON_EFFECT)~=0 and dg:GetCount()>0 then
			Duel.Destroy(dg,REASON_EFFECT)
	end
end

