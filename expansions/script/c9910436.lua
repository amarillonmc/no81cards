--星极
function c9910436.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910436)
	e1:SetTarget(c9910436.desreptg)
	e1:SetValue(c9910436.desrepval)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910437)
	e2:SetCondition(c9910436.discon)
	e2:SetTarget(c9910436.distg)
	e2:SetOperation(c9910436.disop)
	c:RegisterEffect(e2)
	local ng=Group.CreateGroup()
	ng:KeepAlive()
	e2:SetLabelObject(ng)
	e1:SetLabelObject(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9910436.sumsuc)
	c:RegisterEffect(e8)
end
function c9910436.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9910436,0))
end
function c9910436.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c9910436.filter(c)
	return c:GetFlagEffect(9910436)~=0
end
function c9910436.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,2)
	if chk==0 then return eg:IsExists(c9910436.repfilter,1,nil,tp)
		and g:FilterCount(Card.IsAbleToRemove,nil)==2 end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_CARD,0,9910436)
		Duel.Hint(HINT_SOUND,0,aux.Stringid(9910436,1))
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local rg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		if rg:GetCount()>0 then
			local sc=rg:GetFirst()
			while sc do
				sc:RegisterFlagEffect(9910436,RESET_EVENT+RESETS_STANDARD,0,0)
				e:GetLabelObject():SetLabel(1)
				if c:GetFlagEffect(9910436)==0 then
					c:RegisterFlagEffect(9910436,RESET_EVENT+RESETS_STANDARD,0,0)
					e:GetLabelObject():GetLabelObject():Clear()
				end
				e:GetLabelObject():GetLabelObject():AddCard(sc)
				sc=rg:GetNext()
			end
		end
		return true
	else return false end
end
function c9910436.desrepval(e,c)
	return c9910436.repfilter(c,e:GetHandlerPlayer())
end
function c9910436.tfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp)
end
function c9910436.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c9910436.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
		and e:GetLabel()==1 and e:GetHandler():GetFlagEffect(9910436)
end
function c9910436.thfilter(c)
	return c:GetFlagEffect(9910436)~=0 and c:IsAbleToHand()
end
function c9910436.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=e:GetLabelObject()
	if chk==0 then return rg:IsExists(c9910436.thfilter,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9910436.disop(e,tp,eg,ep,ev,re,r,rp)
	local rg=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=rg:FilterSelect(tp,c9910436.thfilter,1,1,nil)
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SOUND,0,aux.Stringid(9910436,2))
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
