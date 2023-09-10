--思 维 绽 放
local m=22348315
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22348315.condition)
	e1:SetTarget(c22348315.target)
	e1:SetOperation(c22348315.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(22348315,ACTIVITY_CHAIN,c22348315.chainfilter)
end
function c22348315.chainfilter(re,tp,cid)
	return true
end
function c22348315.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c22348315.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSummonType,tp,0,LOCATION_MZONE,1,nil,SUMMON_TYPE_SPECIAL)
		or Duel.IsExistingMatchingCard(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,1,nil)
		or Duel.IsPlayerCanDraw(tp,2) end
	if Duel.GetCustomActivityCount(22348315,1-tp,ACTIVITY_CHAIN)~=0 then
	   Duel.SetChainLimit(c22348315.chlimit)
	end
end
function c22348315.chlimit(e,rp,tp)
	return tp==rp
end
function c22348315.activate(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(22348315,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(Card.IsSummonType,tp,0,LOCATION_MZONE,1,nil,SUMMON_TYPE_SPECIAL) then
		ops[off]=aux.Stringid(22348315,1)
		opval[off-1]=2
		off=off+1
	end
	if Duel.IsPlayerCanDraw(tp,2) then
		ops[off]=aux.Stringid(22348315,2)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(1-tp,table.unpack(ops))
	if opval[op]==1 then
		local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
		end
	elseif opval[op]==2 then
		local sg=Duel.GetMatchingGroup(Card.IsSummonType,tp,0,LOCATION_MZONE,nil,SUMMON_TYPE_SPECIAL)
		Duel.Destroy(sg,REASON_EFFECT)
	elseif opval[op]==3 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
