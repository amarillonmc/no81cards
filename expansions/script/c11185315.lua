--虹龍·神龙
function c11185315.initial_effect(c)
	aux.AddCodeList(c,0x452)
	c:EnableCounterPermit(0x452)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x453),5,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST+REASON_MATERIAL)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11185315,0))
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11185315)
	e1:SetCost(c11185315.ctcost)
	e1:SetTarget(c11185315.cttg)
	e1:SetOperation(c11185315.ctop)
	c:RegisterEffect(e1)
	--lock
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11185315,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11185315+1)
	e2:SetTarget(c11185315.lztg)
	e2:SetOperation(c11185315.lzop)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1,11185315+2)
	e3:SetCondition(c11185315.ctrcon)
	e3:SetTarget(c11185315.ctrtg)
	e3:SetOperation(c11185315.ctrop)
	c:RegisterEffect(e3)
end
function c11185315.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x452,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x452,1,REASON_COST)
end
function c11185315.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c11185315.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.GetControl(g,tp,PHASE_END,1)>0 then
			if Duel.IsCanRemoveCounter(tp,1,0,0x452,1,REASON_EFFECT)
				and Duel.SelectYesNo(tp,aux.Stringid(11185315,2)) then
				Duel.BreakEffect()
				if Duel.RemoveCounter(tp,1,0,0x452,1,REASON_EFFECT) then
					if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
					local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c11185315.spfilter),tp,0x30,0,nil,e,tp)
					if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11185315,3)) then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						local sg=g2:Select(tp,1,1,nil)
						Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
					end
				end
			end
		end
	end
end
function c11185315.spfilter(c,e,tp)
	return c:IsSetCard(0x453) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11185315.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_ONFIELD,PLAYER_NONE,0)>0 end
	local dis=Duel.SelectDisableField(tp,1,0,LOCATION_ONFIELD,0xe0)
	Duel.SetTargetParam(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
end
function c11185315.lzop(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tp==1 then
		zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
	end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(zone)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function c11185315.ctrcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c11185315.ctrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x452)
end
function c11185315.ctrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:AddCounter(0x452,1) then
		local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,nil,0x452,1)
		Duel.BreakEffect()
		for tc in aux.Next(g) do
			if tc:IsCanAddCounter(0x452,1) then
				tc:AddCounter(0x452,1)
			end
		end
	end
end