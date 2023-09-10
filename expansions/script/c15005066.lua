local m=15005066
local cm=_G["c"..m]
cm.name="异闻鸣月·墨提斯"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,3,nil,nil,99)
	c:EnableReviveLimit()
	--pos and negate activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--pos or material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsCanTurnSet()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local b1=Duel.GetFlagEffect(tp,15005065)==0
		local b2=true
		if Duel.GetFlagEffect(tp,15005065)~=0 then
			for _,i in ipairs{Duel.GetFlagEffectLabel(tp,15005065)} do
				if i==re:GetHandler():GetControler() then b2=false end
			end
		end
		return c:GetFlagEffect(15005066)==0 and (b1 or b2)
	end
	c:RegisterFlagEffect(15005066,RESET_CHAIN,0,1)
	Duel.RegisterFlagEffect(tp,15005065,RESET_PHASE+PHASE_END,0,1,re:GetHandler():GetControler())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if tc:IsRelateToEffect(re) and tc:IsCanTurnSet() then
		if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 and Duel.IsChainDisablable(ev) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.NegateEffect(ev)
		end
	end
end
function cm.cfilter(c)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsFacedown() and c:IsLocation(LOCATION_MZONE)
end
function cm.mfilter(c)
	return c:IsSetCard(0xaf3e) and c:IsType(TYPE_XYZ) and c:IsRank(1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
		and e:GetHandler():GetOverlayGroup():IsExists(cm.mfilter,1,nil)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,1,0,0)
end
function cm.tmfilter(c)
	return c:IsCanOverlay() and c:IsFacedown()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.tmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if not (c:IsRelateToChain() and c:IsType(TYPE_XYZ)) then b2=false end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,3))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,4))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))
	end
	if s==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.ChangePosition(g:GetFirst(),POS_FACEUP_DEFENSE)
		end
	end
	if s==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mg=Duel.SelectMatchingCard(tp,cm.tmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if #mg>0 then
			Duel.HintSelection(mg)
			Duel.Overlay(c,mg)
		end
	end
end