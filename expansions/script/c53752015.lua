local m=53752015
local cm=_G["c"..m]
cm.name="冥海的低声呼唤"
function cm.initial_effect(c)
	aux.AddCodeList(c,22702055)
	aux.EnableChangeCode(c,22702055,LOCATION_SZONE+LOCATION_GRAVE)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TUNER)
end
function cm.filter(c,tc)
	if not c:IsType(TYPE_MONSTER) then return false end
	local res1=(tc:GetFlagEffect(m)<1 and c:IsAbleToDeck())
	local res2=(tc:GetFlagEffect(m+50)<1 and c:IsLevelAbove(1))
	if c:IsLocation(LOCATION_GRAVE) and (res1 or res2) then return true end
	return c:IsFaceup() and ((c:IsLocation(LOCATION_MZONE) and res2) or (c:IsLocation(LOCATION_REMOVED) and res1))
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED) and cm.filter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,1,nil,c) end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sc=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,c):GetFirst()
	if sc:IsLocation(LOCATION_MZONE) then op=1 elseif sc:IsLocation(LOCATION_GRAVE) then
		local res1=(c:GetFlagEffect(m)<1 and sc:IsAbleToDeck())
		local res2=(c:GetFlagEffect(m+50)<1 and sc:IsLevelAbove(1))
		if res1 and res2 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2)) elseif res1 then op=0 else op=1 end
	end
	Duel.SetTargetParam(op)
	if op==0 then
		e:SetCategory(CATEGORY_TODECK)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,7))
		c:ResetFlagEffect(m+50)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,sc,1,0,0)
	elseif op==1 then
		e:SetCategory(0)
		c:RegisterFlagEffect(m+50,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,8))
		c:ResetFlagEffect(m)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local op=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if op==0 then Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) elseif tc:IsFaceup() then
		local sel=0
		if tc:IsLevel(1) then sel=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4)) elseif tc:IsLevel(2) then sel=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4),aux.Stringid(m,5)) else sel=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4),aux.Stringid(m,5),aux.Stringid(m,6)) end
		if sel>1 then sel=-sel end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1+sel)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
