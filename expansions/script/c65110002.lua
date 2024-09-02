--泰坦工程师 玛丽安
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65110000)
	--Atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.atkfilter)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	local e10=e1:Clone()
	e10:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetLabelObject(e10)
	c:RegisterEffect(e1)
	c:RegisterEffect(e10)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabelObject(e1)
	e2:SetCost(s.ovcost)
	e2:SetTarget(s.ovtg)
	e2:SetOperation(s.ovop)
	c:RegisterEffect(e2)
end
function s.atkfilter(e,c)
	return aux.IsCodeListed(c,65110000) and c:IsFaceup()
end
function s.cfilter(c)
	return aux.IsCodeListed(c,65110000) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function s.tdlimit(e,c,tp,r,re)
	return c:IsType(e:GetLabel()) and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsCode(id) and r==REASON_COST
end
function s.ovcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetType())
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_TO_GRAVE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.tdlimit)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.ovfilter(c,e)
	return c:IsFaceup() and c:IsCode(65110000) and c:IsType(TYPE_XYZ) and not c:IsImmuneToEffect(e)
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand() or (c:IsCanOverlay() and Duel.IsExistingMatchingCard(s.ovfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e))
	end
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local oe=e:GetLabelObject()
	local oe1=oe:Clone()
	local oe2=oe:GetLabelObject():Clone()
	local g=Duel.GetMatchingGroup(s.ovfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if g:GetCount()>0 and (not c:IsAbleToHand() or Duel.SelectOption(tp,1190,aux.Stringid(id,2))==1) then
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
	elseif c:IsAbleToHand() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
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