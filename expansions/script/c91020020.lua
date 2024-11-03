--真神使者 鲲鹏
local m=91020020
local cm=c91020020
function c91020020.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m*3)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(cm.drcon)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,m*2)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTarget(cm.tg5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function cm.cfilter(c,tp,f)
	return f(c) and Duel.GetMZoneCount(tp,c)>0 and c:IsSetCard(0x9d1)
end
function cm.con1(e,c)
if c==nil then return true end  
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,tp,Card.IsReleasable)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c)
   local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,tp,Card.IsReleasable)
	Duel.Release(g,REASON_COST)
 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return not c:IsSetCard(0x9d0) and c:IsLocation(LOCATION_EXTRA)
end
--e2
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:GetReasonCard():IsRace(RACE_DIVINE) 
end
function cm.thfilter3(c)
	return c:IsFaceup()  and c:IsReleasable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter3,tp,LOCATION_ONFIELD,0,1,nil) end
 local g=Duel.SelectMatchingCard(tp,cm.thfilter3,tp,LOCATION_ONFIELD,0,1,1,nil)
 Duel.Release(g,REASON_COST)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(91020020,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(cm.cost)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.tgf)
	e4:SetOperation(cm.opf)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e4,true)
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp  
end
function cm.thfilter1(c)
	return  c:IsFaceup()
end
function cm.tgf(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,0)
end
function cm.opf(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	local atk=tc:GetAttack()*2
	Duel.Recover(tp,atk,REASON_EFFECT)
end
--e1
function cm.fit(c,e,tp)
	return c:IsSetCard(0x9d1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.fit,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.fit,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	 Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
end

