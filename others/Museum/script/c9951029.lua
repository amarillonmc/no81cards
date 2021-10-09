--歌仙的诗歌·清少纳言
function c9951029.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c9951029.matfilter,2,2)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c9951029.immcon)
	e1:SetValue(c9951029.efilter)
	c:RegisterEffect(e1)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951029,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c9951029.negcon)
	e1:SetTarget(c9951029.negtg)
	e1:SetOperation(c9951029.negop)
	c:RegisterEffect(e1)
	 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951029.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951029.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951029,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9951029,1))
end
function c9951029.matfilter(c,lc,sumtype,tp)
	return c:IsLevelAbove(9) and c:IsLinkSetCard(0xba5)
end
function c9951029.immcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9951029.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true
	else return te:IsActiveType(TYPE_LINK) and te:IsActivated() and te:GetOwner()~=e:GetOwner() end
end
function c9951029.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local loc,seq,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
	if p==1-tp then seq=seq+16 end
	return re:IsActiveType(TYPE_MONSTER) and not (bit.band(loc,LOCATION_MZONE)~=0 and  bit.extract(c:GetLinkedZone(),seq)~=0) and Duel.IsChainNegatable(ev)
end
function c9951029.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9951029.spfilter(c,e,tp)
	return c:IsSetCard(0xba5) and not c:IsCode(9951029) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9951029.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9951029.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9951029,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
