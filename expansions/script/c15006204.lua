local m=15006204
local cm=_G["c"..m]
cm.name="巡天之诗"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--battle
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+1)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
end
function cm.tgfilter(c,g)
	return c:IsSetCard(0x9f44) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and g:IsExists(cm.thfilter,1,c,c:GetCode())
end
function cm.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local dg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local sg=g:Filter(cm.tgfilter,nil,dg)
	if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local rc=sg:Select(tp,1,1,nil):GetFirst()
		if Duel.SendtoGrave(rc,REASON_EFFECT)~=0 and rc:IsLocation(LOCATION_GRAVE) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tc=dg:FilterSelect(tp,cm.thfilter,1,1,rc,rc:GetCode())
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
	Duel.ShuffleDeck(tp)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9f44) and c:IsType(TYPE_MONSTER) and c:GetFlagEffect(15006204)==0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:GetFlagEffect(15006204)==0 then
			tc:RegisterFlagEffect(15006204,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(0,1)
			e1:SetCondition(cm.actcon)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_PIERCE)
			e2:SetCondition(cm.effcon)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2,true)
		end
	end
end
function cm.actcon(e)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c) and c:GetBattleTarget()~=nil
		and e:GetOwnerPlayer()==e:GetHandlerPlayer()
end
function cm.effcon(e)
	return e:GetOwnerPlayer()==e:GetHandlerPlayer()
end