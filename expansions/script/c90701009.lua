local m=90701009
local cm=_G["c"..m]
cm.name="四世坏的牙掌突"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.adatktg)
	e2:SetOperation(cm.adatkop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.activate)
	c:RegisterEffect(e3)
end
function cm.filter(c,e,tp)
	return (c:IsSetCard(0x9316) or c:IsCode(90701015)) and c:IsFaceup() and not c:IsType(TYPE_LINK)
end
function cm.adatktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetTurnPlayer()==tp and aux.bpcon(e,tp,eg,ep,ev,re,r,rp) and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function cm.adatkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(cm.adaval)
	tc:RegisterEffect(e1)
end
function cm.adaval(e)
	local c=e:GetHandler()
	return c:GetAttack()>c:GetDefense() and 0 or 1
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.actfilter(c)
	return c:IsCode(90701015) and c:IsFaceup()
end
function cm.desfilter(c,check)
	return check or c:IsAbleToRemove()
end
function cm.descfilter(c,tc,ec,check)
	return cm.desfilter(c,check) and c:GetEquipTarget()~=tc and c~=ec
end
function cm.costfilter(c,ec,tp,check)
	if not c:IsSetCard(0x9316) then return false end
	return Duel.IsExistingTarget(cm.descfilter,tp,0,LOCATION_ONFIELD,2,c,c,ec,check)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local check=not Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_ONFIELD,0,1,nil)
	if chkc then return chkc:IsOnField() and chkc~=c and cm.desfilter(chkc,check) end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroup(tp,cm.costfilter,1,c,c,tp,check)
		else
			return Duel.IsExistingTarget(cm.desfilter,tp,0,LOCATION_ONFIELD,2,c,check)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local sg=Duel.SelectReleaseGroup(tp,cm.costfilter,1,1,c,c,tp,check)
		Duel.Release(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,0,LOCATION_ONFIELD,2,2,c,check)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
	else
		Duel.Destroy(sg,REASON_EFFECT)
	end
end