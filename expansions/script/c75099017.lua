--双冰之圣镜
function c75099017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,75099017)
	e1:SetTarget(c75099017.target)
	e1:SetOperation(c75099017.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,75099017)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(c75099017.operation)
	c:RegisterEffect(e3)
c75099017.frozen_list=true
end
function c75099017.filter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsCanAddCounter(0x1750,1)
end
function c75099017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c75099017.filter,1,nil,tp) end
	local g=eg:Filter(c75099017.filter,nil,tp)
	Duel.SetTargetCard(g)
end
function c75099017.desfilter(c)
	return c:GetCounter(0x1750)>0
end
function c75099017.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then return end
	for tc in aux.Next(g) do
		if tc:IsCanAddCounter(0x1750,1) and tc:AddCounter(0x1750,1) and tc:GetFlagEffect(75099001)==0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCondition(c75099017.frcon)
			e1:SetValue(tc:GetAttack()*-1/4)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(tc:GetDefense()*-1/4)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(75099001,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
	local dg=Duel.GetMatchingGroup(c75099017.desfilter,tp,0,LOCATION_MZONE,g)
	if #dg>0 then
		Duel.BreakEffect()
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c75099017.frcon(e)
	return e:GetHandler():GetCounter(0x1750)>0
end
function c75099017.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(HALF_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetTargetRange(0,1)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL+PHASE_END)
	e2:SetValue(DOUBLE_DAMAGE)
	Duel.RegisterEffect(e2,tp)
end
