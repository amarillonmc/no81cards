--Please Reflect!
function c33741066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c33741066.target)
	e1:SetOperation(c33741066.activate)
	c:RegisterEffect(e1)
end
function c33741066.tfilter(c,tp,ft)
	if c:IsFacedown() then return false end
	local p=c:GetOwner()
	if p~=tp then ft=0 end
	local r=LOCATION_REASON_TOFIELD
	if not c:IsControler(p) then
		if not c:IsAbleToChangeControler() then return false end
		r=LOCATION_REASON_CONTROL
	end
	return Duel.GetLocationCount(p,LOCATION_SZONE,tp,r)>ft
end
function c33741066.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c33741066.tfilter(chkc,tp,0) end
	if chk==0 then
		local ft=e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():IsLocation(LOCATION_HAND) and 1 or 0
		return Duel.IsExistingTarget(c33741066.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,ft)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c33741066.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,0)
end
function c33741066.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e)
		and Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(33741066,RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE,0,1,fid)
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetCode(EFFECT_CHANGE_TYPE)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc:RegisterEffect(e0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetRange(LOCATION_SZONE)
		e1:SetLabel(fid)
		e1:SetOperation(c33741066.regop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c33741066.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	e:Reset()
	local c,ec=e:GetHandler(),e:GetOwner()
	local b1=Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=c:IsAbleToDeck()
	local b3=c:IsAbleToHand() and Duel.IsPlayerCanDraw(tp,1)
	local b4=ec:GetFlagEffectLabel(33741066)==e:GetLabel() and ec:IsSSetable(true) and Duel.GetSZoneCount(tp)>0
	local b5=true
	if not (b1 or b2 or b3 or b4) then return end
	Duel.Hint(HINT_CARD,0,33741066)
	Duel.HintSelection(Group.FromCards(c))
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(33741066,0)},
		{b2,aux.Stringid(33741066,1)},
		{b3,aux.Stringid(33741066,2)},
		{b4,aux.Stringid(33741066,3)},
		{b5,aux.Stringid(33741066,4)})
	if op==1 then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.Recover(tp,c:GetAttack(),REASON_EFFECT)
		end
	elseif op==2 then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	elseif op==3 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		if not c:IsLocation(LOCATION_HAND) then return end
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif op==4 then
		Duel.SSet(tp,ec,tp)
	end
end
