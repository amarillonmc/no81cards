--主宰之怒 后虫
local s,id,o=GetID()
function s.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.setcon1)
	e1:SetCost(s.pucost)
	e1:SetTarget(s.sumtg)
	e1:SetOperation(s.sumop)
	c:RegisterEffect(e1)
	local e10=e1:Clone()
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetCondition(s.setcon2)
	c:RegisterEffect(e10)
end


function s.cfilter(c)
	return c:IsSetCard(0x9a31) and c:IsFaceup() or c:IsFacedown() and c:IsLocation(LOCATION_MZONE) 
end
function s.setcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.pucost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.posfilter(c)
	return c:IsFaceup()
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.posfilter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(s.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	local op=aux.SelectFromOptions(tp,
			{true,aux.Stringid(id,0)},
			{true,aux.Stringid(id,1)},
			{true,aux.Stringid(id,2)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,s.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
		e:SetLabel(1)
	elseif op==2 then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,s.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
		e:SetLabel(2)
	elseif op==3 then
		e:SetCategory(CATEGORY_DISABLE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,s.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
		e:SetLabel(3)
	end	
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if e:GetLabel()==1 then
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e7=Effect.CreateEffect(c)
			e7:SetDescription(aux.Stringid(id,3))
			e7:SetType(EFFECT_TYPE_FIELD)
			e7:SetCode(EFFECT_PUBLIC)
			e7:SetRange(LOCATION_MZONE)
			e7:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e7:SetTargetRange(LOCATION_HAND,0)
			e7:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e7)
			--cannot set
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_CANNOT_MSET)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e4:SetRange(LOCATION_MZONE)
			e4:SetTargetRange(1,0)
			e4:SetTarget(aux.TRUE)
			c:RegisterEffect(e4)
			local e5=e4:Clone()
			e5:SetCode(EFFECT_CANNOT_SSET)
			c:RegisterEffect(e5)
			local e6=e4:Clone()
			e6:SetCode(EFFECT_CANNOT_TURN_SET)
			c:RegisterEffect(e6)
			local e1=e4:Clone()
			e1:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
			e1:SetTarget(s.sumlimit)
			c:RegisterEffect(e1)
		end
	elseif e:GetLabel()==2 then
		if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,65814131,0x6a31,TYPES_TOKEN_MONSTER,500,0,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
			local token=Duel.CreateToken(tp,65814131)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif e:GetLabel()==3 then
		if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end