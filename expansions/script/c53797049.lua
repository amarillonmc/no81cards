if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),1,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCost(s.spcost)
	e1:SetOperation(s.spcop)
	c:RegisterEffect(e1)
	c:SetSPSummonOnce(id)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local sg=Group.CreateGroup()
		sg:KeepAlive()
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetLabelObject(sg)
		ge0:SetOperation(s.geop)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.chainop)
		Duel.RegisterEffect(ge1,0)
		s.effects={}
	end
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	if SNNM.IsInTable(re,s.effects) then Duel.SetChainLimit(aux.FALSE) end
end
function s.cfilter(c)
	return not c:IsPublic() and c:IsType(TYPE_FLIP)
end
function s.spcost(e,c,tp,st)
	if st&SUMMON_TYPE_LINK~=SUMMON_TYPE_LINK then return true end
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil)
end
function s.spcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(66)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsHasEffect(EFFECT_PUBLIC) and c:IsType(TYPE_FLIP) and c:IsRace(RACE_FIEND) and c:IsLevel(2) and c:GetFlagEffect(id)>0
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+id,e,0,tp,tp,0)
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(nil,0,0xff,0xff,sg)
	if #g==0 then return end
	sg:Merge(g)
	local cp={}
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,te,bool)
		if te:IsActivated() and te:GetType()&EFFECT_TYPE_FLIP~=0 then table.insert(cp,te:Clone()) end
		return f(tc,te,bool)
	end
	for tc in aux.Next(g) do
		Duel.CreateToken(tp,tc:GetOriginalCode())
		for _,v in pairs(cp) do
			tc:RegisterFlagEffect(id,0,0,0)
			local e1=v:Clone()
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e1:SetCode(EVENT_CUSTOM+id)
			e1:SetRange(LOCATION_HAND)
			f(tc,e1,true)
			table.insert(s.effects,e1)
		end
		cp={}
	end
	Card.RegisterEffect=f
end
