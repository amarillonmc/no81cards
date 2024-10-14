--魔导喷气背包 训练型
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--faceup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(function() return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end)
	e3:SetOperation(cm.operation1)
	c:RegisterEffect(e3)
	--Equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_ACTIVATING)
		ge2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
		ge2:SetOperation(cm.chkop)
		Duel.RegisterEffect(ge2,0)
	end
end
cm.toss_coin=true
function cm.chkop(e,tp,eg,ep,ev,re,r,rp)
	--if not e:GetHandler():IsOnField() then return end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,e,r,rp,ep,ev)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if tc and tc:IsAbleToDeck() and c:IsAbleToHand() and Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		if tc:IsLocation(LOCATION_MZONE) then
			local res1,res2=Duel.TossCoin(tp,2)
			if res1~=res2 then res1=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,0)) end
			if tc:IsLocation(LOCATION_MZONE) and Duel.SendtoDeck(tc,nil,0,REASON_EFFECT) and tc:IsLocation(LOCATION_DECK) and res1==1 then
				Duel.ShuffleDeck(tc:GetControler())
				tc:ReverseInDeck()
			end
		end
	end
end
function cm.fdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFacedown()
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.fdfilter,tp,LOCATION_DECK,0,1,1,nil,TYPE_MONSTER)
	if #g>0 then
		local tc=g:GetFirst()
		Duel.ShuffleDeck(tp)
		tc:ReverseInDeck()
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,c:GetFieldID(),aux.Stringid(m,2))
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,c:GetFieldID())
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetOperation(cm.fop)
		e1:SetLabel(c:GetFieldID())
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.fop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if not (c:GetFlagEffect(m)>0 and c:GetFlagEffectLabel(m)==e:GetLabel() and tc:GetFlagEffect(m)>0 and tc:GetFlagEffectLabel(m)==e:GetLabel()) then e:Reset() return end
	if eg:IsContains(tc) and tc:IsPreviousLocation(LOCATION_DECK) then
		e:Reset()
		if tc:IsFaceup() then Duel.Equip(tp,c,tc) end
	end  
end