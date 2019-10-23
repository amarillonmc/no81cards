--究极异兽-雷电之电束木
function c40008599.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,5,c40008599.ovfilter,aux.Stringid(40008599,0),5,c40008599.xyzop)
	c:EnableReviveLimit()
	--attack all
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008599,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP+TIMING_MAIN_END)
	e1:SetCost(c40008599.cost)
	e1:SetTarget(c40008599.destg)
	e1:SetOperation(c40008599.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_SWAP_BASE_AD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c40008599.con)
	c:RegisterEffect(e2)	
end
function c40008599.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRank(9) and c:GetOverlayCount()>1
end
function c40008599.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40008599)==0 end
	Duel.RegisterFlagEffect(tp,40008599,RESET_PHASE+PHASE_END,0,1)
end
function c40008599.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c40008599.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c40008599.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008599.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c40008599.posfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c40008599.desop(e,tp,eg,ep,ev,re,r,rp)
		local g2=Duel.GetMatchingGroup(c40008599.posfilter,tp,0,LOCATION_MZONE,nil)
		if g2:GetCount()>0 and Duel.ChangePosition(g2,POS_FACEDOWN_DEFENSE)~=0 then
		if e:GetHandler():GetFlagEffect(40008599)==0 then
			e:GetHandler():RegisterFlagEffect(40008599,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,0,0)
		else
			e:GetHandler():ResetFlagEffect(40008599)
		end
end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c40008599.con(e)
	return e:GetHandler():GetFlagEffect(40008599)~=0
end
