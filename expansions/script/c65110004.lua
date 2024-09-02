--沙漠雇佣兵 马修
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65110000)
	--effect gain
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_ATTACK_ANNOUNCE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(s.descon)
	e0:SetTarget(s.destg)
	e0:SetOperation(s.desop)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.eftg)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--overlay
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.ovcon)
	e2:SetTarget(s.ovtg)
	e2:SetLabelObject(e1)
	e2:SetOperation(s.ovop)
	c:RegisterEffect(e2)
	aux.RegisterMergedDelayedEvent(c,id,EVENT_SPSUMMON_SUCCESS)
	aux.RegisterMergedDelayedEvent(c,id,EVENT_SUMMON_SUCCESS)
end
function s.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and aux.IsCodeListed(c,65110000)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=c:GetBattleTarget()
	e:SetLabelObject(ac)
	return ac and ac:IsControler(1-tp)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition() end
	local ac=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ac,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:IsFaceup() and tc:IsControler(1-tp) and tc:IsType(TYPE_MONSTER) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
function s.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.ovfilter(c,e)
	return c:IsFaceup() and c:IsCode(65110000) and c:IsType(TYPE_XYZ) and not c:IsImmuneToEffect(e)
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local oe=e:GetLabelObject()
	local oe1=oe:Clone()
	local g=Duel.GetMatchingGroup(s.ovfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and g:GetCount()>0 and c:IsLocation(LOCATION_MZONE) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
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
		Duel.Overlay(sc,c)
		local dg=eg:Filter(Card.IsControler,nil,1-tp)
		Duel.Destroy(dg,REASON_EFFECT)
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