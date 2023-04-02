--虹彩之机界骑士
function c98920313.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c98920313.matfilter,1,1) 
--lv
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920313,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c98920313.tgcost)
	e2:SetTarget(c98920313.tgtg)
	e2:SetOperation(c98920313.tgop)
	c:RegisterEffect(e2)
--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920313,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c98920313.thcon)
	e3:SetTarget(c98920313.thtg)
	e3:SetOperation(c98920313.thop)
	c:RegisterEffect(e3)
end
function c98920313.matfilter(c)
	return c:IsLinkSetCard(0x10c) and not c:IsLinkType(TYPE_LINK)
end
function c98920313.filter(c)
	return c:IsSetCard(0x10c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c98920313.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920313.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920313.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c98920313.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetHandler():GetLink()
	if chk==0 then return lv>0 end
	local opt
	if e:GetLabelObject():GetAttack()>0 then
		opt=Duel.SelectOption(tp,aux.Stringid(98920313,2),aux.Stringid(98920313,3))
	else
		opt=Duel.SelectOption(tp,aux.Stringid(98920313,3))
	end
	e:SetLabel(opt)
end
function c98920313.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabelObject():GetAttack()
	local code=e:GetLabelObject():GetOriginalCode()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		if e:GetLabel()==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(code)
			c:RegisterEffect(e1)
			local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(98920313,4))
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetCountLimit(1)
			e2:SetRange(LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e2:SetLabelObject(e1)
			e2:SetLabel(cid)
			e2:SetOperation(c98920313.rstop)
			c:RegisterEffect(e2)
		end
	end
end
function c98920313.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c98920313.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c98920313.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98920313.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98920313.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920313.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c98920313.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c98920313.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end