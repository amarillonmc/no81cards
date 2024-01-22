
local m=40011100
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--to hand & spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e)
	return not e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xf11,TYPES_TOKEN_MONSTER,3000,3000,9,RACE_MACHINE,ATTRIBUTE_LIGHT) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,3,3,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.SendtoHand(g,0,REASON_EFFECT)>0 then
			if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xf11,TYPES_TOKEN_MONSTER,3000,3000,9,RACE_MACHINE,ATTRIBUTE_LIGHT)) then return end
			Duel.BreakEffect()
			c:AddMonsterAttribute(TYPE_NORMAL+TYPE_SPELL+TYPE_CONTINUOUS)
			Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
			local fid=e:GetHandler():GetFieldID()
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetLabel(fid)
			e1:SetLabelObject(c)
			e1:SetCondition(cm.pcon)
			e1:SetOperation(cm.pop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.pcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	Duel.MoveToField(e:GetLabelObject(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end