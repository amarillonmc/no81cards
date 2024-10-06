--不老不死的魔女
function c37900029.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(c37900029.op0)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_MAIN_END+TIMINGS_CHECK_MONSTER+TIMING_SSET)
	e1:SetCountLimit(1)
	e1:SetTarget(c37900029.tg)
	e1:SetOperation(c37900029.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,37900029)
	e2:SetTarget(c37900029.tg2)
	e2:SetOperation(c37900029.op2)
	c:RegisterEffect(e2)
end
function c37900029.op0(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()>0 then
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if ag:GetCount()>0 then
		local tc=ag:GetFirst()
		while tc do
		tc:AddCounter(0x1389,eg:GetCount())
		tc=ag:GetNext()
		end
		end
	end
end
function c37900029.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1389,4,REASON_COST) end
	local ct=Duel.GetCounter(tp,1,1,0x1389)
	local op=100
	if ct<8 then
	Duel.RemoveCounter(tp,1,1,0x1389,4,REASON_COST)
	e:SetValue(4)
	end
	if ct>=8 and ct<12 then
	op=Duel.SelectOption(tp,aux.Stringid(37900029,5),aux.Stringid(37900029,6))
	end
	if ct>=12 and ct<16 then
	op=Duel.SelectOption(tp,aux.Stringid(37900029,5),aux.Stringid(37900029,6),aux.Stringid(37900029,7))
	end
	if ct>=16 and ct<20 then
	op=Duel.SelectOption(tp,aux.Stringid(37900029,5),aux.Stringid(37900029,6),aux.Stringid(37900029,7),aux.Stringid(37900029,8))
	end
	if ct>=20 then
	op=Duel.SelectOption(tp,aux.Stringid(37900029,5),aux.Stringid(37900029,6),aux.Stringid(37900029,7),aux.Stringid(37900029,8),aux.Stringid(37900029,9))
	end
	if op==0 then
		Duel.RemoveCounter(tp,1,1,0x1389,4,REASON_COST)
		e:SetValue(4)
	end
	if op==1 then
		Duel.RemoveCounter(tp,1,1,0x1389,8,REASON_COST)
		e:SetValue(8)
	end
	if op==2 then
		Duel.RemoveCounter(tp,1,1,0x1389,12,REASON_COST)
		e:SetValue(12)
		e:SetCategory(CATEGORY_ATKCHANGE)
		Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,c,0,0,4000)
	end
	if op==3 then
		Duel.RemoveCounter(tp,1,1,0x1389,16,REASON_COST)
		e:SetValue(16)
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,c,0,0,4000)
		Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,c,0,0,4000)
	end
	if op==4 then
		Duel.RemoveCounter(tp,1,1,0x1389,20,REASON_COST)
		e:SetValue(20)
		Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,c,0,0,4000)
		Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,c,0,0,4000)
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end	
end
function c37900029.q(c,e,tp)
	return not c:IsType(TYPE_EFFECT) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp)>0
end
function c37900029.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rct=e:GetValue()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
	if rct>=4 then
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37900029,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
	end
	if rct>=8 then
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37900029,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c37900029.efilter)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2,true)
	end
	if rct>=12 then
	local atk=c:GetBaseAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk*2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37900029,2))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(1)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e3,true)
	end
	if rct>=16 then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(rct*100)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2,true)
	end
	if rct>=20 and Duel.IsExistingMatchingCard(c37900029.q,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(37900029,3)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c37900029.q,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_MZONE)
		e1:SetDescription(aux.Stringid(37900029,4))
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetOperation(c37900029.opr)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		g:GetFirst():RegisterEffect(e1,true)
			if Duel.IsPlayerCanDraw(tp,1) then
			Duel.Draw(tp,1,REASON_EFFECT)
			end
		end	
	end
	end
end
function c37900029.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c37900029.opr(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAbleToDeck() then
	Duel.SendtoDeck(c,nil,2,REASON_RULE)
	end
end
function c37900029.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
end
function c37900029.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end