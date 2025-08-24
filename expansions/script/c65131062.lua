--救世之章 加速
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,s.mfilter,nil,nil,aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),1,99)
	c:EnableReviveLimit()
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(0xff)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.cpcon)
	e1:SetCost(s.cpcost)
	e1:SetTarget(s.cptg)
	e1:SetOperation(s.cpop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0xff,0)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.condition)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.mfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_TUNER)
end
function s.cpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local con=re:GetCondition()
	if not con then con=aux.TRUE end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)   
	if Duel.GetFlagEffect(tp,id)>0 or re:GetCode()==EVENT_SUMMON or re:GetCode()==EVENT_SPSUMMON or re:GetCode()==EVENT_FLIP_SUMMON then return false end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	local res=re:GetHandler()==c and c:IsLocation(loc) and ep==tp and con(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,id)
	return res
end
function s.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cost=re:GetCost()
	if not cost then cost=aux.TRUE end
	e:SetCategory(re:GetCategory())
	e:SetProperty(re:GetProperty())
	e:SetLabel(re:GetLabel())
	e:SetLabelObject(re:GetLabelObject())
	if chk==0 then return cost(e,tp,eg,ep,ev,re,r,rp,chk) end
	Duel.Hint(HINT_CARD,0,id)
	cost(e,tp,eg,ep,ev,re,r,rp,chk)
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tg=re:GetTarget()
	if not tg then tg=aux.TRUE end
	if chk==0 then return tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local op=re:GetOperation()
	if not op then op=aux.TRUE end
	op(e,tp,eg,ep,ev,re,r,rp)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or rp~=tp then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc:IsOnField()
end
function s.filter(c,ct)
	return Duel.CheckChainTarget(ct,c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=ev
	if chkc then return chkc:IsOnField() and s.filter(chkc,ct) end
	if chk==0 then return re:GetHandler():CheckActivateEffect(true,true,false)~=nil and Duel.IsExistingTarget(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetLabelObject(),ct) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetLabelObject(),ct)
	local te,ceg,cep,cev,cre,cr,crp=re:GetHandler():CheckActivateEffect(true,true,true)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	local _SelectTarget=Duel.SelectTarget
	function Duel.SelectTarget()
		return tc
	end
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	Duel.SelectTarget=_SelectTarget
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end