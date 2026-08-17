--世坏凯歌
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,56099748)
	c:EnableCounterPermit(0x69)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetOperation(s.adjustop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_DESTROY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(s.acop)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.cfcon)
	e2:SetTarget(s.damtg)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(id)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(Card.IsType,nil,TYPE_MONSTER)
	if ct>0 then
		e:GetHandler():AddCounter(0x69,ct,true)
	end
end
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and (c:IsCode(56099748) or c:IsSetCard(0x19a))
end
function s.cfcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetCounter(0x69)
	if chk==0 then return ct>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*100)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x69)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if c:IsRelateToEffect(e) and ct>0 then
		Duel.Damage(p,ct*100,REASON_EFFECT)
	end
end
function s.etcfilter(c,tp)
	return c:IsHasEffect(id) and c:IsCanRemoveCounter(tp,0x69,1,REASON_COST)
end
function s.etcostf(n)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local ct=Duel.GetMatchingGroup(s.etcfilter,tp,LOCATION_SZONE,0,nil,tp):GetSum(Card.GetCounter,0x69)
		if ct>n then ct=n end
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,n-ct,nil,POS_FACEDOWN) end
		local ct1=0
			if ct>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			local tbl={}
			for i=1,ct do
				table.insert(tbl,i)
			end
			ct1=Duel.AnnounceNumber(tp,table.unpack(tbl))
			Duel.Hint(HINT_CARD,0,id)
			for i=1,ct1 do
				local sc=Duel.SelectMatchingCard(tp,s.etcfilter,tp,LOCATION_SZONE,0,1,1,nil,tp):GetFirst()
				sc:RemoveCounter(tp,0x69,1,REASON_COST)
			end
			if ct1==n then return end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,n-ct1,n-ct1,nil,POS_FACEDOWN)
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	end
end
function s.filter(c)
	return c:IsSetCard(0x19a) and c:IsType(TYPE_MONSTER)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if not s.globle_check then
		s.globle_check=true
		local g=Duel.GetMatchingGroup(s.filter,0,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		disexistingmatchingcard=Duel.IsExistingMatchingCard
		local marked=0
		Duel.IsExistingMatchingCard=function(filter,player,s,o,count,c_g_n,pos,...)
			if pos==POS_FACEDOWN then
				marked=count
				return true
			end
			return false
		end
		Card.RegisterEffect=function(card,effect)
			marked=0
			local cost=effect:GetCost()
			if cost and cost(e,tp,eg,ep,ev,re,r,rp,0) then end
			if marked>0 then
				effect:SetCost(s.etcostf(marked))
			end
			cregister(card,effect,true)
		end
		for tc in aux.Next(g) do
			Duel.CreateToken(0,tc:GetOriginalCodeRule())
			tc:ReplaceEffect(tc:GetOriginalCodeRule(),0)
		end
		Card.RegisterEffect=cregister
		Duel.IsExistingMatchingCard=disexistingmatchingcard
	end
	e:Reset()
end
