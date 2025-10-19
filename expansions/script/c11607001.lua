--红之璀璨原钻
function c11607001.initial_effect(c)
	-- 多卡破坏
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11607001,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11607001)
	e1:SetTarget(c11607001.destg)
	e1:SetOperation(c11607001.desop)
	c:RegisterEffect(e1)
	-- 遗言特招
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11607001,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11607002)
	e2:SetTarget(c11607001.sptg)
	e2:SetOperation(c11607001.spop)
	c:RegisterEffect(e2)
end
function c11607001.desfilter(c)
	return c:IsRace(RACE_ROCK) and c:IsDestructable()
end
function c11607001.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable() end
	local g=Duel.GetMatchingGroup(c11607001.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,#g,0)
end
function c11607001.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11607001.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg2=Group.CreateGroup()
		local tg=g:Clone()
		tg:RemoveCard(c)
		if #tg>0 then
			sg2=tg:Select(tp,0,#tg,nil)
		end
		local sg=Group.CreateGroup()
		sg:AddCard(c)
		sg:Merge(sg2)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
-- 2
function c11607001.spfilter(c,e,tp)
	return c:IsSetCard(0x6225) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11607001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11607001.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c11607001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11607001.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c11607001.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c11607001.splimit(e,c)
	return not c:IsRace(RACE_ROCK)
end
