--安娜·施普伦格尔
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddMaterialCodeList(c,5012604)
	--synchro summon  
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,5012604),1,1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--免疫已发动的效果
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(s.immval)
	c:RegisterEffect(e5)
	
	--上条当麻相关效果
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.drcon)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)

end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cnt=e:GetHandler():GetFlagEffect(id)
	local res=true
	if cnt>0 then
		res=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,cnt,nil)
	end
	if chk==0 then return res end
	Duel.DiscardHand(tp,Card.IsDiscardable,cnt,cnt,REASON_COST+REASON_DISCARD)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingTarget(aux.nzatk,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingTarget(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b3=Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)
	+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
	+Duel.GetLocationCount(tp,LOCATION_SZONE,PLAYER_NONE,0)
	+Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)>0
	if chk==0 then return b1 or b2 or b3 end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingTarget(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b3=Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)
	+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
	+Duel.GetLocationCount(tp,LOCATION_SZONE,PLAYER_NONE,0)
	+Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)>0
	local op=aux.SelectFromOptions(tp,
										{b1,aux.Stringid(id,0),0},
										{b2,aux.Stringid(id,1),1},
										{b3,aux.Stringid(id,2),2})
	if op==0 then
		local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	elseif op==1 then
		local sg=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if sg:GetCount()>0 then
			local sc=sg:GetFirst()
			while sc do
				Duel.NegateRelatedChain(sc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
				sc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
				sc:RegisterEffect(e2)
				if sc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
					sc:RegisterEffect(e3)
				end
				sc=sg:GetNext()
			end
		end
	elseif op==2 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_FIELD)
		e3:SetValue(0xffffffff)
		e3:SetReset(RESET_PHASE+PHASE_END+RESET_CHAIN)
		Duel.RegisterEffect(e3,tp)
	end
end
function s.filter(c)
	return c:IsFaceup() and c:IsCode(5012604)
end
function s.immval(e,te)
	return te:IsActivated()
end

--上条当麻相关效果
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(5012604)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:GetHandler()==e:GetHandler() and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
