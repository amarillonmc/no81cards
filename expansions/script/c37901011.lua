--机娘·「刃甲」
local m=37901011
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x388),4,2)
	c:EnableReviveLimit()
--e1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local bc=c:GetBattleTarget()
		return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle()
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		local bc=e:GetHandler():GetBattleTarget()
		Duel.SetTargetPlayer(1-tp)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,bc:GetAttack()/2)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local bc=c:GetBattleTarget()
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
			local dam=bc:GetAttack()/2
			if dam>0 then Duel.Damage(p,dam,REASON_EFFECT) end
		end
	end)
	c:RegisterEffect(e1)
--e2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
			and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
		if Duel.SelectEffectYesNo(tp,c,96) then
			c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
			return true
		else return false end
	end)
	c:RegisterEffect(e2)
--e3
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1,m)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.tf3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local c=e:GetHandler()
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tf3),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,c)
		local tc=g:GetFirst()
		if c:IsType(TYPE_XYZ) and tc:IsCanOverlay() then
			Duel.Overlay(c,Group.FromCards(tc))
		end
	end)
	c:RegisterEffect(e3)
end
--e3
function cm.tf3(c,mc)
	return c:IsSetCard(0x388) and mc:IsType(TYPE_XYZ) and c:IsCanOverlay() and c:IsType(TYPE_MONSTER)
end