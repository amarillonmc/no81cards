--究极异兽-膨胀之爆肌蚊
function c40008598.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3,c40008598.ovfilter,aux.Stringid(40008598,0),3,c40008598.xyzop)
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008598,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c40008598.target)
	e1:SetOperation(c40008598.operation)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008598,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c40008598.condition)
	e2:SetCost(c40008598.cost)
	e2:SetOperation(c40008598.operation1)
	c:RegisterEffect(e2)	
end
function c40008598.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRank(3) and c:GetOverlayCount()>1
end
function c40008598.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40008598)==0 end
	Duel.RegisterFlagEffect(tp,40008598,RESET_PHASE+PHASE_END,0,1)
end
function c40008598.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if chk==0 then return tc and c:IsType(TYPE_XYZ) and not tc:IsType(TYPE_TOKEN) and tc:IsAbleToChangeControler() end
end
function c40008598.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c40008598.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local tc=c:GetOverlayCount()
	e:SetLabel(tc)
	e:GetHandler():RemoveOverlayCard(tp,tc,tc,REASON_COST)
end
function c40008598.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() and not e:GetHandler():IsHasEffect(EFFECT_ATTACK_ALL)
end
function c40008598.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end