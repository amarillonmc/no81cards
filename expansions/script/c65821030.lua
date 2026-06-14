--越限疾驰 怠速
local s,id,o=GetID()
function s.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	--e1:SetCountLimit(1,id)
	e1:SetCondition(s.rmcon)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	--e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.rmcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.target1)
	e2:SetOperation(s.operation1)
	c:RegisterEffect(e2)
end

function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x5a32) and c:IsAbleToGrave() and not c:IsCode(id)
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode()) and c:IsFaceupEx()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsLocation(LOCATION_DECK) then
 			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
		end
	end
end

function s.scfilter(c)
	for _,sumtype in pairs({0,SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK,SUMMON_TYPE_SPECIAL,SUMMON_VALUE_SELF}) do
		if c:IsSpecialSummonable(sumtype) then return true end
	end
	return false
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.scfilter),tp,0xff,0,nil,e,tp)
	if chk==0 then return #sg>0 end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(s.scfilter,tp,0xff,0,nil)
    if #sg>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tc=sg:Select(tp,1,1,nil):GetFirst()
        if tc then
            for _,sumtype in pairs({0,SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK,SUMMON_TYPE_SPECIAL,SUMMON_VALUE_SELF}) do
                if tc:IsSpecialSummonable(sumtype) then
                    Duel.SpecialSummonRule(tp,tc,sumtype)
                    break
                end
            end
        end
    end
end