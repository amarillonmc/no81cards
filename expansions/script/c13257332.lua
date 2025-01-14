--超时空填充胶囊
local m=13257332
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.tdcon)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e3)
	
end
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x351)
end
function cm.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SOUND,0,aux.Stringid(m,7))
		Duel.Draw(tp,1,REASON_EFFECT)
		if Duel.GetFlagEffect(tp,m)>=1 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e1)
		end
		if Duel.GetFlagEffect(tp,m)>=2 then
			if tc:GetFlagEffect(m)==0 then
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetDescription(aux.Stringid(m,0))
				e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
				e2:SetValue(1)
				e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
				tc:RegisterEffect(e2)
			end
		end
		if Duel.GetFlagEffect(tp,m)>=3 then
			local code=tc:GetCode()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SOUND,0,aux.Stringid(m-1,7))
				Duel.SendtoHand(g,tp,REASON_EFFECT)
			end
		end
	end
end
function cm.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
end
