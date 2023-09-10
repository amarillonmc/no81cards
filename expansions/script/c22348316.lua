--猎 杀 血 裔 的 狂 信 者
local m=22348316
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22348316)
	e1:SetCondition(c22348316.spcon)
	e1:SetTarget(c22348316.sptg)
	e1:SetOperation(c22348316.spop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c22348316.efilter)
	c:RegisterEffect(e2)
	--TurnSet
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c22348316.tscon)
	e3:SetTarget(c22348316.tstg)
	e3:SetOperation(c22348316.tsop)
	c:RegisterEffect(e3)
end
function c22348316.cfilter(c,tp)
	return c:IsSummonLocation(LOCATION_GRAVE) and c:IsPreviousControler(1-tp)
end
function c22348316.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348316.cfilter,1,nil,tp)
end
function c22348316.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22348316.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22348316.efilter(e,te)
	local tc=te:GetOwner()
	return te:IsActiveType(TYPE_MONSTER) and te:IsActivated()
		and te:GetActivateLocation()==LOCATION_MZONE and tc:IsSummonLocation(LOCATION_GRAVE)
end



function c22348316.cfilter2(c)
	return c:IsSummonLocation(LOCATION_GRAVE)
end
function c22348316.tscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348316.cfilter2,1,nil)
end
function c22348316.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c22348316.filter2(c)
	return c:IsRace(RACE_ZOMBIE)
end
function c22348316.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c22348316.filter,1,nil) end
	local g=eg:Filter(c22348316.filter,nil)
	Duel.SetTargetCard(g)
end
function c22348316.tsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 then
		local og=Duel.GetOperatedGroup()
		local oog=og:Filter(c22348316.filter2,nil)
		local tg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if #oog>0 and #tg>0 and c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(22348316,0)) then
			Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=tg:Select(tp,1,1,nil)
		if Duel.Destroy(sg,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
		end
	end
end

