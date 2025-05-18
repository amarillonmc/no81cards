--魂锁链王·轴
local s,id,o=GetID()
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,3,true)
	aux.AddContactFusionProcedure(c,s.cfilter,LOCATION_ONFIELD,0,Duel.SendtoGrave,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(aux.chainreg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(s.op)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_HAND,0)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x355))
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e7)
	elements={{"tama_elements",{{TAMA_ELEMENT_EARTH,3},{TAMA_ELEMENT_ENERGY,2}}}}
	s[c]=elements
	
end
function s.ffilter(c)
	return c:IsFusionSetCard(0x355) and c:IsFusionType(TYPE_SPELL+TYPE_TRAP)
end
function s.cfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsFaceup()
end
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function s.efilter(e,te)
	return te:GetHandler():IsSetCard(0x355) and te:GetOwner()~=e:GetOwner()
end
function s.disfilter(c,e)
	return c:IsFaceup() and c:IsAttackBelow(0) and c:IsCanBeDisabledByEffect(e)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:IsActiveType(TYPE_QUICKPLAY) and c:GetFlagEffect(FLAG_ID_CHAINING)>0 then
		local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c)
		if g1:GetCount()>0 then
			local sc=g1:GetFirst()
			while sc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(-400)
				sc:RegisterEffect(e1)
				sc=g1:GetNext()
			end
		end
		local g=Duel.GetMatchingGroup(s.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,e)
		if g:GetCount()>0 then
			local sc=g:GetFirst()
			while sc do
				Duel.NegateRelatedChain(sc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e2)
				sc=g:GetNext()
			end
		end
	end
end
