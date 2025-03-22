--元素灵剑士·撼地
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	e2:SetLabelObject(e1)
	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(s.adjustop)
	c:RegisterEffect(e01)
	if not s.globle_check then
		s.globle_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local re=tc:GetReasonEffect()
		if tc:IsSetCard(0x400d) and tc:IsReason(REASON_COST) and re and re:IsActivated() then
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,10))
		end
		tc=eg:GetNext()
	end
end
function s.filter(c)
	return c:IsSetCard(0x400d) and not c:IsCode(id) and c:IsType(TYPE_MONSTER)
end
function s.actarget(e,te,tp)
	--prevent activating
	local tc=te:GetHandler()
	return te:GetValue()==id and tc:IsLocation(LOCATION_HAND) and not Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),id)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_effect_check then
		s.globle_effect_check=true
		local g=Duel.GetMatchingGroup(s.filter,0,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		esetrange=Effect.SetRange
		table_effect={}
		table_range={}
		Effect.SetRange=function(effect,range)
			table_range[effect]=range
			return esetrange(effect,range)
			end
		s.GetRange=function(effect)
			if table_range[effect] then 
				return table_range[effect]
			end
			return nil
		end
		BlackLotus_ElementSaber_Effect={}
		Card.RegisterEffect=function(card,effect,flag)
			if effect and s.GetRange(effect)==LOCATION_MZONE and ((effect:IsHasType(EFFECT_TYPE_QUICK_O) and bit.band(effect:GetCode(),EVENT_FREE_CHAIN)==EVENT_FREE_CHAIN) or effect:IsHasType(EFFECT_TYPE_IGNITION)) then
				--Duel.Hint(HINT_CARD,0,card:GetCode())
				local eff=effect:Clone()
				BlackLotus_ElementSaber_Effect[card:GetCode()]=eff
			end
			return 
		end
		for tc in aux.Next(g) do
			Duel.CreateToken(0,tc:GetOriginalCode())
		end
		Card.RegisterEffect=cregister
		Effect.SetRange=esetrange
	end
	e:Reset()
end
function s.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and (c:IsSetCard(0x400d) or c:IsLocation(LOCATION_HAND))
end
function s.regfilter(c,attr)
	return c:IsSetCard(0x400d) and bit.band(c:GetOriginalAttribute(),attr)~=0
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,61557074)
	local loc=LOCATION_HAND
	if fe then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,loc,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,loc,0,2,2,e:GetHandler())
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,61557074)
		fe:UseCountLimit(tp)
	end
	local flag=0
	if g:IsExists(s.regfilter,1,nil,ATTRIBUTE_EARTH+ATTRIBUTE_WIND) then flag=bit.bor(flag,0x1) end
	if g:IsExists(s.regfilter,1,nil,ATTRIBUTE_WATER+ATTRIBUTE_FIRE) then flag=bit.bor(flag,0x2) end
	if g:IsExists(s.regfilter,1,nil,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) then flag=bit.bor(flag,0x4) end
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(flag)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF and e:GetLabelObject():GetLabel()~=0
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local flag=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(LOCATION_GRAVE,0)
	e0:SetTarget(s.efftg)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	if bit.band(flag,0x1)~=0 then
		--spsummon from szone
		local e01=Effect.CreateEffect(c)
		e01:SetDescription(aux.Stringid(id,6))
		e01:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e01:SetType(EFFECT_TYPE_QUICK_O)
		e01:SetRange(LOCATION_GRAVE)
		e01:SetCode(EVENT_FREE_CHAIN)
		e01:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
		e01:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
		e01:SetCondition(s.spcon2)
		e01:SetTarget(s.sptg2)
		e01:SetOperation(s.spop2)
		local e1=e0:Clone()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e1:SetLabelObject(e01)
		e1:SetDescription(aux.Stringid(id,1))
		c:RegisterEffect(e1)
	end
	if bit.band(flag,0x2)~=0 then
		--effect gain
		local e02=Effect.CreateEffect(c)
		e02:SetDescription(aux.Stringid(id,7))
		e02:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
		e02:SetCode(EVENT_PHASE+PHASE_END)
		e02:SetRange(LOCATION_GRAVE)
		e02:SetCountLimit(1)
		e02:SetTarget(s.cptg)
		e02:SetOperation(s.cpop)
		local e2=e0:Clone()
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e2:SetLabelObject(e02)
		e2:SetDescription(aux.Stringid(id,2))
		c:RegisterEffect(e2)
	end
	if bit.band(flag,0x4)~=0 then
		--to hand
		local e03=Effect.CreateEffect(c)
		e03:SetDescription(aux.Stringid(id,8))
		e03:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
		e03:SetCategory(CATEGORY_TOHAND)
		e03:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e03:SetRange(LOCATION_GRAVE)
		e03:SetCountLimit(1)
		e03:SetTarget(s.thtg)
		e03:SetOperation(s.thop)
		local e3=e0:Clone()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e3:SetLabelObject(e03)
		e3:SetDescription(aux.Stringid(id,3))
		c:RegisterEffect(e3)
	end
end
function s.efftg(e,c)
	return c:IsSetCard(0x400d)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local re=c:GetReasonEffect()
	return c:IsReason(REASON_COST) and re and re:IsActivated()
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ce=BlackLotus_ElementSaber_Effect[c:GetOriginalCode()]
	local tg=nil
	if ce then tg=ce:GetTarget() end
	if chk==0 then
		return ce and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0))
	end
	--local ce=BlackLotus_ElementSaber_Effect[c:GetOriginalCode()]
	e:SetProperty(ce:GetProperty())
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	ce:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(ce)
	Duel.ClearOperationInfo(0)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local ce=e:GetLabelObject()
	if not ce then return end
	e:SetLabelObject(ce:GetLabelObject())
	local op=ce:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
