local m=53734013
local cm=_G["c"..m]
cm.name="青缀通路 218阶"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,5))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.dtg)
	e2:SetOperation(cm.dop)
	c:RegisterEffect(e2)
	cm.aozora_field_effect=e2
end
function cm.filter(c)
	return c:IsCode(53734012) and ((c:IsLocation(LOCATION_DECK) and c:IsSSetable()) or (c:IsLocation(LOCATION_FZONE) and c:IsCanTurnSet()))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_FZONE,0,1,nil) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	if not tc then return end
	if (tc:IsLocation(LOCATION_DECK) and Duel.SSet(tp,tc)~=0) or (tc:IsLocation(LOCATION_FZONE) and Duel.ChangePosition(tc,POS_FACEDOWN)~=0) then
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ACTIVATE_COST)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetLabelObject(tc)
		e1:SetCondition(cm.costcon)
		e1:SetTarget(cm.costtg)
		e1:SetOperation(cm.costop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.costcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc or tc:GetFlagEffect(m)==0 then
		e:Reset()
		return false
	else return true end
end
function cm.costtg(e,te,tp)
	return te:GetHandler()==e:GetLabelObject() and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3536))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsCanChangePosition,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
	if chk==0 then return b1 or b2 end
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	local b1=Duel.IsExistingMatchingCard(Card.IsCanChangePosition,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
	while Duel.GetMatchingGroupCount(function(c)return c:IsSetCard(0x3536) and c:IsFaceup()end,tp,LOCATION_MZONE,0,nil)>ct and (b1 or b2) do
		if ct~=0 and not Duel.SelectYesNo(tp,aux.Stringid(m,4)) then break end
		if ct~=0 then Duel.BreakEffect() end
		ct=ct+1
		local op=0
		if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2)) elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,1)) elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(m,2))+1 end
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local tc=Duel.SelectMatchingCard(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
			Duel.HintSelection(Group.FromCards(tc))
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
			local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=math.log(s,2)
			Duel.MoveSequence(g:GetFirst(),nseq)
		end
	end
end
