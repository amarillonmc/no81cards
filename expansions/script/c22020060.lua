--人理之诗 遥远的理想乡
function c22020060.initial_effect(c)
	c:EnableCounterPermit(0xfee)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22020060.condition)
	e1:SetTarget(c22020060.target)
	e1:SetOperation(c22020060.activate)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c22020060.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c22020060.desreptg)
	e3:SetValue(c22020060.desrepval)
	e3:SetOperation(c22020060.desrepop)
	c:RegisterEffect(e3)
end
c22020060.effect_with_avalon=true
c22020060.effect_with_altria=true
function c22020060.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff9)
end
function c22020060.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22020060.ctfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22020060.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(c22020060.ctfilter,tp,LOCATION_MZONE,0,c)
	local c=e:GetHandler()
	if chk==0 and ct>0 then return Duel.IsCanAddCounter(tp,0xfee,ct,c) end
end
function c22020060.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c22020060.ctfilter,tp,LOCATION_MZONE,0,c)
	if c:IsRelateToEffect(e) and ct>0 then
		c:AddCounter(0xfee,ct)
	end
end
function c22020060.tgtg(e,c)
	return c:IsSetCard(0xff1) and c~=e:GetHandler()
end
function c22020060.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c22020060.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c22020060.repfilter,1,nil,tp)
		and e:GetHandler():IsCanRemoveCounter(tp,0xfee,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c22020060.desrepval(e,c)
	return c22020060.repfilter(c,e:GetHandlerPlayer())
end
function c22020060.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0xfee,1,REASON_EFFECT)
end