--汐击龙顶“云间海”
local cm,m=GetID()
function cm.initial_effect(c)
	--check
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e00:SetCode(EVENT_REMOVE)
	e00:SetCondition(aux.ThisCardInGraveAlreadyCheckReg)
	c:RegisterEffect(e00)
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
	e2:SetRange(LOCATION_SZONE+LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE+LOCATION_REMOVED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.damcon)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if chk==0 then
						if c:IsLocation(LOCATION_REMOVED) then return Duel.GetFlagEffect(tp,m)==0 elseif c:IsOnField() then return Duel.GetFlagEffect(tp,m+1)==0 end
						return true
					end
					if c:IsLocation(LOCATION_REMOVED) then Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1) elseif c:IsOnField() then Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1) end
				end)
	e3:SetOperation(cm.damop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE+LOCATION_REMOVED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetLabelObject(e00)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if chk==0 then
						if c:IsLocation(LOCATION_REMOVED) then return Duel.GetFlagEffect(tp,m)==0 elseif c:IsOnField() then return Duel.GetFlagEffect(tp,m+1)==0 end
						return true
					end
					if c:IsLocation(LOCATION_REMOVED) then Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1) elseif c:IsOnField() then Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1) end
				end)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(0,11451760,RESET_CHAIN,0,1)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	--e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x9977) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.spfilter1(c,se)
	if not (se==nil or c:GetReasonEffect()~=se) then return false end
	return c:IsFaceup() and c:IsSetCard(0x9977)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(cm.spfilter1,1,nil,se)
end
function cm.filter(c)
	return c:IsSetCard(0x9977) and c:IsAbleToHand() --(c:IsAbleToRemove() or c:IsAbleToExtra())
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
	Duel.SendtoHand(sc,nil,REASON_EFFECT)
	--[[if not sc:IsAbleToExtra() or (sc:IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
		Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
	else
		Duel.SendtoExtraP(sc,nil,REASON_EFFECT)
	end--]]
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	--local eeg=eg:Filter(cm.spfilter,nil)
	--if #eeg==0 then return end
	local eeg1=eg:Filter(cm.filter1,nil)
	local eeg2=Group.CreateGroup() --eg:Filter(Card.IsType,nil,TYPE_TRAP)
	local eeg3=eg-eeg1-eeg2
	if #eeg1>0 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
		g=g-g:Filter(cm.filter1,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
		end
	end
	if #eeg2>0 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
		g=g-g:Filter(Card.IsType,nil,TYPE_TRAP)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
		end
	end
	if #eeg3>0 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
		g=g:Filter(cm.filter1,nil) --+g:Filter(Card.IsType,nil,TYPE_TRAP)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
		end
	end
end
function cm.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9977)
end