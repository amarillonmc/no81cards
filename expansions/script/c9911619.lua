--『忠诚的陵墓守望者』滕王虫
function c9911619.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--cannot remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c9911619.rmlimit)
	c:RegisterEffect(e1)
	--can not be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--confirm
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetTarget(c9911619.contg)
	e3:SetOperation(c9911619.conop)
	c:RegisterEffect(e3)
end
function c9911619.rmlimit(e,c,p)
	return c:IsLocation(LOCATION_GRAVE)
end
function c9911619.contg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=0
	if Duel.GetFlagEffect(tp,9911619)>0 then loc=LOCATION_ONFIELD end
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,loc)>0 end
end
function c9911619.conop(e,tp,eg,ep,ev,re,r,rp)
	local loc=0
	if Duel.GetFlagEffect(tp,9911619)>0 then
		Duel.ResetFlagEffect(tp,9911619)
		loc=LOCATION_ONFIELD
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_ONFIELD,loc)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911619,0))
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	if tc:IsFaceup() then Duel.HintSelection(sg)
	else Duel.ConfirmCards(1-tc:GetControler(),tc) end
	local code=tc:GetOriginalCode()
	if code==9911601 or code==9911614 then
		if Duel.SelectYesNo(tp,aux.Stringid(9911619,1)) then
			Duel.BreakEffect()
			Duel.RegisterFlagEffect(tp,9911619,0,0,1)
		end
	else
		if tc:IsAbleToGrave() and Duel.IsPlayerCanDraw(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(9911619,2)) then
			Duel.BreakEffect()
			if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
				Duel.Draw(tp,2,REASON_EFFECT)
			end
		end
	end
	if tc:IsLocation(LOCATION_HAND) then Duel.ShuffleHand(tp) end
end
