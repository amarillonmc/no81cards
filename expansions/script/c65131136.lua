--秘计螺旋 机构
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.tmtg)
	e3:SetOperation(s.tmop)
	c:RegisterEffect(e3)
end
function s.setfilter(c)
	return c:IsSSetable()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local dc=g:Select(tp,1,1,nil):GetFirst()
		if dc and Duel.SSet(tp,dc,tp,false)>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_SZONE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(s.efilter)
			e1:SetOwnerPlayer(tp)
			dc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_TRIGGER)
			e2:SetRange(LOCATION_SZONE)
			dc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetCountLimit(1)
			e3:SetLabelObject(e2)
			e3:SetLabel(3)
			e3:SetCondition(s.turncon)
			e3:SetOperation(s.turnop)
			e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
			Duel.RegisterEffect(e3,tp)
			dc:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,3)
			local cs=getmetatable(dc)
			cs[dc]=e3
		end
	end
end
function s.turncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.turnop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	ct=ct-1
	e:SetLabel(ct)
	e:GetHandler():SetTurnCounter(ct)
	if ct==0 then
		e:GetLabelObject():Reset()
		e:GetOwner():ResetFlagEffect(1082946)
		e:Reset()
	end
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()==re:GetOwnerPlayer() and e:GetHandler()~=re:GetHandler() and re:IsActivated()
end
function s.tmfilter(c)
	return c:GetFlagEffect(1082946)~=0
end
function s.tmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(s.tmfilter,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
end
function s.tmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tmfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	for tc in aux.Next(g) do
		local turne=tc[tc]
		local op=turne:GetOperation()
		op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
	end
	Duel.BreakEffect()
	Duel.Draw(p,g:GetCount(),REASON_EFFECT)
end