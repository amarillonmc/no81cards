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
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.drcon)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and rp==tp and re:IsActiveType(TYPE_MONSTER)
		and loc&(LOCATION_HAND|LOCATION_GRAVE)>0 and Duel.IsChainDisablable(ev)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsDestructable() then Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0) end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		if (Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0)
			and Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(id,3))
			local zone=Duel.SelectDisableField(1-tp,1,LOCATION_MZONE,LOCATION_MZONE,0xe000e0)
			if 1-tp==1 then
				zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
			end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE_FIELD)
			e1:SetValue(zone)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,1-tp)
		end
	end
end
function s.get_dis_zone_count(p)
	local ct=0
	for i=0,4 do
		if not Duel.CheckLocation(p,LOCATION_MZONE,i) and not Duel.GetFieldCard(p,LOCATION_MZONE,i) then
			ct=ct+1
		end
	end
	return ct
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=s.get_dis_zone_count(tp)
	local ct2=s.get_dis_zone_count(1-tp)
	if chk==0 then return (ct1>0 and Duel.IsPlayerCanDraw(tp,ct1)) or (ct2>0 and Duel.IsPlayerCanDraw(1-tp,ct2)) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=s.get_dis_zone_count(tp)
	local ct2=s.get_dis_zone_count(1-tp)
	if ct1>0 and Duel.IsPlayerCanDraw(tp,ct1) then
		Duel.Draw(tp,ct1,REASON_EFFECT)
	end
	if ct2>0 and Duel.IsPlayerCanDraw(1-tp,ct2) then
		Duel.Draw(1-tp,ct2,REASON_EFFECT)
	end
end
