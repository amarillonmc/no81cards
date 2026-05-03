--风起 天衢引
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	aux.AddCodeList(c,65812000)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	if not PNFL_LOCATION_CHECK1 then
		PNFL_LOCATION_CHECK1=true
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge6:SetCode(EVENT_MOVE)
		ge6:SetOperation(s.checkop6)
		Duel.RegisterEffect(ge6,true)
	end
end

function s.lfilter(c)
	return aux.IsCodeListed(c,65812000)
end
function s.lcheck(g)
	return g:IsExists(s.lfilter,1,nil)
end


function s.checkop6(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local tc=eg:GetFirst()
		while tc do
			if s.locfilter(tc,p) then
				tc:RegisterFlagEffect(65812040,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65812040,1))
			end
			tc=eg:GetNext()
		end
	end
end
function s.locfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLocation(LOCATION_ONFIELD)
		and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=c:GetControler() or c:GetPreviousLocation()~=c:GetLocation()) 
		and c:GetFlagEffect(65812040)==0
end



function s.tffilter(c,tp)
	return c:IsCode(65812000) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and c:IsType(TYPE_FIELD) and c:IsFaceupEx()
end
function s.sendfilter(c)
	return (aux.IsCodeListed(c,65812000) or c:IsCode(65812000)) and c:IsAbleToGrave()
end
function s.settg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.tffilter), tp,
            LOCATION_HAND + LOCATION_DECK + LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, nil, tp)
    end
end
function s.movefilter(c)
	return c:GetFlagEffect(65812040)>0
end
function s.setop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
    local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.tffilter), tp,
        LOCATION_HAND + LOCATION_DECK + LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, 1, nil, tp)
    local tc = g:GetFirst()
    if not tc then return end
    local fc = Duel.GetFieldCard(tp, LOCATION_FZONE, 0)
    if fc then
        Duel.Destroy(fc, REASON_RULE)
    end
    Duel.MoveToField(tc, tp, tp, LOCATION_FZONE, POS_FACEUP, true)
    if not Duel.IsExistingMatchingCard(s.movefilter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil) then return end
    if not Duel.IsExistingMatchingCard(s.sendfilter, tp, LOCATION_HAND + LOCATION_DECK, 0, 1, nil) then return end
    if not Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local sg = Duel.SelectMatchingCard(tp, s.sendfilter, tp, LOCATION_HAND + LOCATION_DECK, 0, 1, 1, nil)
    if #sg > 0 then
        Duel.SendtoGrave(sg, REASON_EFFECT)
    end
end