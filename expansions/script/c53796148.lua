local m=53796148
local cm=_G["c"..m]
cm.name="超高能电池人"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_THUNDER),3,3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(2,EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.filter(c,lg,e)
	return lg and lg:IsContains(c) and c:IsCanBeEffectTarget(e)
end
function cm.cal(c,atk_or_def)
	if atk_or_def=="atk" and c:GetAttack()>c:GetBaseAttack() then return c:GetAttack()-c:GetBaseAttack() elseif atk_or_def=="def" and c:GetDefense()>c:GetBaseDefense() then return c:GetDefense()-c:GetBaseDefense() end
	return 0
end
function cm.fselect(g,c,tp)
	local fg=g:Filter(Card.IsFaceup,nil)
	local atk=math.floor(fg:GetSum(cm.cal,"atk")/2000)
	local def=math.floor(fg:GetSum(cm.cal,"def")/2000)
	local label=c:GetFlagEffectLabel(m) or 0x0
	return (atk>0 and label&0x1==0 and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)) or (def>0 and label&0x2==0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil))
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc,lg) end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,lg,e)
	if chk==0 then return g:CheckSubGroup(cm.fselect,1,3,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,1,3,c,tp)
	Duel.SetTargetCard(sg)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	if #tg==0 then return end
	local c=e:GetHandler()
	local fg=tg:Filter(Card.IsFaceup,nil)
	local atk=math.floor(fg:GetSum(cm.cal,"atk")/2000)
	local def=math.floor(fg:GetSum(cm.cal,"def")/2000)
	local label=c:GetFlagEffectLabel(m) or 0x0
	local op=aux.SelectFromOptions(tp,{atk>0 and label&0x1==0 and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil),aux.Stringid(m,1),1},{def>0 and label&0x2==0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil),aux.Stringid(m,2),2})
	local res=false
	if op==1 then
		c:SetFlagEffectLabel(m,label|0x1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,atk,nil)
		Duel.HintSelection(g)
		for tc in aux.Next(g) do
			if tc:IsCanBeDisabledByEffect(e) then res=true end
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
		end
	else
		c:SetFlagEffectLabel(m,label|0x2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,def,nil)
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 then res=true end
	end
	if not res or not Duel.SelectYesNo(tp,aux.Stringid(m,3)) then return end
	Duel.BreakEffect()
	Duel.ChangePosition(tg,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
end
