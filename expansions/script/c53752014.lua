local m=53752014
local cm=_G["c"..m]
cm.name="无名天际领航者"
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53752002") end) then require("script/c53752002") end
function cm.initial_effect(c)
	Necrocean.AddSynchroMixProcedure(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToGrave() end
	local b1=Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.IsPlayerCanDiscardDeck(1-tp,1)
	if chk==0 then return true end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,1)
		opval[off]=0
		off=off+1
	end
	ops[off]=aux.Stringid(m,2)
	opval[off]=1
	off=off+1
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
		local ct=g:GetClassCount(Card.GetCode)
		while ct>0 do
			if Duel.IsPlayerCanDiscardDeck(tp,ct) and Duel.IsPlayerCanDiscardDeck(1-tp,ct) then break else ct=ct-1 end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,#sg,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,PLAYER_ALL,#sg)
	else
		e:SetCategory(0)
		e:SetProperty(0)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(Group.__add(Duel.GetDecktopGroup(tp,ct),Duel.GetDecktopGroup(1-tp,ct)),REASON_EFFECT)
		end
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TUNER))
		e1:SetValue(cm.efilter)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.efilter(e,te)
	local tp=e:GetHandlerPlayer()
	if te:GetHandlerPlayer()==tp or not te:IsActivated() then return false end
	if not (Duel.IsExistingMatchingCard(nil,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_REMOVED,1,nil)) then return false end
	if Duel.GetFlagEffect(tp,m)==0 then
		Duel.RegisterFlagEffect(tp,m,0,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetOperation(cm.imcop)
		Duel.RegisterEffect(e1,tp)
	end
	return true
end
function cm.imcop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(nil,0,LOCATION_REMOVED,0,nil):RandomSelect(0,1)
	local g2=Duel.GetMatchingGroup(nil,1,LOCATION_REMOVED,0,nil):RandomSelect(1,1)
	Duel.SendtoGrave(Group.__add(g1,g2),REASON_EFFECT+REASON_RETURN)
	Duel.ResetFlagEffect(tp,m)
	e:Reset()
end 
