local m=15005902
local cm=_G["c"..m]
cm.name="狂音主的存在"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--target
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.tg)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,1)
	e2:SetTarget(cm.efilter)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(cm.disable)
	c:RegisterEffect(e5)
end
function cm.filter(c)
	return c:IsAbleToGrave() or aux.NegateMonsterFilter(c)
end
function cm.tgfilter(c,e)
	return c:IsCanBeEffectTarget(e) and (c:IsAbleToGrave() or aux.NegateMonsterFilter(c))
end
function cm.tgfilter1(c,g)
	return c:IsAbleToGrave() and g:IsExists(aux.NegateMonsterFilter,1,c)
end
function cm.fselect(g)
	return g:IsExists(cm.tgfilter1,1,nil,g) and g:GetClassCount(Card.GetControler)==2
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if chkc then return false end
	if chk==0 then return g:CheckSubGroup(cm.fselect,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,2,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,sg,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local dc=g:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil):GetFirst()
	if not dc then return end
	g:RemoveCard(dc)
	local tc=g:GetFirst()
	Duel.SendtoGrave(dc,REASON_EFFECT)
	if dc:IsLocation(LOCATION_GRAVE) and tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function cm.efilter(e,c,rp,r,re)
	return c==e:GetHandler() and r&REASON_EFFECT>0
end
function cm.eftg(e,c)
	return c:IsDisabled() and c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function cm.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and c:IsControler(1-Duel.GetTurnPlayer()) and c:IsFaceup() and c:IsSetCard(0x6f43)
end