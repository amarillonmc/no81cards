--元素灵剑士·浪涛
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
	if not s.globle_check then
		s.globle_check=true
		local ge0=Effect.CreateEffect(e:GetHandler())
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetCost(aux.FALSE)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(s.actarget)
		Duel.RegisterEffect(ge0,0)
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
		--for i,f in pairs(Effect) do Debug.Message(i) end
		Card.RegisterEffect=function(card,effect,flag)
			if effect then
				local eff=effect:Clone()
				if s.GetRange(effect)==LOCATION_MZONE and (effect:IsHasType(EFFECT_TYPE_QUICK_O) or effect:IsHasType(EFFECT_TYPE_TRIGGER_O) or effect:IsHasType(EFFECT_TYPE_TRIGGER_F) or effect:IsHasType(EFFECT_TYPE_IGNITION)) then
					eff:SetValue(id)
					esetrange(eff,LOCATION_HAND+LOCATION_MZONE)
				end
				table.insert(table_effect,eff)
			end
			return 
		end
		for tc in aux.Next(g) do
			table_effect={}
			tc:ReplaceEffect(id,0)
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				cregister(tc,eff)
			end
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
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetTarget(s.efftg)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	if bit.band(flag,0x1)~=0 then
		--special summon
		local e01=Effect.CreateEffect(c)
		e01:SetType(EFFECT_TYPE_FIELD)
		e01:SetCode(EFFECT_SPSUMMON_PROC)
		e01:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e01:SetRange(LOCATION_HAND)
		e01:SetCondition(s.spcon)
		local e1=e0:Clone()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e1:SetLabelObject(e01)
		e1:SetDescription(aux.Stringid(id,1))
		c:RegisterEffect(e1)
	end
	if bit.band(flag,0x2)~=0 then
		local e2=e0:Clone()
		--change effect type
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetCode(id)
		e2:SetDescription(aux.Stringid(id,2))
		e2:SetTargetRange(1,0)
		c:RegisterEffect(e2)
	end
	if bit.band(flag,0x4)~=0 then
		local e3=e0:Clone()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EFFECT_SEND_REPLACE)
		e3:SetDescription(aux.Stringid(id,3))
		e3:SetTarget(s.reptg)
		e3:SetValue(s.repval)
		c:RegisterEffect(e3)
	end
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_GRAVE,0,nil,e:GetHandler():GetAttribute())==2
end
function s.efftg(e,c)
	return c:IsSetCard(0x400d)
end
function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_HAND) and c:IsSetCard(0x400d) and c:GetDestination()==LOCATION_GRAVE and not c:IsPublic()
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp) end
	local reg=eg:Filter(s.repfilter,nil,tp)
	if #reg>0 then
		local tc=reg:GetFirst()
		while tc do
			if Duel.SelectEffectYesNo(tp,tc,aux.Stringid(id,4)) then
				local fid=tc:GetFieldID()
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,EFFECT_FLAG_CLIENT_HINT,1,fid,66)
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			tc=reg:GetNext()
		end
	end
	if (#reg)==0 then return false end
	return true
end
function s.repval(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsLocation(LOCATION_HAND) and c:IsSetCard(0x400d)
end
