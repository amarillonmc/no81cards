--黑色门扉的管理人-莉希提凯特
local s,id,o=GetID()
function s.initial_effect(c)
	if not (yume and yume.prism) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71405000,0)
		yume.import_flag=false
	end
	yume.prism.addCounter()
	--①attack declaration or monster banished: negate same-name effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(yume.prism.Cost)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e1b=Effect.CreateEffect(c)
	e1b:SetDescription(aux.Stringid(id,0))
	e1b:SetCategory(CATEGORY_DISABLE)
	e1b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1b:SetCode(EVENT_REMOVE)
	e1b:SetProperty(EFFECT_FLAG_DELAY)
	e1b:SetRange(LOCATION_MZONE)
	e1b:SetCountLimit(1,id)
	e1b:SetCost(yume.prism.Cost)
	e1b:SetTarget(s.tg1)
	e1b:SetOperation(s.op1)
	c:RegisterEffect(e1b)
	--②from GY/banished: when own monster leaves due to opponent, self SS + SS prism monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+100000)
	e2:SetCondition(s.con2)
	e2:SetCost(yume.prism.Cost)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
--①
function s.tg1filter(c)
	if not c:IsFaceup() then return false end
	local code=c:GetOriginalCodeRule()
	local labels={Duel.GetFlagEffectLabel(0,id)}
	for _,v in ipairs(labels) do
		if v==code then return false end
	end
	return true
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tg1filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,s.tg1filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	local tc=g:GetFirst()
	local code=tc:GetOriginalCodeRule()
	-- negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(s.distg)
	e1:SetLabel(code)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(s.discon)
	e2:SetOperation(s.disop)
	e2:SetLabel(code)
	e2:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1,code)
end
function s.distg(e,c)
	local code=e:GetLabel()
	return c:IsOriginalCodeRule(code) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(code)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
--②
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	-- triggered card must have been face-up and controlled by tp, left due to opponent
	return rp==1-tp and eg:IsExists(s.con2filter,1,e:GetHandler(),tp)
end
function s.con2filter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP) and c:GetReasonPlayer()==1-tp
end
function s.filter2sp(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and c:IsSetCard(0x716) and c:IsType(TYPE_MONSTER)
		and c:IsFaceupEx() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsExistingMatchingCard(s.filter2sp,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2sp),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
