--汐击龙顶“云间海”
local cm,m=GetID()
function cm.initial_effect(c)
	--check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.damcon)
	e3:SetOperation(cm.damop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(0,11451760,RESET_CHAIN,0,1)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x9977) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():GetFlagEffect(m)>0
end
function cm.filter(c)
	return c:IsSetCard(0x9977) and (c:IsAbleToRemove() or c:IsAbleToExtra())
end
function cm.filter1(c)
	return c:GetOriginalType()&TYPE_PENDULUM>0
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	if cm.filter1(rc) then
		g=g-g:Filter(cm.filter1,nil)
	--elseif re:IsActiveType(TYPE_TRAP) then
		--g=g-g:Filter(Card.IsType,nil,TYPE_TRAP)
	else
		g=g:Filter(cm.filter1,nil) --+g:Filter(Card.IsType,nil,TYPE_TRAP)
	end
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sc=g:Select(tp,1,1,nil):GetFirst()
	if not sc:IsAbleToExtra() or (sc:IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
		Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
	else
		Duel.SendtoExtraP(sc,nil,REASON_EFFECT)
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local eeg=eg:Filter(cm.spfilter,nil)
	if #eeg==0 then return end
	local eeg1=eg:Filter(cm.filter1,nil)
	local eeg2=Group.CreateGroup() --eg:Filter(Card.IsType,nil,TYPE_TRAP)
	local eeg3=eg-eeg1-eeg2
	if #eeg1>0 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
		g=g-g:Filter(cm.filter1,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			if not sc:IsAbleToExtra() or (sc:IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
				Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
			else
				Duel.SendtoExtraP(sc,nil,REASON_EFFECT)
			end
		end
	end
	if #eeg2>0 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
		g=g-g:Filter(Card.IsType,nil,TYPE_TRAP)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			if not sc:IsAbleToExtra() or (sc:IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
				Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
			else
				Duel.SendtoExtraP(sc,nil,REASON_EFFECT)
			end
		end
	end
	if #eeg3>0 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
		g=g:Filter(cm.filter1,nil) --+g:Filter(Card.IsType,nil,TYPE_TRAP)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			if not sc:IsAbleToExtra() or (sc:IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
				Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
			else
				Duel.SendtoExtraP(sc,nil,REASON_EFFECT)
			end
		end
	end
end
function cm.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9977)
end