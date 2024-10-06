--龙武装甲
local m=60002134
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_DRAW+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c) 
	return c:IsFaceup() and c:IsDefenseAbove(0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		Card.RegisterFlagEffect(c,60002134,RESET_EVENT+RESETS_STANDARD,0,1) --card 
		Duel.RegisterFlagEffect(tp,60002134,RESET_PHASE+PHASE_END,0,1) --ply t turn
		Duel.RegisterFlagEffect(tp,60002135,RESET_PHASE+PHASE_END,0,1000) --ply fore
		if Duel.GetFlagEffect(tp,60002134)>=2 then 
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		if Duel.GetFlagEffect(tp,60002134)>=4 then 
			Duel.Damage(1-tp,500,REASON_EFFECT)
			Duel.Recover(tp,500,REASON_EFFECT)
		end
	end
end











