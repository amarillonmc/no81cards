--龙族帝王 究极骑士艾可萨兽
function c16349019.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c16349019.ffilter1,c16349019.ffilter2,false)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16349019,1))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c16349019.target)
	e1:SetOperation(c16349019.operation)
	c:RegisterEffect(e1)
	--Prevent Activation
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(c16349019.aclimit)
	c:RegisterEffect(e2)
	--Pos
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(c16349019.con)
	e3:SetTarget(c16349019.tg)
	e3:SetOperation(c16349019.op)
	c:RegisterEffect(e3)
end
function c16349019.ffilter1(c)
	return c:IsLevelAbove(8) and c:IsRace(RACE_DRAGON) and c:IsFusionType(TYPE_FUSION+TYPE_SYNCHRO)
end
function c16349019.ffilter2(c)
	return c:IsLevelAbove(8) and c:IsRace(RACE_WARRIOR) and c:IsFusionType(TYPE_FUSION+TYPE_SYNCHRO)
end
function c16349019.pfilter(c,tp)
	return c:IsCode(16349067) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c16349019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c16349019.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c16349019.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16349019.pfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
function c16349019.aclimit(e,re,tp)
	return re:GetHandler():IsRace(RACE_DRAGON) and re:IsActiveType(TYPE_MONSTER)
end
function c16349019.cfilter(c,e,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(1-tp)
end
function c16349019.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16349019.cfilter,1,nil,e,tp)
end
function c16349019.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c16349019.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=eg:Filter(c16349019.cfilter,nil,e,tp):Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
	local g2=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,nil)
	local b1=#g1>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,16349019)==0
	local b2=#g2>0 and Duel.GetFlagEffect(tp,16349019+1)==0
	if chk==0 then return b1 or b2 end
end
function c16349019.op(e,tp,eg,ep,ev,re,r,rp)
	local g1=eg:Filter(c16349019.cfilter,nil,e,tp):Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
	local g2=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,nil)
	local b1=#g1>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,16349019)==0
	local b2=#g2>0 and Duel.GetFlagEffect(tp,16349019+1)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(16349019,1),aux.Stringid(16349019,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(16349019,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(16349019,2))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g1:Select(tp,1,1,nil):GetFirst()
		if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
		Duel.RegisterFlagEffect(tp,16349019,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local tc=g2:Select(tp,1,1,nil):GetFirst()
		if tc then Duel.GetControl(tc,tp) end
		Duel.RegisterFlagEffect(tp,16349019+1,RESET_PHASE+PHASE_END,0,1)
	end
end