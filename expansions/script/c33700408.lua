--Sweety Dreamy Fluffy Fairy
--AlphaKretin
--For Nemoma
local card = c33700408
local code = 33700408
function card.initial_effect(c)
	--unaffected
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD, 0)
	e1:SetTarget(card.imtg)
	e1:SetValue(card.imval)
	c:RegisterEffect(e1)
	--effect gain
	local e2 = Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(card.effcon)
	e2:SetOperation(card.effop)
	c:RegisterEffect(e2)
end

function card.imtg(e, tc)
	local c = e:GetHandler()
	return c:GetColumnGroup(1, 1):IsContains(tc) or c == tc
end

function card.imval(e, te)
	return te:GetOwnerPlayer() ~= e:GetHandlerPlayer()
end

function card.effcon(e, tp, eg, ep, ev, re, r, rp)
	local rc = e:GetHandler():GetReasonCard()
	return rc and rc:GetSummonLocation()==LOCATION_EXTRA
end

function card.effop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local rc = c:GetReasonCard()
	--take out some resets to allow recursion
	rc:ReplaceEffect(code, RESET_EVENT + RESETS_STANDARD - RESET_LEAVE - RESET_TOGRAVE)
	--magic hack so it does reset in grave after recu
	local a, b = e:GetReset()
	if a~=0 or b~=0 then e:Reset() end
end
