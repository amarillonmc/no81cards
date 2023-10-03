--梦染
if not c71401001 then dofile("expansions/script/c71400001.lua") end
function c71400023.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400023,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,71400023+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,0x1f0)
	e1:SetTarget(yume.YumeFieldCheckTarget())
	e1:SetOperation(c71400023.op1)
	e1:SetCost(c71400023.cost1)
	c:RegisterEffect(e1)
	--ac in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(yume.nonYumeCon)
	c:RegisterEffect(e0)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400023,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_SUMMON+TIMING_SPSUMMON+TIMING_END_PHASE)
	e2:SetCondition(c71400023.con2)
	e2:SetCost(c71400023.cost2)
	e2:SetTarget(c71400023.tg2)
	e2:SetOperation(c71400023.op2)
	c:RegisterEffect(e2)
end
function c71400023.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c71400023.filter1(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true) and c:IsSetCard(0x3714)
end
function c71400023.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=yume.ActivateYumeField(e,tp)
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(71400023,2))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SSET)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_FZONE)
		e1:SetTargetRange(1,1)
		e1:SetTarget(c71400023.setlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		--[[
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_MSET)
		tc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_TURN_SET)
		tc:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e4:SetTarget(c71400023.sumlimit)
		tc:RegisterEffect(e4,true)
		--]]
		if not c:IsStatus(STATUS_ACT_FROM_HAND) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			Duel.BreakEffect()
			--cannot disable
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_DISABLE)
			e1:SetTargetRange(0xff,0)
			e1:SetTarget(c71400023.indtg)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			--cannot inactivate/disable
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_INACTIVATE)
			e2:SetValue(c71400023.efilter)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_DISEFFECT)
			e3:SetValue(c71400023.efilter)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function c71400023.setlimit(e,c)
	return not c:IsLocation(LOCATION_HAND)
end
--[[
function c71400023.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end
--]]
function c71400023.indtg(e,tc)
	return tc:IsSetCard(0x3714) and tc:IsType(TYPE_FIELD)
end
function c71400023.efilter(e,ct)
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return tp==e:GetHandlerPlayer() and tc:IsSetCard(0x3714) and tc:IsType(TYPE_FIELD)
end
function c71400023.filter2c(c)
	return c:IsSetCard(0x714) and c:IsDiscardable()
end
function c71400023.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400023.filter2c,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,c71400023.filter2c,1,1,REASON_COST+REASON_DISCARD)
end
function c71400023.con2(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and yume.YumeCon(e,tp)
end
function c71400023.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	Duel.SetChainLimit(c71400023.chlimit)
end
function c71400023.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()==2 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c71400023.chlimit(e,ep,tp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return tp==ep or not g:IsContains(e:GetHandler())
end