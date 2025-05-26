--海德拉型：猎兽之王
local m=91300034
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,10,5,nil,nil,99)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c91300034.specon)
	e1:SetOperation(c91300034.speop)
	c:RegisterEffect(e1)
	--feilong
		--immune+count
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE)
	e20:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e20:SetRange(LOCATION_MZONE)
	e20:SetCode(EFFECT_IMMUNE_EFFECT)
	e20:SetCondition(c91300034.flfzcon)
	e20:SetValue(c91300034.efilter)
	c:RegisterEffect(e20)
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCode(EVENT_MOVE)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCondition(c91300034.flfzcon)
	e21:SetOperation(c91300034.flfcop)
	c:RegisterEffect(e21)
		--Removehand
	local e23=Effect.CreateEffect(c)
	e23:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e23:SetProperty(EFFECT_FLAG_DELAY)
	e23:SetCode(EVENT_SPSUMMON_SUCCESS)
	e23:SetRange(LOCATION_MZONE)
	e23:SetCondition(c91300034.flfzcon)
	e23:SetOperation(c91300034.spcop)
	c:RegisterEffect(e23)
	local e24=Effect.CreateEffect(c)
	e24:SetDescription(aux.Stringid(91300032,0))
	e24:SetCategory(CATEGORY_REMOVE)
	e24:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e24:SetRange(LOCATION_MZONE)
	e24:SetCode(EVENT_SPSUMMON_SUCCESS)
	e24:SetCondition(c91300034.rmhconfz)
	e24:SetCost(c91300034.toexcost)
	e24:SetTarget(c91300034.rmhtg)
	e24:SetOperation(c91300034.rmhop)
	c:RegisterEffect(e24)
	--rmoeve trigger
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCost(c91300034.rmmcost)
	e4:SetTarget(c91300034.rmmtg)
	e4:SetOperation(c91300034.rmmop)
	c:RegisterEffect(e4)
	--weizhi
	local e51=Effect.CreateEffect(c)
	e51:SetType(EFFECT_TYPE_FIELD)
	e51:SetCode(EFFECT_SET_POSITION)
	e51:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e51:SetRange(LOCATION_MZONE)
	e51:SetCondition(c91300034.con5)
	e51:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e51:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e51)
	local e52=e51:Clone()
	e52:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e52)
   --immune
	local e53=Effect.CreateEffect(c)
	e53:SetType(EFFECT_TYPE_SINGLE)
	e53:SetCode(EFFECT_IMMUNE_EFFECT)
	e53:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e53:SetRange(LOCATION_MZONE)
	e53:SetValue(c91300034.efilter)
	c:RegisterEffect(e53)
	--must attack
	local e54=Effect.CreateEffect(c)
	e54:SetType(EFFECT_TYPE_FIELD)
	e54:SetCode(EFFECT_MUST_ATTACK)
	e54:SetRange(LOCATION_MZONE)
	e54:SetTargetRange(0,LOCATION_MZONE)
	e54:SetTarget(c91300034.atktg)
	c:RegisterEffect(e54)
	local e55=e54:Clone()
	e55:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e55:SetValue(c91300034.atklimit)
	c:RegisterEffect(e55)
	local e56=Effect.CreateEffect(c)
	e56:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e56:SetCode(EVENT_CHAIN_SOLVING)
	e56:SetRange(LOCATION_MZONE)
	e56:SetCondition(c91300034.discon5)
	e56:SetOperation(c91300034.disop5)
	c:RegisterEffect(e56)
	--jiake
		--weifeng
	local e60=Effect.CreateEffect(c)
	e60:SetType(EFFECT_TYPE_SINGLE)
	e60:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e60:SetRange(LOCATION_MZONE)
	e60:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e60:SetCondition(c91300034.jkfzcon)
	e60:SetValue(aux.tgoval)
	c:RegisterEffect(e60)
	local e61=Effect.CreateEffect(c)
	e61:SetType(EFFECT_TYPE_SINGLE)
	e61:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e61:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e61:SetRange(LOCATION_MZONE)
	e61:SetCondition(c91300034.jkfzcon)
	e61:SetValue(aux.indoval)
	c:RegisterEffect(e61)
	local e62=Effect.CreateEffect(c)
	e62:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e62:SetProperty(EFFECT_FLAG_DELAY)
	e62:SetCode(EVENT_LEAVE_FIELD)
	e62:SetRange(LOCATION_MZONE)
	e62:SetCondition(c91300034.jkfzcon)
	e62:SetOperation(c91300034.jkfcop)
	c:RegisterEffect(e62)
		--endtime
	local e63=Effect.CreateEffect(c)
	e63:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e63:SetProperty(EFFECT_FLAG_DELAY)
	e63:SetCode(EVENT_CHAINING)
	e63:SetRange(LOCATION_MZONE)
	e63:SetCondition(c91300034.jkfzcon)
	e63:SetOperation(c91300034.fdcop)
	c:RegisterEffect(e63)
	local e64=Effect.CreateEffect(c)
	e64:SetDescription(aux.Stringid(91300033,0))
	e64:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e64:SetRange(LOCATION_MZONE)
	e64:SetCode(EVENT_CHAINING)
	e64:SetCondition(c91300034.fzetcon)
	e64:SetCost(c91300034.toexcost)
	e64:SetOperation(c91300034.etop)
	c:RegisterEffect(e64)
	--haidela
		--imm t/s
	local e70=Effect.CreateEffect(c)
	e70:SetType(EFFECT_TYPE_SINGLE)
	e70:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e70:SetRange(LOCATION_MZONE)
	e70:SetCode(EFFECT_IMMUNE_EFFECT)
	e70:SetValue(c91300034.tsefilter)
	c:RegisterEffect(e70)
	local e71=Effect.CreateEffect(c)
	e71:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e71:SetProperty(EFFECT_FLAG_DELAY)
	e71:SetCode(EVENT_MOVE)
	e71:SetRange(LOCATION_MZONE)
	e71:SetOperation(c91300034.hdlfcop)
	c:RegisterEffect(e71)
	local e74=e71:Clone()
	e74:SetCondition(c91300034.hdlfzcon)
	c:RegisterEffect(e74)
		--alltograve
	local e72=Effect.CreateEffect(c)
	e72:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e72:SetProperty(EFFECT_FLAG_DELAY)
	e72:SetCode(EVENT_TO_HAND)
	e72:SetRange(LOCATION_MZONE)
	e72:SetCondition(c91300034.thcon)
	e72:SetOperation(c91300034.thcop)
	c:RegisterEffect(e72)
	local e73=Effect.CreateEffect(c)
	e73:SetDescription(aux.Stringid(91300034,0))
	e73:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e73:SetRange(LOCATION_MZONE)
	e73:SetCode(EVENT_TO_HAND)
	e73:SetCondition(c91300034.tgcon)
	e73:SetCost(c91300034.toexcost)
	e73:SetTarget(c91300034.tgtg)
	e73:SetOperation(c91300034.tgop)
	c:RegisterEffect(e73)
	local e74=e73:Clone()
	e74:SetCondition(c91300034.fztgcon)
	c:RegisterEffect(e74)
	
end
c91300034.hackclad=1
function c91300034.efilter(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) or (te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)) or (_G["c"..c:GetCode()] and _G["c"..c:GetCode()].hackclad) then return false
	end
	return e:GetHandler()~=te:GetOwner()
end
function c91300034.atktg(e,c)
	return c:IsType(TYPE_MONSTER) and _G["c"..c:GetCode()] and _G["c"..c:GetCode()].hackclad
end
function c91300034.atklimit(e,c)
	return c==e:GetHandler()
end
function c91300034.specon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c91300034.tdfilter(c)
	return c.hackclad==1 and c:IsAbleToDeck()
end
function c91300034.speop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if g:IsExists(c91300034.tdfilter,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=g:FilterSelect(tp,c91300034.tdfilter,1,1,nil)
		local rc=tg:GetFirst()
		if rc and Duel.SendtoDeck(rc,nil,SEQ_DECKTOP,REASON_EFFECT)~=0 and rc:IsLocation(0x41) then
			local og=Duel.GetOperatedGroup()
			local tc=og:GetFirst()
			if tc and (tc:IsCode(91300025) or tc:IsCode(91300032) or tc:IsCode(91300033) or tc:IsCode(91300034)) then
				c:RegisterFlagEffect(91301025,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(91300032,3))
				Duel.ShuffleDeck(tp)
			end
			--[[if tc and tc:IsCode(91300032) then
				c:RegisterFlagEffect(91301032,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(91300032,4))
			end
			if tc and tc:IsCode(91300033) then
				c:RegisterFlagEffect(91301033,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(91300032,5))
			end
			if tc and tc:IsCode(91300034) then
				c:RegisterFlagEffect(91301034,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(91300032,6))
			end]]
		end
	end
end
function c91300034.efilter(e,te,ev)
	return te:IsActiveType(TYPE_MONSTER) and (Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE or  Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_GRAVE or Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_REMOVED)
end
function c91300034.flfcopfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsPreviousControler(1-tp)
end
function c91300034.flfzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffectLabel(91301032)
end
function c91300034.flfcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(c91300034.flfcopfilter,1,nil,tp) then
		c:AddCounter(0x1614,1)
		local flag=c:GetFlagEffectLabel(25824)
		if flag then
			c:SetFlagEffectLabel(25824,flag+1)
		else
			c:RegisterFlagEffect(25824,RESET_EVENT+RESETS_STANDARD,0,1,1)
		end
	end
end
function c91300034.spcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if tc and tc~=c then
		local flag=c:GetFlagEffectLabel(91300032)
		if flag then
			c:SetFlagEffectLabel(91300032,flag+1)
		else
			c:RegisterFlagEffect(91300032,RESET_EVENT+RESETS_STANDARD,0,1,1)
		end
	end
end
function c91300034.rmhcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=c:GetFlagEffectLabel(91300032)
	return flag and flag>3
end
function c91300034.rmhconfz(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=c:GetFlagEffectLabel(91300032)
	return flag and flag>3 and c:GetFlagEffectLabel(91301032)
end
function c91300034.toexcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() and c:GetFlagEffectLabel(25824) and c:GetFlagEffectLabel(25824)<5 end
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_COST)
end
function c91300034.rmhtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,LOCATION_HAND)
end
function c91300034.rmhop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		Duel.HintSelection(g)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			local og=Duel.GetOperatedGroup()
			local tc=og:GetFirst()
			while tc do
				tc:RegisterFlagEffect(91302032,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
				tc=og:GetNext()
			end
			og:KeepAlive()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(og)
			e1:SetCountLimit(1)
			e1:SetCondition(c91300034.retcon)
			e1:SetOperation(c91300034.retop)
			Duel.RegisterEffect(e1,tp)
	end
end
function c91300034.retfilter(c)
	return c:GetFlagEffect(91302032)~=0
end
function c91300034.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(c91300034.retfilter,nil)
	return g:GetCount()>0
end
function c91300034.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(c91300034.retfilter,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c91300034.rmmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_COST)
end
function c91300034.rmmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,5) end
end
function c91300034.rmmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(1-tp,5) then
		local g=Duel.GetDecktopGroup(1-tp,5)
			Duel.ConfirmCards(1-tp,g)
			Duel.ConfirmCards(tp,g)
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			if g:IsExists(Card.IsAbleToHand,2,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(1-tp,Card.IsAbleToHand,1,1,nil)
				g:Sub(sg)
				local sg2=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
				Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
				Duel.ConfirmCards(tp,sg)
				Duel.SendtoHand(sg2,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg2)
				Duel.ShuffleHand(1-tp)
				Duel.ShuffleHand(tp)
				g:Sub(sg2)
			end
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		end
	end
end

--weizhi-----------------------------------------------------------------------------------


function c91300034.con5(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and c:GetFlagEffectLabel(91301025)
end
function c91300034.discon5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	seq=aux.MZoneSequence(seq)
	return c:GetFlagEffectLabel(91301025) and rp==1-tp and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE
		and seq==4-aux.MZoneSequence(c:GetSequence())
		and re:IsHasProperty(EFFECT_FLAG_PLAYER_TARGET)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,c)
end
function c91300034.disop5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(91300025,0)) then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
		local p=Duel.GetChainInfo(ev,CHAININFO_TARGET_PLAYER)
		Duel.ChangeTargetPlayer(ev,1-p)
	end
end

--jiake-----------------------------------------------------------------------------------------------------------


function c91300034.jkfzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffectLabel(91301033)
end
function c91300034.jkfcopfilter(c,tp)
	return c:IsPreviousControler(1-tp)
end
function c91300034.jkfcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(c91300034.jkfcopfilter,1,nil,tp) then
		c:AddCounter(0x1614,1)
		local flag=c:GetFlagEffectLabel(25824)
		if flag then
			c:SetFlagEffectLabel(25824,flag+1)
		else
			c:RegisterFlagEffect(25824,RESET_EVENT+RESETS_STANDARD,0,1,1)
		end
	end
end
function c91300034.fdcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) then
		local flag=c:GetFlagEffectLabel(91300033)
		if flag then
			c:SetFlagEffectLabel(91300033,flag+1)
		else
			c:RegisterFlagEffect(91300033,RESET_EVENT+RESETS_STANDARD,0,1,1)
		end
	end
end
function c91300034.fzetcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=c:GetFlagEffectLabel(91300033)
	return flag and flag>3 and c:GetFlagEffectLabel(91301033)
end
function c91300034.etop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(Duel.GetTurnPlayer(),Duel.GetCurrentPhase(),RESET_PHASE+PHASE_END,1)
end

--haidela-----------------------------------------------------------------------------------------------------------


function c91300034.hdlfzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffectLabel(91301034)
end
function c91300034.tsefilter(e,te,ev)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c91300034.hdlfcopfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsPreviousControler(1-tp)
end
function c91300034.hdlfcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(c91300034.hdlfcopfilter,1,nil,tp) then
		c:AddCounter(0x1614,1)
		local flag=c:GetFlagEffectLabel(25824)
		if flag then
			c:SetFlagEffectLabel(25824,flag+1)
		else
			c:RegisterFlagEffect(25824,RESET_EVENT+RESETS_STANDARD,0,1,1)
		end
	end
end
function c91300034.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp) 
end
function c91300034.thcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=c:GetFlagEffectLabel(91300034)
	if flag then
		c:SetFlagEffectLabel(91300034,flag+1)
	else
		c:RegisterFlagEffect(91300034,RESET_EVENT+RESETS_STANDARD,0,1,1)
	end
end
function c91300034.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=c:GetFlagEffectLabel(91300034)
	return flag and flag>3
end
function c91300034.fztgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=c:GetFlagEffectLabel(91300034)
	return flag and flag>3 and c:GetFlagEffectLabel(91301034)
end
function c91300034.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,LOCATION_ONFIELD)
end
function c91300034.tgop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
