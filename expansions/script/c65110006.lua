--勇士挑战者 克雷格
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65110000)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetValue(s.indct)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_HAND)
	e2:SetLabelObject(e1)
	e2:SetCondition(s.ovcon)
	e2:SetTarget(s.ovtg)
	e2:SetOperation(s.ovop)
	c:RegisterEffect(e2)
end
function s.target(e,c)
	return aux.IsCodeListed(c,65110000)
end
function s.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		Duel.Hint(HINT_CARD,0,id)
		return 1
	else return 0 end
end
function s.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.ovfilter(c,e)
	return c:IsFaceup() and c:IsCode(65110000) and c:IsType(TYPE_XYZ) and not c:IsImmuneToEffect(e)
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local oe=e:GetLabelObject()
	local oe1=oe:Clone()
	local oe2=oe:GetLabelObject():Clone()
	local g=Duel.GetMatchingGroup(s.ovfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 and g:GetCount()>0 and c:IsLocation(LOCATION_MZONE) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
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
		Duel.NegateAttack()
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