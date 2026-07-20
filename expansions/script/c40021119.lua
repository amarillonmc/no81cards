--倪克斯的幽魔神殿

local s,id=GetID()
s.named_with_Darkling=1

s.NYX_CODE=40021115
s.COUNTER_DARKLING=0x2f1e

function s.Darkling(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkling
end

function s.initial_effect(c)

	aux.AddCodeList(c,s.NYX_CODE)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.drcon)
	e2:SetCost(s.drcost)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2a)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(s.ctcon)
	e3:SetOperation(s.ctop)
	c:RegisterEffect(e3)
end

function s.pzfilter(c)
	return c:IsCode(s.NYX_CODE) and not c:IsForbidden() and c:IsType(TYPE_PENDULUM)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local hasZone = Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if hasZone 
		and Duel.IsExistingMatchingCard(s.pzfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,s.pzfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end

function s.sumfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and s.Darkling(c)
end

function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.sumfilter,1,nil,tp)
end

function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,s.COUNTER_DARKLING,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,s.COUNTER_DARKLING,1,REASON_COST)
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function s.nyx_filter(c)
	return c:IsFaceup() and c:IsCode(s.NYX_CODE) and c:IsCanAddCounter(s.COUNTER_DARKLING,1)
end

function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	if ev<=0 then return false end
	
	local pz0=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local pz1=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local valid0 = (pz0 and s.nyx_filter(pz0))
	local valid1 = (pz1 and s.nyx_filter(pz1))
	
	return valid0 or valid1
end

function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local pz0=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local pz1=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local valid0 = (pz0 and s.nyx_filter(pz0))
	local valid1 = (pz1 and s.nyx_filter(pz1))
	
	if valid0 and valid1 then
		local g=Group.FromCards(pz0, pz1)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			tc:AddCounter(s.COUNTER_DARKLING,1)
		end
	elseif valid0 then
		pz0:AddCounter(s.COUNTER_DARKLING,1)
	elseif valid1 then
		pz1:AddCounter(s.COUNTER_DARKLING,1)
	end
end