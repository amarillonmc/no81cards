--星诞灾变 利维坦
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,3)
	c:EnableReviveLimit()
	--rank
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_RANK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCountLimit(1)
	e2:SetCost(s.e2cost)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
end
function s.val(e,c)
	return e:GetHandler():GetOverlayCount()
end
function s.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		--atk up
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
		e1:SetValue(s.atkval)
		c:RegisterEffect(e1)
		--overlay
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_SEND_REPLACE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e2:SetTarget(s.reptg)
		e2:SetValue(s.repval)
		e2:SetOperation(s.repop)
		c:RegisterEffect(e2)
		--
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(id,3))
	end
end
function s.atkval(e)
	return e:GetHandler():GetRank()*600
end
function s.repfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetDestination()==LOCATION_GRAVE and c:IsControler(1-tp)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp) end
	local g=eg:Filter(s.repfilter,nil,tp)
	e:SetLabelObject(g)
	return true
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.exfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and c:GetFlagEffect(id)>0
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	if not c:IsLocation(LOCATION_MZONE) or not c:IsType(TYPE_XYZ) then return end
	if #g>0 then
		local gg=Group.CreateGroup()
		for tc in aux.Next(g) do
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				gg:Merge(og)
			end
		end
		if Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_MZONE,0,1,c) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
			local sg=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_MZONE,0,1,1,nil)
			if #sg>0 then
				Duel.HintSelection(sg)
				if #gg>0 then Duel.SendtoGrave(gg,REASON_RULE) end
				local tc=sg:GetFirst()
				Duel.Overlay(tc,g)
			end
		else
			if #gg>0 then Duel.SendtoGrave(gg,REASON_RULE) end
			Duel.Overlay(c,g)
		end
	end
end