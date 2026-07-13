--源于黑影 投石
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2)
	c:SetSPSummonOnce(id)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.sprcon)
	e2:SetOperation(s.sprop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(s.tnop)
	c:RegisterEffect(e3)
end

s.effect_lixiaoguo=true

function s.consume_use_counter(e,tp)
	for i=0,10 do
		Duel.ResetFlagEffect(tp,EFFECT_FLAG_EFFECT+65820000+i)
	end
	local count=math.max(Duel.GetFlagEffect(tp,65820099)-1,0)
	Duel.ResetFlagEffect(tp,65820099)
	for i=1,count do
		Duel.RegisterFlagEffect(tp,65820099,0,0,1)
	end
	local te=Effect.CreateEffect(e:GetHandler())
	te:SetDescription(aux.Stringid(65820000,count))
	te:SetType(EFFECT_TYPE_FIELD)
	te:SetCode(EFFECT_FLAG_EFFECT+65820000+count)
	te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	te:SetTargetRange(1,0)
	Duel.RegisterEffect(te,tp)
end

function s.thfilter(c,sc)
	return c:IsSetCard(0x3a32) and c:IsFaceupEx() and (c:IsCanBeXyzMaterial(sc) or c:IsType(TYPE_SPELL+TYPE_TRAP))
end

function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local has_use=Duel.GetFlagEffect(tp,65820099)>0
	local is_flipped=c:GetFlagEffect(65820010)>0
	local loc=0
	if (has_use and not is_flipped) or (not has_use and is_flipped) then
		loc=LOCATION_GRAVE+LOCATION_REMOVED
	else
		loc=LOCATION_HAND
	end
	return Duel.IsExistingMatchingCard(s.thfilter,tp,loc,0,1,nil,c) and Duel.GetLocationCountFromEx(tp,tp,nil,c)~=0
end

function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local has_use=Duel.GetFlagEffect(tp,65820099)>0
	local is_flipped=c:GetFlagEffect(65820010)>0
	local loc=0
	if (has_use and not is_flipped) or (not has_use and is_flipped) then
		loc=LOCATION_GRAVE+LOCATION_REMOVED
		if has_use then s.consume_use_counter(e,tp) end
	else
		loc=LOCATION_HAND
		if has_use then s.consume_use_counter(e,tp) end
	end
	local ag=Duel.GetMatchingGroup(s.thfilter,tp,loc,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg=ag:FilterSelect(tp,s.thfilter,1,1,nil,c)
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	if loc==LOCATION_HAND then Duel.ShuffleHand(tp) end
end

function s.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetLabel(fid)
	e2:SetLabelObject(c)
	e2:SetCondition(s.descon1)
	e2:SetOperation(s.desop1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end

function s.descon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return false
	end
	return true
end

function s.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.SetLP(tp,Duel.GetLP(tp)-(tc:GetBaseAttack()+tc:GetBaseDefense()))
		if Duel.GetLP(tp)<=0 then
			Duel.SetLP(tp,4000)
			Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65820000,e,REASON_EFFECT,tp,tp,4000)
		end
	end
end