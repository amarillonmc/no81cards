--dragon-king palace, the crystal city
local cm,m=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--effect1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--effect2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(cm.condition2)
	e3:SetTarget(cm.target2)
	e3:SetOperation(cm.operation2)
	c:RegisterEffect(e3)
end
function cm.cfilter(c,tp)
	return c:IsSetCard(0x6978) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.sfilter(c)
	return c:IsSetCard(0x6978) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.sfilter2(c)
	return c:IsSetCard(0x6978) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.mfilter(c)
	return c:IsRace(RACE_SEASERPENT) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.rfilter(c,e,tp)
	return c:IsSetCard(0x6978) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=true--Duel.IsExistingMatchingCard(cm.sfilter2,tp,LOCATION_DECK,0,1,nil)
	local b2=(Duel.GetCurrentPhase()~=PHASE_END)
	if chk==0 then return true end
	local op=1
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))+1
	end
	e:SetLabel(op)
	if op==1 then e:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION) else e:SetCategory(0) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetDescription(aux.Stringid(m,0))
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		e4:SetTarget(cm.target3)
		e4:SetOperation(cm.operation3)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	elseif e:GetLabel()==1 then
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetDescription(aux.Stringid(m,1))
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_PHASE+PHASE_END)
		e5:SetCountLimit(1)
		e5:SetCondition(cm.condition4)
		e5:SetOperation(cm.operation4)
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
	elseif e:GetLabel()==2 then
		local turnp=Duel.GetTurnPlayer()
		Duel.SkipPhase(turnp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		local e8=Effect.CreateEffect(e:GetHandler())
		e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e8:SetType(EFFECT_TYPE_FIELD)
		e8:SetCode(EFFECT_CANNOT_BP)
		e8:SetTargetRange(1,0)
		e8:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e8,turnp)
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_FIELD)
		e6:SetCode(EFFECT_SKIP_TURN)
		e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e6:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==tp then
			e6:SetLabel(Duel.GetTurnCount())
			e6:SetCondition(cm.skip)
			e6:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e6:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e6,tp)
		local e7=e6:Clone()
		e7:SetCode(EFFECT_SKIP_M2)
		--Duel.RegisterEffect(e7,tp)
	end
end
function cm.skip(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then Duel.SSet(tp,tc) end
end
function cm.condition4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.mfilter),tp,LOCATION_GRAVE,0,1,nil)
end
function cm.operation4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.mfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if rg:GetCount()>0 then
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,rg)
	end
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_FZONE)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.rfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or #g<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	tc:SetMaterial(nil)
	if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)>0 then tc:CompleteProcedure() end
end