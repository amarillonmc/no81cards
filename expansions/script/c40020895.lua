--泰兹卡特利波卡的甲兽神殿
local s,id=GetID()
s.named_with_ArmoredBeast=1

s.TEZCATLIPOCA_CODE=40020796

function s.ArmoredBeast(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ArmoredBeast
end

function s.initial_effect(c)
	aux.AddCodeList(c,40020796)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.atktg)
	e2:SetValue(1000)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(s.chaincon)
	e3:SetOperation(s.chainop)
	c:RegisterEffect(e3)
end

function s.pzfilter(c)
	return c:IsCode(s.TEZCATLIPOCA_CODE) and not c:IsForbidden() and c:IsType(TYPE_PENDULUM)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local hasZone = Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if hasZone 
		and Duel.IsExistingMatchingCard(s.pzfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,s.pzfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end

function s.atktg(e,c)
	return s.ArmoredBeast(c)
end
function s.rmcfilter(c)
	return c:IsFaceup() and s.ArmoredBeast(c)
end

function s.chaincon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(s.rmcfilter,tp,LOCATION_REMOVED,0,nil) < 5 then return false end
	if rp~=tp then return false end
	local rc=re:GetHandler()
	return rc and s.ArmoredBeast(rc)
end

function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(s.chainlm)
end

function s.chainlm(e,rp,tp)
	return tp==rp
end
