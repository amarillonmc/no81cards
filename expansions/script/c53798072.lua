local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.negcon)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.drwcon)
	e2:SetTarget(s.drwtg)
	e2:SetOperation(s.drwop)
	c:RegisterEffect(e2)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
		and loc&(LOCATION_HAND|LOCATION_GRAVE)>0 and Duel.IsChainDisablable(ev)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsDestructable() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		--Afterwards, the opponent can designate 1 unused Main Monster Zone
		local op=1-tp
		--Check if there is ANY unused MMZ on either field
		if (Duel.GetLocationCount(op,LOCATION_MZONE)>0 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
			and Duel.SelectYesNo(op,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,op,HINTMSG_ZONE)
			--SelectDisableField(player, count, self_loc, opp_loc, filter)
			--Filter 0xe000e0 excludes Extra Monster Zones (bit 5,6,7) for both players 
			local zone=Duel.SelectDisableField(op,1,LOCATION_MZONE,LOCATION_MZONE,0xe000e0)
			--Convert zone bitmask if player 1 selected, to match global EFFECT_DISABLE_FIELD format
			if op==1 then
				zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
			end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE_FIELD)
			e1:SetValue(zone)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.drwcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.count_unusable(p)
	local ct=0
	--Check Main Monster Zones 0-4
	for i=0,4 do
		--If location is NOT checkable (unusable) AND there is NO card there, it's a disabled zone
		if not Duel.CheckLocation(p,LOCATION_MZONE,i) and not Duel.GetFieldCard(p,LOCATION_MZONE,i) then
			ct=ct+1
		end
	end
	return ct
end
function s.drwtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct1=s.count_unusable(tp)
	local ct2=s.count_unusable(1-tp)
	local d1=ct1>0 and Duel.IsPlayerCanDraw(tp,ct1)
	local d2=ct2>0 and Duel.IsPlayerCanDraw(1-tp,ct2)
	if d1 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct1)
	end
	if d2 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,ct2)
	end
end
function s.drwop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=s.count_unusable(tp)
	local ct2=s.count_unusable(1-tp)
	if ct1>0 and Duel.IsPlayerCanDraw(tp,ct1) then
		Duel.Draw(tp,ct1,REASON_EFFECT)
	end
	if ct2>0 and Duel.IsPlayerCanDraw(1-tp,ct2) then
		Duel.Draw(1-tp,ct2,REASON_EFFECT)
	end
end