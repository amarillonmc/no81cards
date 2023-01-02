--狂野恐啡肽狂龙·狂飙霸王龙
local s,id,o=GetID()
local m=40010483
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,cm.matfilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1173),true)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0,LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetTarget(cm.actfilter)
	c:RegisterEffect(e1)
	--atk change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(0,TIMING_CHAIN_END+TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCondition(aux.dscon)
	e2:SetCost(cm.atkcost)
	e2:SetTarget(cm.atktg)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m+o)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e4)   
end
function cm.matfilter(c)
	return c:IsFusionType(TYPE_FUSION) and c:IsFusionSetCard(0x1173)
end
function cm.actfilter(e,c)
	return c:IsAttackAbove(Duel.GetLP(e:GetHandlerPlayer()))
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function cm.atkfilter(c,lp)
	return c:IsFaceup() and c:GetAttack()~=lp
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local cost=math.floor(Duel.GetLP(tp)/2)
		local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_LPCOST_CHANGE)}
		for _,te in ipairs(ce) do
			local con=te:GetCondition()
			local val=te:GetValue()
			if (not con or con(te)) then
				cost=val(te,e,tp,cost)
			end
		end
		return Duel.IsExistingMatchingCard(cm.atkfilter,tp,0,LOCATION_MZONE,1,nil,Duel.GetLP(tp)-cost)
	end
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lp=Duel.GetLP(tp)
	--local g=Duel.GetMatchingGroup(cm.atkfilter,tp,0,LOCATION_MZONE,nil,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(lp)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x1173) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
