--仙山拳师 佩儿
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65110000)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetCondition(s.reccon)
	e1:SetOperation(s.recop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabelObject(e1)
	e2:SetTarget(s.ovtg)
	e2:SetOperation(s.ovop)
	c:RegisterEffect(e2)
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and eg:GetFirst():IsControler(tp)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(s.ovfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e) and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.ovfilter(c,e)
	return c:IsFaceup() and c:IsCode(65110000) and c:IsType(TYPE_XYZ) and not c:IsImmuneToEffect(e)
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local oe=e:GetLabelObject()
	local oe1=oe:Clone()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(s.ovfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE) and tc:IsRelateToEffect(e) then
		Duel.CalculateDamage(c,tc)
		if c:IsLocation(LOCATION_MZONE) and not c:IsStatus(STATUS_BATTLE_DESTROYED) then
			Duel.BreakEffect()
			local sc=g:GetFirst()
			if g:GetCount()>1 then sc=g:Select(tp,1,1,nil):GetFirst() end
			local seq=c:GetSequence()
			local etype=oe1:GetType()
			local con=oe1:GetCondition()
			if not con then con=aux.TRUE end
			oe1:SetCondition(s.chcon(con,seq))
			oe1:SetType(etype|EFFECT_TYPE_XMATERIAL)
			if sc:IsType(TYPE_SPELL+TYPE_TRAP) then
				oe1:SetRange(LOCATION_SZONE)
			end
			c:RegisterEffect(oe1)
			local re=Effect.CreateEffect(c)
			re:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			re:SetRange(0xff)
			re:SetCode(EVENT_ADJUST)
			re:SetLabelObject(oe1)
			re:SetOperation(s.resetop)
			c:RegisterEffect(re)
			if etype&EFFECT_TYPE_GRANT==0 and oe2 then
				local etype2=oe2:GetType()
				local con2=oe2:GetCondition()
				if not con2 then con2=aux.TRUE end
				oe2:SetCondition(s.chcon(con2,seq))
				oe2:SetType(etype|EFFECT_TYPE_XMATERIAL)
				if sc:IsType(TYPE_SPELL+TYPE_TRAP) then
					oe2:SetRange(LOCATION_SZONE)
				end
				c:RegisterEffect(oe2)
				local re=Effect.CreateEffect(c)
				re:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				re:SetRange(0xff)
				re:SetCode(EVENT_ADJUST)
				re:SetLabelObject(oe2)
				re:SetOperation(s.resetop)
				c:RegisterEffect(re)
			end
			Duel.Overlay(sc,c)
		end
	end
end
function s.chcon(con,seq)
	return function(e,tp,...)
				if Duel.GetFieldCard(tp,LOCATION_MZONE,seq) then return false end
				return con(e,tp,...)
			end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
	e:Reset()
end