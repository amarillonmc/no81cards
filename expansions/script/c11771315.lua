--真理的显现 蓓哈丽娅
function c11771315.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c11771315.filter0,2,99)
	-- 自由骰子
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11771315,0))
	e1:SetCategory(CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11771315)
	e1:SetTarget(c11771315.tg1)
	e1:SetOperation(c11771315.op1)
	c:RegisterEffect(e1)
	-- 更改骰子
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11771315,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_DICE_NEGATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c11771315.con2)
	e2:SetOperation(c11771315.op2)
	c:RegisterEffect(e2)
	-- 骰子苏生
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11771315,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TOSS_DICE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,11771316)
	e3:SetCondition(c11771315.con3)
	e3:SetTarget(c11771315.tg3)
	e3:SetOperation(c11771315.op3)
	c:RegisterEffect(e3)
end
-- link
function c11771315.filter0(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE))
end
-- 1
function c11771315.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c11771315.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.TossDice(tp,1)
	if d==1 then
		if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			c:RegisterFlagEffect(11771315,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(c)
			e1:SetCountLimit(1)
			e1:SetCondition(c11771315.retcon)
			e1:SetOperation(c11771315.retop)
			Duel.RegisterEffect(e1,tp)
		end
	elseif d==2 then
		local g1=Duel.GetFieldGroup(tp,LOCATION_REMOVED,0)
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_REMOVED)
		if #g1>0 then
			Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
		if #g2>0 then
			Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	elseif d==3 then
		Duel.Draw(tp,2,REASON_EFFECT)
		Duel.Draw(1-tp,2,REASON_EFFECT)
	elseif d==4 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c11771315.limit11)
		e1:SetValue(aux.tgoval)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	elseif d==5 then
		local g1=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
	elseif d==6 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c11771315.retfilter(c)
    return c:GetFlagEffect(11771315)~=0
end
function c11771315.retcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetLabelObject()
    return c:IsLocation(LOCATION_REMOVED) and c:GetFlagEffect(11771315)~=0
end
function c11771315.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetLabelObject()
    if c:IsLocation(LOCATION_REMOVED) and c:GetFlagEffect(11771315)~=0 then
        Duel.ReturnToField(c)
    end
end
function c11771315.limit11(e,c)
	return c:IsEffectProperty(aux.MonsterEffectPropertyFilter(EFFECT_FLAG_DICE))
end
-- 2
function c11771315.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:GetOwner()~=c and c:GetFlagEffect(11771315+100)==0
end
function c11771315.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(11771315,1)) then
		local c=e:GetHandler()
		c:RegisterFlagEffect(11771315+100,RESET_EVENT+RESETS_STANDARD,0,1)
		Duel.Hint(HINT_CARD,0,11771315)
		local dc={Duel.GetDiceResult()}
		local ac=1
		local ct=(ev&0xff)+(ev>>16&0xff)
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11771315,3))
			local val,idx=Duel.AnnounceNumber(tp,table.unpack(aux.idx_table,1,ct))
			ac=idx+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11771315,4))
		local op=Duel.SelectOption(tp,aux.Stringid(11771315,5),aux.Stringid(11771315,6))
		dc[ac]=op==0 and 1 or 6
		Duel.SetDiceResult(table.unpack(dc))
	end
end
-- 3
function c11771315.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c11771315.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11771315.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.TossDice(tp,1)
	if d>=2 and d<=5 and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
