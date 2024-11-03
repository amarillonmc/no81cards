--T旋爆裂！
if not c71403001 then dofile("expansions/script/c71403001.lua") end
function c71403006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71403006,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION+CATEGORY_DESTROY)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c71403006.con1)
	e1:SetCost(yume.PPTLimitCost)
	e1:SetTarget(c71403006.tg1)
	e1:SetOperation(c71403006.op1)
	c:RegisterEffect(e1)
	yume.RegPPTSTGraveEffect(c,71403006)
	yume.PPTCounter()
end
function c71403006.con1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainDisablable(ev)
end
function c71403006.filter1(c)
	return c:GetSequence()<5 and c:IsFaceup() and c:IsSetCard(0x715) and c:IsCanChangePosition()
end
function c71403006.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c71403006.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71403006.filterp2a,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c71403006.filterp2b,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c71403006.filterp2a,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c71403006.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)
		and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0
		and Duel.NegateEffect(ev) then
		local rc=re:GetHandler()
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71403006,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=g:Select(tp,1,2,nil)
			sg:AddCard(tc)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end