--新 生 B小 町
local m=43990015
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,43990016)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--CATEGORY_DISABLE
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1)
	e1:SetTarget(c43990015.destg)
	e1:SetOperation(c43990015.desop)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_SZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,43990015)
	e2:SetCondition(c43990015.drcon)
	e2:SetTarget(c43990015.drtg)
	e2:SetOperation(c43990015.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_LEAVE_GRAVE)
	c:RegisterEffect(e3)  
	--untarget
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c43990015.atktg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c43990015.atktg)
	e5:SetValue(500)
	c:RegisterEffect(e5)
	
end
function c43990015.atktg(e,c)
	return aux.IsCodeListed(c,43990016) and c:IsFaceup()
end

function c43990015.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCode(43990016) and c:IsAbleToGrave()
end
function c43990015.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c43990015.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c43990015.desop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local tg=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		local tc=tg:GetFirst()
		if tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e,false) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c43990015.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
end
function c43990015.drconf(c,tp)
	return c:IsCode(43990016) and c:IsPreviousControler(tp)
end
function c43990015.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c43990015.drconf,1,nil,tp)
end
function c43990015.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c43990015.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	c:ResetFlagEffect(43990015)
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.RegisterFlagEffect(tp,43990015,0,0,1)
		c:RegisterFlagEffect(43990015,0,0,1)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,LOCATION_GRAVE)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c43990015.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c43990015.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:GetFlagEffect(43990015)~=0 then
				Duel.BreakEffect()
				Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
	end
end