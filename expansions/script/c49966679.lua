--量子自杀
function c49966679.initial_effect(c)
	 c:EnableCounterPermit(0x1011)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	 local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49966679,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c49966679.addcon)
	e3:SetOperation(c49966679.addc)
	c:RegisterEffect(e3)
	--dice
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49966679,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c49966679.condition)
	e2:SetTarget(c49966679.target)
	e2:SetOperation(c49966679.operation)
	c:RegisterEffect(e2)
	 local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49966679,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c49966679.descost)
	e4:SetOperation(c49966679.desop)
	c:RegisterEffect(e4)
end
function c49966679.addcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp 
end
function c49966679.addc(e,tp,eg,ep,ev,re,r,rp)
		e:GetHandler():AddCounter(0x1011,1)
end
c49966679.toss_dice=true
function c49966679.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c49966679.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c49966679.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c49966679.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local dice=Duel.TossDice(tp,1)
	if dice==1 or dice==3 then
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
	elseif dice==2 or dice==4 then
		 local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(c49966679.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,p)
	elseif dice==5 or dice==6 then
		 if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c49966679.spfilter,1-tp,LOCATION_DECK,0,1,nil,e,1-tp) and Duel.SelectYesNo(1-tp,aux.Stringid(49966679,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(1-tp,c49966679.spfilter,1-tp,LOCATION_DECK,0,1,1,nil,e,1-tp)
				if #g>0 then
					Duel.SpecialSummon(g,0,1-tp,1-tp,false,false,POS_FACEUP)
				end
	end
end
 end
function c49966679.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c49966679.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1011,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1011,1,REASON_COST)
end
function c49966679.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
	Duel.MoveToField(c,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end