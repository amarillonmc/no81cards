--疾行机人
function c98920448.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x16),2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c98920448.dircon)
	c:RegisterEffect(e1)
--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c98920448.target)
	e1:SetOperation(c98920448.activate)
	c:RegisterEffect(e1)
end
function c98920448.dircon(e)
	return e:GetHandler():GetColumnGroupCount()==0
end
function c98920448.filter(c,g)
	return g:IsContains(c)
end
function c98920448.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local cg=e:GetHandler():GetColumnGroup()
	if chkc then return chkc:IsOnField() and c98920448.filter(chkc,cg) end
	if chk==0 then return e:GetHandler():GetAttack()>=1000 and Duel.IsExistingTarget(c98920448.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,cg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c98920448.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c98920448.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:GetAttack()>=1000 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		c:RegisterEffect(e1)
		if tc and tc:IsRelateToEffect(e) and not c:IsHasEffect(EFFECT_REVERSE_UPDATE) then
		  Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end