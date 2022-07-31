--闪刀术式-最终剑斩
function c99550610.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c99550610.condition)
	e1:SetCost(c99550610.cost)
	e1:SetTarget(c99550610.target)
	e1:SetOperation(c99550610.activate)
	c:RegisterEffect(e1)
end
function c99550610.cfilter(c)
	return c:GetSequence()<5
end
function c99550610.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c99550610.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99550610.cfilter2(c,tp)
	return c:GetBaseAttack()>0 and c:IsAbleToGraveAsCost() and c:IsSetCard(0x1115)
end
function c99550610.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99550610.cfilter2,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99550610.cfilter2,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetBaseAttack())
	Duel.SendtoGrave(g,REASON_COST)
end
function c99550610.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c99550610.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		e1:SetValue(-e:GetLabel())
		tc:RegisterEffect(e1)
		local ac=nil
		local ac1=Duel.GetFieldCard(tp,LOCATION_MZONE,5)
		local ac2=Duel.GetFieldCard(tp,LOCATION_MZONE,6)
		if ac1 and ac1:IsControler(tp) and ac1:IsSetCard(0x1115) and ac1:IsFaceup() then ac=ac1 end
		if ac2 and ac2:IsControler(tp) and ac2:IsSetCard(0x1115) and ac2:IsFaceup() then ac=ac2 end
		if ac and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 then
			local zone=bit.band(ac:GetLinkedZone(1-tp),0x1f)
			if tc:IsControler(1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0,zone)>0 and Duel.SelectYesNo(tp,aux.Stringid(99550610,0)) then
				Duel.BreakEffect()
				local s=0
				local flag=bit.bxor(zone,0xff)*0x10000
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
				s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,flag)/0x10000
				local nseq=0
				if s==1 then nseq=0
				elseif s==2 then nseq=1
				elseif s==4 then nseq=2
				elseif s==8 then nseq=3
				else nseq=4 end
				Duel.MoveSequence(tc,nseq)
			end
		end
	end
end
