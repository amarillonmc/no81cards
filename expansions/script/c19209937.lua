--饥献音乐家 穆吉
function c19209937.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19209937,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	--e1:SetCountLimit(1,19209937)
	e1:SetCost(c19209937.spscost)
	e1:SetTarget(c19209937.spstg)
	e1:SetOperation(c19209937.spsop)
	c:RegisterEffect(e1)
	--release
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209937,1))
	e2:SetCategory(CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c19209937.rlcon)
	e2:SetTarget(c19209937.rltg)
	e2:SetOperation(c19209937.rlop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19209937,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	--e3:SetCountLimit(1,19209937+1)
	e3:SetTarget(c19209937.sptg)
	e3:SetOperation(c19209937.spop)
	c:RegisterEffect(e3)
	--atk
	--[[local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c19209937.atkval)
	c:RegisterEffect(e3)]]--
end
function c19209937.rfilter(c,tp)
	return c:IsSetCard(0xb54) and c:IsLevelBelow(4) and Duel.GetMZoneCount(tp,c)>0
end
function c19209937.spscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c19209937.rfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c19209937.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c19209937.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c19209937.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c19209937.cfilter(c)
	return c:IsSetCard(0xb54) and c:IsLevelAbove(6) and c:IsFaceup()
end
function c19209937.rlcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19209937.cfilter,tp,LOCATION_MZONE,0,1,nil) and eg:IsExists(Card.IsControler,1,nil,1-tp) and not eg:IsContains(e:GetHandler())
end
function c19209937.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:IsExists(Card.IsReleasable,1,nil,REASON_RULE) and Duel.IsPlayerCanRelease(1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function c19209937.rlop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if g:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.HintSelection(sg)
			tc=sg:GetFirst()
		end
		Duel.Release(tc,REASON_RULE,1-tp)
	end
end
function c19209937.atkfilter(c)
	return c:IsSetCard(0xb54) and (c:GetType()&0x81)==0x81 and c:IsFaceup()
end
function c19209937.atkval(e,c)
	return Duel.GetMatchingGroupCount(c19209937.atkfilter,c:GetControler(),LOCATION_REMOVED,0,nil)*500
end
function c19209937.spfilter(c,e,tp,chk)
	return c:IsSetCard(0xb54) and c:IsLevel(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))
end
function c19209937.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c19209937.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c19209937.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c19209937.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,1):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
