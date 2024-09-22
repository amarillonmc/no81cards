--匹诺康尼-黄金的时刻-
function c60010141.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c60010141.accon)
	c:RegisterEffect(e0)
	--disable summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	c:RegisterEffect(e1)
	--draw 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c60010141.drop)
	c:RegisterEffect(e2)
	--code
	aux.EnableChangeCode(c,60010029,LOCATION_HAND+LOCATION_DECK+LOCATION_FZONE+LOCATION_GRAVE)
	--summon count
	Duel.AddCustomActivityCounter(60010141,ACTIVITY_SUMMON,aux.FALSE)
	--race count
	if not c60010141.race_check then
		c60010141.race_check={}
		c60010141.race_check[0]={}
		c60010141.race_check[1]={}
	end
end
function c60010141.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(60010141,tp,ACTIVITY_SUMMON)==0
end
function c60010141.filter(c,p)
	local race=c:GetRace()
	return c:IsControler(p) and c:IsFaceup() and c60010141.race_check[p][race]==nil
end
function c60010141.drop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c60010141.filter,1,nil,0) then
		Duel.Draw(0,1,REASON_EFFECT)
		Duel.DiscardHand(0,Card.IsDiscardable,1,1,REASON_EFFECT)
		local g0=eg:Filter(c60010141.filter,nil,0)
		for tc in aux.Next(g0) do
			local race=tc:GetRace()
			c60010141.race_check[0][race]=1
			Duel.RegisterFlagEffect(0,60010141,0,0,1)
		end
	end
	if eg:IsExists(c60010141.filter,1,nil,1) then
		Duel.Draw(1,1,REASON_EFFECT)
		Duel.DiscardHand(1,Card.IsDiscardable,1,1,REASON_EFFECT)
		local g1=eg:Filter(c60010141.filter,nil,1)
		for tc in aux.Next(g1) do
			local race=tc:GetRace()
			c60010141.race_check[1][race]=1
			Duel.RegisterFlagEffect(1,60010141,0,0,1)
		end
	end
	if Duel.GetFlagEffect(tp,60010141)>=24 then
		Duel.SetLP(1-tp,0)
	end
end
