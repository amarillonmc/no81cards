local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.immval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.eqcon1)
	e2:SetOperation(s.eqop1)
	c:RegisterEffect(e2)
	local e2_1=e2:Clone()
	e2_1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2_1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.regcon)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
	local e3_1=e3:Clone()
	e3_1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3_1)
	local sg=Group.CreateGroup()
	sg:KeepAlive()
	e3:SetLabelObject(sg)
	e3_1:SetLabelObject(sg)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.eqcon2)
	e4:SetOperation(s.eqop2)
	c:RegisterEffect(e4)
	e4:SetLabelObject(sg)
end
function s.immval(e,te)
	return te:GetOwner()~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER) and te:GetOwner():GetEquipCount()>0
end
function s.eqfilter(c,tc,tp)
	return c:IsCode(69954399) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function s.filter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c,tp)
end
function s.eqcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,tp) and not eg:IsContains(e:GetHandler()) and not Duel.IsChainSolving()
end
function s.eqop1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.filter,nil,tp)
	s.eqop(e,tp,g)
end
function s.eqop(e,tp,g)
	Duel.Hint(HINT_CARD,0,id)
	local tc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	if #g>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ec=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc,tp):GetFirst()
	if not ec or not Duel.Equip(tp,ec,tc) or not ec:IsOnField() then return end
	ec:SetTurnCounter(0)
	if ec:IsPreviousLocation(LOCATION_HAND) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1,true)
	end
	local cp={}
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(sc,te,bool)
		if te:GetCode()==EVENT_PHASE+PHASE_END and te:GetType()&0x202==0x202 and te:GetRange()==LOCATION_SZONE then table.insert(cp,te:Clone()) end
		return f(sc,te,bool)
	end
	Duel.CreateToken(tp,ec:GetOriginalCode())
	for _,v in pairs(cp) do
		local e1=Effect.CreateEffect(ec)
		e1:SetDescription(aux.Stringid(ec:GetOriginalCode(),0))
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_CUSTOM+id)
		e1:SetRange(LOCATION_SZONE)
		if v:GetCost() then e1:SetCost(v:GetCost()) end
		if v:GetTarget() then e1:SetTarget(v:GetTarget()) end
		if v:GetOperation() then e1:SetOperation(v:GetOperation()) end
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		f(ec,e1,true)
		local e2=Effect.CreateEffect(ec)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCondition(s.con)
		e2:SetOperation(s.op)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		f(ec,e2,true)
		local e3=e2:Clone()
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		f(ec,e3,true)
	end
	Card.RegisterEffect=f
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,e:GetHandler():GetEquipTarget():GetControler())
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffectLabel(id) or 0
	if ct==1 then Duel.RaiseSingleEvent(c,EVENT_CUSTOM+id,e,0,tp,tp,0) end
	if ct>1 then ct=1 end
	c:ResetFlagEffect(id)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,ct+1,aux.Stringid(id,ct))
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,tp) and not eg:IsContains(e:GetHandler()) and Duel.IsChainSolving()
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	sg:Merge(eg:Filter(s.filter,nil,tp))
end
function s.eqcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetCount()>0
end
function s.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	local g=sg:Clone()
	sg:Clear()
	s.eqop(e,tp,g)
end
