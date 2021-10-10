--伪装龙 无形变化
local m=35300193
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,m+1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e5=e6:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.negcon)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
end

function cm.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD,1,1,nil,e,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetValue(tc:GetAttack())
			e1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_BASE_DEFENSE)
			e2:SetValue(tc:GetDefense())
			c:RegisterEffect(e2,true)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_CHANGE_LEVEL)
			e4:SetValue(tc:GetLevel())
			c:RegisterEffect(e4,true)
			local e5=e1:Clone()
			e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e5:SetValue(tc:GetAttribute())
			c:RegisterEffect(e5,true)
			local e6=e1:Clone()
			e6:SetCode(EFFECT_CHANGE_RACE)
			e6:SetValue(tc:GetRace())
			c:RegisterEffect(e6,true)
	end
end

function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:GetHandler():IsAttribute(c:GetAttribute())
		and rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		local rc=re:GetHandler()
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
end

