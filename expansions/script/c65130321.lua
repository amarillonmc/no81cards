--无限大伊吕波
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.matfilter,3,true)
	aux.AddContactFusionProcedure(c,s.matfilter2,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,0,aux.tdcfop(c))
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--attack cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_COST)
	e1:SetCost(s.atcost)
	e1:SetOperation(s.atop)
	c:RegisterEffect(e1)
end
function s.matfilter(c)
	return c:IsAttack(878) and c:IsDefense(1157)
end
function s.matfilter2(c)
	return c:IsAbleToDeckAsCost() and (c:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) or c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_PENDULUM) and c:IsFaceup())
end
function s.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function s.eftg(e,c)
	return c:GetBaseAttack()==878
end
function s.tdfilter(c,atk)
	return c:IsAbleToDeckAsCost() and c:IsAttack(atk) and c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER>0
end
function s.atcost(e,c,tp)
	return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,c:GetAttack())
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil,c:GetAttack())
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_ACTION)
	local tg=Duel.GetOperatedGroup()
	local sg=Group.CreateGroup()
	for tc in aux.Next(tg) do
		if not sg:IsExists(Card.IsCode,1,nil,tc:GetCode()) then
			sg:AddCard(tc)
			--damage change
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,0))
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetOperation(s.damop)
			c:RegisterEffect(e1)
		end
	end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetLabel())
	Duel.Damage(1-tp,ev,REASON_EFFECT)
end