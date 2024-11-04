--磁石战士 电磁始神
local m=40011619
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,4740489)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.spccon)
	e1:SetOperation(cm.spcop)
	c:RegisterEffect(e1)	
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,m+1)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function cm.spcfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_ROCK)
end
function cm.spccon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or not Duel.IsExistingMatchingCard(cm.spcfilter,tp,LOCATION_MZONE,0,1,nil))
end
function cm.spcop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(-1000)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_DISABLE)
	c:RegisterEffect(e2)
	--change base attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(4)
	e3:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e3)
end
function cm.pfilter(c,tp)
	return c:IsCode(4740489) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.pfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function cm.tgfilter(c)
	return c:IsSetCard(0x2066,0xe9) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.pfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		if Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)~=0 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
	--local e1=Effect.CreateEffect(e:GetHandler())
	--e1:SetType(EFFECT_TYPE_FIELD)
	--e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	--e1:SetTargetRange(1,0)
	--e1:SetTarget(cm.splimit)
	--e1:SetReset(RESET_PHASE+PHASE_END)
	--Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return not c:IsRace(RACE_ROCK) 
end
