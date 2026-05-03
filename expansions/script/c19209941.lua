--饥献魔道士 勒杜亚斯
function c19209941.initial_effect(c)
	--spsummon-self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19209941,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,19209941)
	e1:SetCondition(c19209941.spscon)
	e1:SetTarget(c19209941.spstg)
	e1:SetOperation(c19209941.spsop)
	c:RegisterEffect(e1)
	--confirm
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209941,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19209941+1)
	e2:SetCondition(c19209941.condition)
	e2:SetTarget(c19209941.cftg)
	e2:SetOperation(c19209941.cfop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(19209941,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetTarget(c19209941.sptg)
	e3:SetOperation(c19209941.spop)
	c:RegisterEffect(e3)
end
function c19209941.cfilter(c)
	return c:IsSetCard(0xb54) and c:IsFaceup()
end
function c19209941.spscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19209941.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c19209941.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c19209941.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c19209941.chkfilter(c,tp)
	return c:IsSetCard(0xb54) and c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_RITUAL) and c:IsFaceup()
end
function c19209941.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c19209941.chkfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c19209941.cftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.GetMZoneCount(1-tp)>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c19209941.cfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local res=tp
		Duel.ConfirmCards(tp,g)
		local p=1-tp
		local sg=g:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false,POS_FACEUP,p)
		if Duel.GetMZoneCount(p)>0 and #sg>1 then
			local ft=Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or Duel.GetMZoneCount(p)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=sg:Select(tp,1,math.min(2,ft),nil)
		end
		--if Duel.GetMZoneCount(p)>0 then local sc=sg:GetFirst() end
		if #sg==0 then Duel.ShuffleHand(1-p) return end
		for sc in aux.Next(sg) do
			Duel.SpecialSummonStep(sc,0,p,p,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e3:SetValue(c19209941.fuslimit)
			sc:RegisterEffect(e3)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e4:SetValue(1)
			sc:RegisterEffect(e4)
			local e5=e4:Clone()
			e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			sc:RegisterEffect(e5)
			local e6=e4:Clone()
			e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			sc:RegisterEffect(e6)
		end
		Duel.SpecialSummonComplete()
		Duel.ShuffleHand(1-p)
		if #sg>0 then Duel.Draw(1-tp,1,REASON_EFFECT) end
	end
end
function c19209941.fuslimit(e,c,st)
	return st==SUMMON_TYPE_FUSION
end
function c19209941.spfilter(c,e,tp,chk)
	return c:IsSetCard(0xb54) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))-- and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and  and c:IsType(TYPE_MONSTER)
end
function c19209941.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c19209941.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,0)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c19209941.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c19209941.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,1):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
