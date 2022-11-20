--进入土俵！
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate MoveToPzone
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.GetFieldCard(tp,LOCATION_PZONE,0) and not Duel.GetFieldCard(tp,LOCATION_PZONE,1)
end
function s.penfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_SPIRIT) 
		and not c:IsForbidden()
end
function s.filter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(s.penfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.penfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		local pg=Duel.GetMatchingGroup(s.filter,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,nil)
		if pg and pg:GetCount()>0 then
			local dg=Group.CreateGroup()
			for tc in aux.Next(pg) do
				local mt=getmetatable(tc)
				local loc=mt.psummonable_location
				if loc==nil then 
					loc=0xff 
					mt.psummonable_location=loc
				else
					dg:AddCard(tc)
				end
			end
			pg:Sub(dg)
			if pg:GetCount()>0 then
				pg:KeepAlive()
				--Reset
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetLabelObject(pg)
				e1:SetOperation(s.resop)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function s.resop(e,tp,eg,ep,ev,re,r,rp)
	local pg=e:GetLabelObject()
	for tc in aux.Next(pg) do
		local mt=getmetatable(tc)
		mt.psummonable_location=nil
	end
end
