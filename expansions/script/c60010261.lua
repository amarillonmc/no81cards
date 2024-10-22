--蜃气楼
local cm,m,o=GetID()
function cm.initial_effect(c)
	--summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetCondition(cm.sumcon)
	e4:SetTarget(cm.sumtg)
	e4:SetOperation(cm.sumop)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.imtg)
	c:RegisterEffect(e3)
	local e2=e3:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(e2)
	local e1=e3:Clone()
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e1)

	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_TOKEN+CATEGORY_ATKCHANGE+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e11:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1)
	e11:SetCondition(cm.tkcon)
	e11:SetTarget(cm.tktg)
	e11:SetOperation(cm.tkop)
	c:RegisterEffect(e11)
	local e22=e11:Clone()
	e22:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e22)
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_PUBLIC)
	e11:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e11)
	
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:GetAttribute()~=0
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSummonable(true,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local ec=eg:GetFirst()
		if #eg>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			ec=eg:Select(tp,1,1,nil):GetFirst()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetRange(0xff)
		e1:SetValue(ec:GetAttribute())
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1)
		Duel.Summon(tp,c,true,nil)
	end
end
function cm.imtg(e,c)
	local tc=e:GetHandler()
	return c~=tc and tc:GetAttribute()&c:GetAttribute()>0
end

function cm.cfilter2(c,tp)
	return c:IsFaceup() and (c:IsAttribute(ATTRIBUTE_EARTH) 
		or (c:IsAttribute(ATTRIBUTE_FIRE) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil))
		or (c:IsAttribute(ATTRIBUTE_WATER) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1) 
		or (c:IsAttribute(ATTRIBUTE_WIND) and Duel.IsExistingMatchingCard(cm.cfilter3,tp,0,LOCATION_MZONE,1,nil)))
end
function cm.cfilter3(c)
	return c:IsFaceup() --and not c:IsAttack(0)
end
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter2,1,e:GetHandler(),tp)
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	local ec=eg:Filter(cm.cfilter2,nil,tp):GetFirst()
	if #eg:Filter(cm.cfilter2,nil,tp)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		ec=eg:Select(tp,1,1,nil):GetFirst()
	end
	if not ec then return end
	local attr=ec:GetAttribute()
	Debug.Message("航驶三界六道，感知须臾万物，寻觅人妖轶闻，幻化牌曰百识。")
	if attr&ATTRIBUTE_FIRE>0 then
		local token=Duel.CreateToken(tp,m+1)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(ag) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(500)
			tc:RegisterEffect(e1)
		end
	end
	if attr&ATTRIBUTE_WATER>0 then
		local token=Duel.CreateToken(tp,m+2)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.SortDecktop(tp,tp,2)
	end
	if attr&ATTRIBUTE_WIND>0 then
		local token=Duel.CreateToken(tp,m+3)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local tc=Duel.SelectMatchingCard(tp,cm.cfilter3,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-400)
		tc:RegisterEffect(e1)
		if tc:IsAttack(0) then Duel.Destroy(tc,REASON_EFFECT) end
	end
	if attr&ATTRIBUTE_EARTH>0 then
		local token=Duel.CreateToken(tp,m+4)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Recover(tp,800,REASON_EFFECT)
	end
end

















