--魔惧会 爆轰之布鲁斯
local m=40010756
local cm=_G["c"..m]
cm.named_with_Diablotherhood=1
function cm.Diablotherhood(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Diablotherhood
end
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_FIEND),2)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e1:SetCountLimit(1)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2) 
  
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e5:SetCondition(cm.descon)
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.operation)
	c:RegisterEffect(e5)
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsCode,1,nil,40009560) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(40009560,0))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(40009560,0))
	Duel.RegisterFlagEffect(tp,40009560,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,EFFECT_FLAG_OATH,1)
	c:RegisterFlagEffect(0,RESET_EVENT+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(40009560,0))
	if e:GetLabel()==1 then
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,0))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,0))
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,EFFECT_FLAG_OATH,1)
		c:RegisterFlagEffect(0,RESET_EVENT+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
end
function cm.dfilter(c)
	return c:IsFaceup() and c:IsCode(40010230)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	--if Duel.GetFlagEffect(tp,m)>0 then return e:GetHandler():GetFlagEffect(m+1)<2
	--else return e:GetHandler():GetFlagEffect(m+1)<1 end
	return Duel.GetFlagEffect(tp,40009560)>0 or Duel.IsExistingMatchingCard(cm.dfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.NegateAnyFilter(chkc) end
	if chk==0 then
		local b
		if Duel.GetFlagEffect(tp,m)>0 then
			b=c:GetFlagEffect(m+1)<2
		else
			b=c:GetFlagEffect(m+1)<1
		end
		return b and Duel.IsExistingTarget(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil)
	end
	c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)



	--if chk==0 then return Duel.IsExistingTarget(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
	e:GetHandler():RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end



