--15年 の 嘘
local m=43990014
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,43990014)
	aux.AddCodeList(c,43990016)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--destroy
--  local e1=Effect.CreateEffect(c)
--  e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
--  e1:SetType(EFFECT_TYPE_QUICK_O)
--  e1:SetCode(EVENT_FREE_CHAIN)
 --   e1:SetRange(LOCATION_SZONE)
--  e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
--  e1:SetCountLimit(1)
--  e1:SetTarget(c43990014.destg)
--  e1:SetOperation(c43990014.desop)
--  c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_SZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,43990014)
	e2:SetCondition(c43990014.drcon)
	e2:SetTarget(c43990014.drtg)
	e2:SetOperation(c43990014.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_LEAVE_GRAVE)
	c:RegisterEffect(e3)  
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)  
	e6:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c43990014.decon)
	e6:SetTarget(c43990014.detg)
	e6:SetOperation(c43990014.deop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_ATTACK_ANNOUNCE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e7:SetCondition(c43990014.decon2)
	e7:SetTarget(c43990014.detg2)
	e7:SetOperation(c43990014.deop2)
	c:RegisterEffect(e7)
	--untarget
--  local e4=Effect.CreateEffect(c)
--  e4:SetType(EFFECT_TYPE_FIELD)
--  e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
--  e4:SetRange(LOCATION_SZONE)
--  e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
--  e4:SetTargetRange(LOCATION_MZONE,0)
--  e4:SetTarget(c43990014.atktg)
--  e4:SetValue(1)
--  c:RegisterEffect(e4)
	--atkup
--  local e5=Effect.CreateEffect(c)
--  e5:SetType(EFFECT_TYPE_FIELD)
--  e5:SetCode(EFFECT_UPDATE_ATTACK)
--  e5:SetRange(LOCATION_SZONE)
--  e5:SetTargetRange(LOCATION_MZONE,0)
--  e5:SetTarget(c43990014.atktg)
--  e5:SetValue(500)
--  c:RegisterEffect(e5)
	
end
function c43990014.decon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)

end
function c43990014.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) and Duel.IsExistingMatchingCard(c43990014.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	 Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c43990014.deop(e,tp,eg,ep,ev,re,r,rp)
		if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c43990014.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
end


function c43990014.decon2(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c43990014.detg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	if chk==0 then return tc:IsOnField() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c43990014.deop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
		if tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c43990014.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
end

function c43990014.atktg(e,c)
	return aux.IsCodeListed(c,43990016) and c:IsFaceup()
end

function c43990014.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCode(43990016) and c:IsAbleToGrave()
end
function c43990014.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c43990014.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c43990014.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c43990014.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end
function c43990014.drconf(c,tp)
	return c:IsCode(43990016) and c:IsPreviousControler(tp)
end
function c43990014.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c43990014.drconf,1,nil,tp)
end
function c43990014.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c43990014.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	c:ResetFlagEffect(43990014)
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.RegisterFlagEffect(tp,43990014,0,0,1)
		c:RegisterFlagEffect(43990014,0,0,1)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,LOCATION_GRAVE)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c43990014.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c43990014.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:GetFlagEffect(43990014)~=0 then
				Duel.BreakEffect()
				Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
	end
end