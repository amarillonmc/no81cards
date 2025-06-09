--逆源质拼图545
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,1,99)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1153)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	--e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1,id)
	e2:SetCountLimit(2)
	e2:SetCost(s.setcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	--selfdes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(s.descon)
	c:RegisterEffect(e7)
end
function s.mfilter(c,xyzc)
	return c.MoJin==true and c:IsType(TYPE_PENDULUM)  and not c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.descon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.filter(c)
	return c.MoJin==true and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		return --Duel.GetLocationCount(tp,LOCATION_SZONE) and 
		Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	--if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end