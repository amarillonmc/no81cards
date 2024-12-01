--秘计螺旋 猛虎
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddFusionProcFunRep(c,s.mfilter,3,true)
	--spsum condition
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_ONFIELD,0,Duel.SendtoGrave,REASON_COST):SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	--tribute check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.valcheck)
	c:RegisterEffect(e1)
	--immune reg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(s.regop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(s.sscon1)
	e3:SetTarget(s.sstg)
	e3:SetOperation(s.ssop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(s.sscon2)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id)
	e5:SetCost(s.thcost)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)
	
end
function s.mfilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x836)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local typ=e:GetLabelObject():GetLabel()
	if typ&0x7==0x7 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	local typ=0
	local tc=g:GetFirst()
	while tc do
		typ=bit.bor(typ,bit.band(tc:GetOriginalType(),0x7))
		tc=g:GetNext()
	end
	e:SetLabel(typ)
end
function s.sscon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)==0
end
function s.sscon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function s.ssop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_COST)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0,nil)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(Card.IsSSetable,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then 
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			local dc=g:GetFirst()
			if Duel.SSet(tp,dc,tp,false)==0 then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetDescription(aux.Stringid(id,4))
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			dc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			dc:RegisterEffect(e2)
		end
	end
end