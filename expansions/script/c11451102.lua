--妄想咒阈 单电子宇宙
--23.07.01
local cm,m=GetID()
function cm.initial_effect(c)
	--One-electron Universe
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(cm.cfilter,1,nil,1-tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCard(tp)
		c:SetHint(CHINT_CARD,ac)
		c:RegisterFlagEffect(m+ac,RESET_EVENT+RESETS_STANDARD,0,1)
		if c:GetFlagEffect(m)==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EVENT_ADJUST)
			e1:SetOperation(cm.rmop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end
function cm.rfilter(c,tp,sc)
	return c:IsAbleToRemove(1-tp,POS_FACEDOWN) and sc:GetFlagEffect(m+c:GetCode())>0
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL or c:IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsPlayerCanRemove(1-tp) then return end
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK,nil,tp,c)
	local tg=g:Filter(Card.IsImmuneToEffect,nil,e)
	if #g>1 then
		if #tg==0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			tg=g:Select(1-tp,1,1,nil)
		end
		g:Sub(tg)
		Duel.ConfirmCards(tp,g)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		Duel.Readjust()
	end
end