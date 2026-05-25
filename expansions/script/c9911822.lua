--玄武固垒烬灵
function c9911822.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--spsummon effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911822,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c9911822.speftg)
	e1:SetOperation(c9911822.spefop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9911822.spefcon)
	c:RegisterEffect(e2)
end
function c9911822.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c9911822.spefcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c9911822.cfilter,1,nil)
end
function c9911822.filter1(c,tp)
	return not c:IsLocation(LOCATION_FZONE) and c:GetColumnGroup():IsExists(Card.IsControler,1,nil,1-tp)
end
function c9911822.filter2(c)
	return c:IsSetCard(0xa957) and c:IsAbleToHand()
end
function c9911822.speftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==1 then
			return chkc:IsControler(tp) and chkc:IsOnField() and c9911822.filter1(chkc,tp)
		elseif e:GetLabel()==2 then
			return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c9911822.filter2(chkc)
		else return false end
	end
	local b1=Duel.IsExistingTarget(c9911822.filter1,tp,LOCATION_ONFIELD,0,1,nil,tp)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,9911822)==0)
	local b2=Duel.IsExistingTarget(c9911822.filter2,tp,LOCATION_GRAVE,0,1,nil)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,9911823)==0)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 or b2 then
		op=aux.SelectFromOptions(tp,{b1,aux.Stringid(9911822,1),1},{b2,aux.Stringid(9911822,2),2})
	end
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
			Duel.RegisterFlagEffect(tp,9911822,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=Duel.SelectTarget(tp,c9911822.filter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_TOHAND)
			Duel.RegisterFlagEffect(tp,9911823,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectTarget(tp,c9911822.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
	end
end
function c9911822.spefop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local tc1=Duel.GetFirstTarget()
		local cg=Group.CreateGroup()
		if not tc1:IsLocation(LOCATION_FZONE) then cg=tc1:GetColumnGroup():Filter(Card.IsControler,nil,1-tp) end
		if tc1:IsRelateToEffect(e) and Duel.Destroy(tc1,REASON_EFFECT)>0 and #cg>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=cg:Select(1-tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_RULE,1-tp)
		end
	elseif e:GetLabel()==2 then
		local tc2=Duel.GetFirstTarget()
		if tc2:IsRelateToEffect(e) then
			Duel.SendtoHand(tc2,nil,REASON_EFFECT)
		end
	end
end
