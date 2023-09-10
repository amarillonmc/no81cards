local m=15005061
local cm=_G["c"..m]
cm.name="异闻鸣宙-木卫蚀"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,15005061+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.rmfilter(c)
	return (c:IsSetCard(0xaf3e) or c:IsFacedown()) and c:IsType(TYPE_MONSTER)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,1-tp,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,tp,LOCATION_MZONE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local x=Duel.Destroy(tc,REASON_EFFECT)
		if x==0 then
			local b1=Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil)
			local b2=Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,0,1,nil)
			if not (b1 or b2) then return end
			if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
			local s=0
			if b1 and not b2 then
				s=Duel.SelectOption(tp,aux.Stringid(m,1))
			end
			if not b1 and b2 then
				s=Duel.SelectOption(tp,aux.Stringid(m,2))+1
			end
			if b1 and b2 then
				s=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
			end
			Duel.BreakEffect()
			if s==0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
				local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_MZONE,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.HintSelection(g)
					Duel.ChangePosition(g:GetFirst(),POS_FACEUP_DEFENSE)
				end
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
				local g=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,LOCATION_MZONE,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.HintSelection(g)
					Duel.ChangePosition(g:GetFirst(),POS_FACEDOWN_DEFENSE)
				end
			end
		end
	end
end