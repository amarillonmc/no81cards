--血海的红枪姬 米茜尔
local s,id,o=GetID()
Duel.LoadScript("c33201050.lua")
function s.initial_effect(c)
	c:EnableCounterPermit(0x32b)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),8,2,s.ovfilter,aux.Stringid(id,0),99,XY_VHisc.xyzop,id)
	c:EnableReviveLimit()   
	--remove when chaining
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.ctcon)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	--ct
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+10000)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
s.VHisc_Vampire=true

--xyz
function s.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and not c:IsCode(id)
end

--e1
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x32b,2) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetHandler(),0,0x32b)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(1-tp,1000,REASON_EFFECT) then
		e:GetHandler():AddCounter(0x32b,2)
	end
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL)
end


--e2
function s.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x32b,1)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():GetCounter(0x32b)>0 and Duel.IsExistingTarget(s.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x32a)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local ct=c:GetCounter(0x32b)
		e:GetHandler():RemoveCounter(tp,0x32b,ct,REASON_EFFECT)
		Duel.RaiseEvent(e:GetHandler(),EVENT_REMOVE_COUNTER+0x32b,e,REASON_EFFECT,tp,tp,ev)
		tc:AddCounter(0x32b,ct)
		Duel.BreakEffect()
		Duel.Recover(tp,ct*500,REASON_EFFECT)
	end
end