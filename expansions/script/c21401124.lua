--S.B.系统 盯守扫荡
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(s.reptg)
	e3:SetValue(s.repval)
	c:RegisterEffect(e3)
end


function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_EFFECT) and re:GetHandler():IsType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function s.tgfilter(c,tp,ori)
	return c:IsFaceup() and c:IsSetCard(0x3d70) and c:IsControler(tp) and c~=ori
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return s.tgfilter(chkc,tp) and chkc~=c and chkc:IsOnField() end
	if chk==0 then
		Debug.Message(Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_ONFIELD,0,1,nil,tp,c))
	return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_ONFIELD,0,1,nil,tp,c) end
		
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp,c)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
		local tc=Duel.GetFirstTarget()
		local rc=re:GetHandler()
		if not tc:IsRelateToEffect(e) then return end
		if Duel.Destroy(tc,REASON_EFFECT) > 0 then
			--Debug.Message("trap in 1")
			Duel.BreakEffect()
			if rc:IsRelateToEffect(re) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_XYZ) 
				and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,1)) then
				-- ,aux.Stringid(id,1)
				--Debug.Message("trap in 2")
				local xyzg = Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_MZONE,0,1,1,nil,TYPE_XYZ)
				local xyzc = xyzg:GetFirst()
				Duel.Overlay(xyzc,rc)
			end
		end
	end
end


function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsLevel(2) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
	--return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and (c:IsLevel(2) or c:IsRank(2) or c:IsLink(2) ) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end

function s.tdfilter(c)
	return c:IsSetCard(0x3d70) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		--Debug.Message("checking broken:" .. tostring(eg:IsExists(s.repfilter,1,nil,tp)))
		return eg:IsExists(s.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) 
		
	end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		Duel.SendtoDeck(g,tp,2,REASON_EFFECT+REASON_REPLACE)
		return true
	end
	return false
end

function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end