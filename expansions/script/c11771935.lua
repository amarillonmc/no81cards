--正常的侵蚀
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,11771900,11771925)
	--手卡发动    
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,1))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)
	--改变效果    
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.chcon)
    e1:SetCost(s.chcost)
	e1:SetTarget(s.chtg)
	e1:SetOperation(s.chop)
	c:RegisterEffect(e1)    
end
function s.hcfilter(c)
	return c:IsFaceup() and c:IsCode(11771925)
end
function s.handcon(e)
	return Duel.IsExistingMatchingCard(s.hcfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function s.costfilter(c) 
	return c:IsCode(11771900) and (c:IsFaceup() or c:IsControler(tp))
end
function s.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.costfilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,s.costfilter,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsCode(11771900) and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,rp,0,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_DECK,1,nil,e,1-rp) 
    	and Duel.GetLocationCount(1-rp,LOCATION_MZONE)>0 end
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(1-tp,aux.NecroValleyFilter(s.spfilter),tp,0,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_DECK,1,1,nil,e,1-tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,1-tp,1-tp,false,false,POS_FACEUP)
	end
end