--超时空武装 副武-天狗相机
local m=13257351
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(cm.eqlimit)
	c:RegisterEffect(e11)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(100)
	c:RegisterEffect(e2)
	--equip bomb
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(cm.bombcost)
	e4:SetTarget(cm.bombtg)
	e4:SetOperation(cm.bombop)
	c:RegisterEffect(e4)
	eflist={"bomb",e4}
	cm[c]=eflist
	
end
function cm.eqlimit(e,c)
	return not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x6352)
end
function cm.bfilter(c)
	return c:IsAbleToChangeControler() and c:IsFaceup()
end
function cm.bombcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec and ec:IsCanRemoveCounter(tp,0x351,1,REASON_COST) end
	ec:RemoveCounter(tp,0x351,1,REASON_COST)
end
function cm.bombtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ec=e:GetHandler():GetEquipTarget()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and ec and cm.bfilter(chkc) end
	if chk==0 then return ec and Duel.IsExistingTarget(cm.bfilter,tp,0,LOCATION_ONFIELD,1,nil,ec) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cm.bfilter,tp,0,LOCATION_ONFIELD,1,1,nil,ec)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cm.bombop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=e:GetHandler():GetEquipTarget()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) or not ec then return end
	if ec and ec:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
		if tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND) then return end
		Duel.BreakEffect()
		if not Duel.Equip(tp,tc,ec,false) then return end
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(ec)
		e1:SetValue(cm.eqlimit2)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetRange(LOCATION_SZONE)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetCountLimit(1)
		e2:SetCondition(cm.phcon)
		e2:SetOperation(cm.phop)
		tc:RegisterEffect(e2)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(cm.efilter1)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
		ec:RegisterEffect(e4,true)
	else Duel.SendtoGrave(tc,REASON_RULE) end
end
function cm.phcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetEquipTarget()
end
function cm.phop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsAbleToDeck() then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cm.eqlimit2(e,c)
	return e:GetLabelObject()==c
end
function cm.efilter1(e,re)
	return e:GetHandler()~=re:GetHandler()
end
