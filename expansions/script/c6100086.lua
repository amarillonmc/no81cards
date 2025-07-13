--妮塔-悸响
local cm,m,o=GetID()
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),3,true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.defcon)
	e1:SetOperation(cm.defop)
	c:RegisterEffect(e1)
-- -赋予破坏抗性
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m, 1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1, m)
	e2:SetTarget(cm.indtg)
	e2:SetOperation(cm.indop)
	c:RegisterEffect(e2)
-- 效果③：守备力转换攻击力
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m, 2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1, m + 1)
	e3:SetCost(cm.atkcost)
	e3:SetOperation(cm.atkoper)
	c:RegisterEffect(e3)
end
function cm.defcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re and re:GetHandler():IsSetCard(0x661c) and rp==tp and e:GetHandler():GetFlagEffect(FLAG_ID_CHAINING)>0 and c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonLocation(LOCATION_EXTRA)
end
function cm.defop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local dice = Duel.TossDice(tp, 1)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(dice*100)
	e1:SetReset(RESET_EVENT + RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.indtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk == 0 then return Duel.IsExistingTarget(nil, tp, LOCATION_MZONE, 0, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	Duel.SelectTarget(tp, nil, tp, LOCATION_MZONE, 0, 1, 1, nil)
end
function cm.indop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		-- 赋予破坏抗性
		local e1 = Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(3008)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
		tc:RegisterEffect(e1)
		local e2 = e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
		
		-- 连锁对方效果时破坏对方卡片
		local ct=Duel.GetCurrentChain()
		local p,te=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_EFFECT) 
		if ct>1 and te:GetHandler():IsLocation(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK) and p==1-tp then
			Duel.Destroy(te:GetHandler(),REASON_EFFECT)
		end
	end
end
function cm.atkcost(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then return c:GetDefense() > 100 end
	local prevdef = c:GetDefense()
	e:SetLabel(prevdef - 100)  -- 存储下降的守备力数值
	-- 守备力变化效果
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetValue(100)
	e1:SetReset(RESET_EVENT + RESETS_STANDARD)
	c:RegisterEffect(e1)
end

-- 效果③：提升攻击力并赋予抗性
function cm.atkoper(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	-- 攻击力上升（下降的守备力数值）
	local gain = e:GetLabel()
	if gain > 0 then
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(gain)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	
	-- 本回合不会被破坏
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(3008)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
	c:RegisterEffect(e2)
	local e3 = e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
end