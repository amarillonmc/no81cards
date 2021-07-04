--东国·特种干员-绮良
function c79029478.initial_effect(c)
	--fusion procedure
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0xa900),c79029478.matfilter1,c79029478.matfilter2,nil)
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79029478.rccon)
	e2:SetOperation(c79029478.rcop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,79029478)
	e3:SetCost(c79029478.stcost)
	e3:SetTarget(c79029478.sttg)
	e3:SetOperation(c79029478.stop)
	c:RegisterEffect(e3)
end
function c79029478.matfilter1(c)
	return c:IsFusionAttribute(ATTRIBUTE_WATER)
end
function c79029478.matfilter2(c)
	return c:IsRace(RACE_CYBERSE)
end
function c79029478.rccon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c79029478.rcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,79029478)
	if Duel.GetFlagEffect(tp,79029478)==0 then 
	Debug.Message("辅助的话，我大概能帮上点忙......吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029478,1))	
	end
	Duel.RegisterFlagEffect(tp,79029478,RESET_PHASE+PHASE_END,0,1,0)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-400)
	Duel.Recover(tp,400,REASON_EFFECT)
end
function c79029478.ctfil(c)
	return c:IsSetCard(0xa900) and c:IsAbleToGraveAsCost()
end
function c79029478.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029478.ctfil,tp,LOCATION_EXTRA,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c79029478.ctfil,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79029478.stfil(c)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c79029478.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029478.stfil,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
end
function c79029478.stop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c79029478.stfil,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Debug.Message("这样就行了吧？明白了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029478,2))   
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(79029478,0))
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(tc)
		e2:SetCategory(CATEGORY_RECOVER)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetRange(LOCATION_SZONE)
		e2:SetTarget(c79029478.xxtg)
		e2:SetOperation(c79029478.xxop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		tc:RegisterEffect(e3)
	 end
end
function c79029478.xxfil(c,e,tp)
	return e:GetHandler():GetColumnGroup():IsContains(c) and c:GetSummonPlayer()==tp
end
function c79029478.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c79029478.xxfil,1,nil,e,tp) end
	local atk=eg:Filter(c79029478.xxfil,nil,e,tp):GetSum(Card.GetAttack)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,atk)
end
function c79029478.xxop(e,tp,eg,ep,ev,re,r,rp)
	local atk=eg:Filter(c79029478.xxfil,nil,e,tp):GetSum(Card.GetAttack)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,atk,REASON_EFFECT)
end
















