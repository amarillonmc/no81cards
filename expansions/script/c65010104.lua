--星光歌剧 露崎真昼
function c65010104.initial_effect(c)
	--summon proc
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(65010104,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c65010104.sumcon)
	e0:SetOperation(c65010104.sumop)
	e0:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCost(c65010104.cost)
	e1:SetOperation(c65010104.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(65010104,ACTIVITY_SPSUMMON,c65010104.counterfilter)
end
function c65010104.refil(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x9da0)
end
function c65010104.sumcon(e,c)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c65010104.refil,tp,LOCATION_EXTRA,0,1,nil)
end
function c65010104.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c65010104.refil,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c65010104.counterfilter(c)
	return c:IsSetCard(0x9da0)
end
function c65010104.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(65010104,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetFlagEffect(tp,65010104)==0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_COST) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65010104.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,65010104,RESET_PHASE+PHASE_END,0,1)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST,nil,REASON_COST)
end
function c65010104.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x9da0)
end
function c65010104.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_RELEASE_SUM)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end