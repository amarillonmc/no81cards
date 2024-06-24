local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	if not s.globle_check then
		s.globle_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		if tc:IsReason(REASON_COST) and re and re:IsActivated() then tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1) end
	end
end
function s.spfilter(c)
	return c:GetFlagEffect(id)~=0 and c:IsAbleToRemoveAsCost()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	if Duel.Remove(tc,POS_FACEUP,REASON_SPSUMMON)==0 or not tc:IsLocation(LOCATION_REMOVED) then return end
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(2)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetReset(RESET_EVENT+0x2fe0000)
	e1:SetTarget(s.spelltg)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,1)
	e2:SetLabelObject(e1)
	e2:SetCost(s.costchk)
	e2:SetTarget(s.costtg)
	e2:SetOperation(s.costop)
	tc:RegisterEffect(e2)
end
function s.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local le={e:GetHandler():GetActivateEffect()}
	local check=false
	if chk==0 then
		e:SetCostCheck(false)
		for _,te in pairs(le) do
			local ftg=te:GetTarget()
			if (not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)) then check=true end
		end
		return check
	end
	local off=1
	local ops={}
	local opval={}
	for i,te in pairs(le) do
		local tg=te:GetTarget()
		e:SetCostCheck(false)
		if (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
			local des=te:GetDescription()
			if des then ops[off]=des else ops[off]=aux.Stringid(id,0) end
			opval[off-1]=i
			off=off+1
		end
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	local ae=le[sel]
	local cat=ae:GetCategory()
	if cat then e:SetCategory(cat) else e:SetCategory(0) end
	local pro,pro2=ae:GetProperty()
	pro=pro|EFFECT_FLAG_DELAY
	e:SetProperty(pro,pro2)
	local etg=ae:GetTarget()
	if etg then
		e:SetCostCheck(false)
		etg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	e:SetOperation(s.spellop(sel))
end
function s.spellop(sel)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local le={e:GetHandler():GetActivateEffect()}
				local ae=le[sel]
				local fop=ae:GetOperation()
				fop(e,tp,eg,ep,ev,re,r,rp)
	end
end
function s.cfilter(c)
	return c:GetType()==TYPE_SPELL and c:IsDiscardable()
end
function s.costchk(e,te,tp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil)
end
function s.costtg(e,te,tp)
	return te==e:GetLabelObject()
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,s.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
