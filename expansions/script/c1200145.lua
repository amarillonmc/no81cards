--Kiuaskivi 炉石
function c1200145.initial_effect(c)
	aux.AddCodeList(c,1200115)
	aux.AddCodeList(c,1200130)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c1200145.dmgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	--change position
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1200145,0))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c1200145.postg)
	e4:SetOperation(c1200145.posop)
	c:RegisterEffect(e4)
	--damage2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1200140,1))
	e5:SetType(EFFECT_TYPE_QUICK_F)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c1200145.damcon)
	e5:SetCost(c1200145.damcost)
	e5:SetTarget(c1200145.damtg)
	e5:SetOperation(c1200145.damop)
	c:RegisterEffect(e5)
end

function c1200145.dmgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetCost(c1200145.costchk)
	e1:SetTarget(c1200145.costtg)
	e1:SetOperation(c1200145.costop)
	Duel.RegisterEffect(e1,tp)
end
function c1200145.costchk(e,te_or_c,tp)
	return Duel.CheckLPCost(tp,50)
end
function c1200145.costtg(e,te,tp)
	return te:GetHandlerPlayer()==1-Duel.GetTurnPlayer()
end
function c1200145.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,50)
end

function c1200145.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function c1200145.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end

function c1200145.damcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc>0
		and ep==1-Duel.GetTurnPlayer() and e:GetHandler():IsFacedown()
end
function c1200145.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
end
function c1200145.damfilter(c)
	return not (c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE))
		and not ((c:IsLocation(LOCATION_ONFIELD) or c:IsLocation(LOCATION_REMOVED)) and c:IsFacedown())
end
function c1200145.damfilter2(c)
	return not (c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE))
		and not ((c:IsLocation(LOCATION_ONFIELD) or c:IsLocation(LOCATION_REMOVED)) and c:IsFacedown()) and c:GetFlagEffect(1200145)==0
end
function c1200145.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200145.damfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
end
function c1200145.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c1200145.damfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	
	if g:GetCount()==0 then
		g=Duel.GetMatchingGroup(c1200145.damfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	end
	
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1200145,3))
		local tc=g:Select(tp,1,1,nil):GetFirst()
		tc:RegisterFlagEffect(1200145,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(1200145,2))
		if c:GetFlagEffect(1200146)==0 then
			c:RegisterFlagEffect(1200146,RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_ACTIVATE_COST)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,1)
			e1:SetCost(c1200145.costchk2)
			e1:SetTarget(c1200145.costtg2)
			e1:SetOperation(c1200145.costop2)
			Duel.RegisterEffect(e1,tp)
		end
	end
end

function c1200145.costchk2(e,te_or_c,tp)
	return Duel.CheckLPCost(tp,300)
end
function c1200145.costtg2(e,te,tp)
	return te:GetHandler():GetFlagEffect(1200145)>0
end
function c1200145.costop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,300)
end

