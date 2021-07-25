local m=70700010
local cm=_G["c"..m]
cm.name="能力者的效果变换"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.changeop)
	c:RegisterEffect(e2)
end
function cm.tgfilter(c)
	return c:IsSetCard(0x92b)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsPlayerCanDiscardDeck(tp,3) then
		Duel.ConfirmDecktop(tp,3)
		Duel.SendtoGrave(Duel.GetDecktopGroup(tp,3):Filter(cm.tgfilter,nil),REASON_EFFECT+REASON_REVEAL)
	end
end
function cm.changeop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)>0 then return end
	local ex_1,tg_1=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	local s1=(ex_1 and tg_1~=nil and tg_1:IsExists(Card.IsType,1,nil,TYPE_MONSTER))
	local ex_2,tg_2=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	local s2=(ex_2 and tg_2~=nil and tg_2:IsExists(Card.IsType,1,nil,TYPE_MONSTER))
	local ex_3,tg_3=Duel.GetOperationInfo(ev,CATEGORY_TODECK)
	local s3=(ex_3 and tg_3~=nil and tg_3:IsExists(Card.IsType,1,nil,TYPE_MONSTER))
	if not (s1 or s2 or s3) then return false end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,3)) then return false end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	local op
	if s1 then
		if s2 then
			if s3 then
				op=1+Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2))
				e:SetLabel(op+1)
			else
				op=1+Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
			end
		else
			if s3 then
				op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,2))
				if op==0 then op=1 end
				if op==1 then op=3 end
			else
				op=1
			end
		end
	else
		if s2 then
			if s3 then
				op=2+Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
			else
				op=2
			end
		else
			op=3
		end
	end
	Duel.Hint(HINT_CARD,0,m)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	if op==1 then Duel.ChangeChainOperation(ev,cm.changedop_1) end
	if op==2 then Duel.ChangeChainOperation(ev,cm.changedop_2) end
	if op==3 then Duel.ChangeChainOperation(ev,cm.changedop_3) end
end
function cm.filter_1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.changedop_1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,cm.filter_1,tp,0,LOCATION_ONFIELD,1,2,nil)
	if g:GetCount()~=0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function cm.filter_2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function cm.changedop_2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,cm.filter_2,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,2,nil)
	if g:GetCount()~=0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.filter_3(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function cm.changedop_3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,cm.filter_3,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,2,nil)
	if g:GetCount()~=0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end