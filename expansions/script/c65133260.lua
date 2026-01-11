--幻叙叙幻
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.chcon)
	e1:SetOperation(s.chop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		_ChangeChainOperation=Duel.ChangeChainOperation
		function Duel.ChangeChainOperation(ev,op)
			local e,tp=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetMatchingGroupCount(s.affilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil) >0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				_ChangeChainOperation(ev,s.chop2(op))
			else
				_ChangeChainOperation(ev,op)
			end
		end
	end
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and e:GetHandler():IsHasEffect(id)
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c) then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		local ce=c:IsHasEffect(id)
		local op=ce:GetOperation()
		Duel.ChangeChainOperation(ev,op)
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function s.affilter(c,tp)
	return c:IsCode(id) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true) and not c:IsForbidden()
end
function s.chop2(op)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
		local tc=Duel.GetMatchingGroup(s.affilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil):Select(tp,1,1,nil):GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local ae=Effect.CreateEffect(e:GetHandler())
			ae:SetType(EFFECT_TYPE_SINGLE)
			ae:SetRange(LOCATION_SZONE)
			ae:SetCode(id)
			ae:SetOperation(op)
			ae:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(ae)
		end
	end
end






