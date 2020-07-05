--整合运动·突击部队领袖-碎骨
function c79020025.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,2,c79020025.ovfilter,aux.Stringid(79020025,0))
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_EXTRA)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(c79020025.atkval)
	c:RegisterEffect(e1) 
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE+LOCATION_EXTRA)
	e2:SetCountLimit(1)
	e2:SetTarget(c79020025.desreptg)
	e2:SetValue(c79020025.desrepval)
	e2:SetOperation(c79020025.desrepop)
	c:RegisterEffect(e2) 
	--direct atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetCondition(c79020025.dacon)
	c:RegisterEffect(e3)
	--activate limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_DRAW_PHASE)
	e4:SetCountLimit(1)
	e4:SetCondition(c79020025.actcon)
	e4:SetCost(c79020025.actcost)
	e4:SetOperation(c79020025.actop)
	c:RegisterEffect(e4)
	--token
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetOperation(c79020025.tkop)
	c:RegisterEffect(e5)
end
function c79020025.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3900) and c:IsLevelAbove(10)
end
function c79020025.atkval(e,c)
	return c:GetBaseAttack()-1000
end
function c79020025.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c79020025.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c79020025.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_EXTRA,1,nil) end
	return Duel.SelectEffectYesNo(tp,c,79029096)
end
function c79020025.desrepval(e,c)
	return c79020025.repfilter(c,e:GetHandlerPlayer())
end
function c79020025.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetExtraTopGroup(1-tp,1)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_CARD,1-tp,79020025)
end
function c79020025.dacon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN) and e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ 
end
function c79020025.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c79020025.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79020025.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79020025.tkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.CreateToken(tp,79020026)
	Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
end



