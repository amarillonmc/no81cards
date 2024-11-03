--拉比林斯的聚会
local m=91060011
local cm=c91060011
function c91060011.initial_effect(c)
		local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33407125,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetCost(cm.cost)
	c:RegisterEffect(e3)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(91020022,2))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,m)
	e6:SetCost(aux.bfgcost)
	e6:SetCondition(cm.spcon)
	e6:SetTarget(cm.tgf)
	e6:SetOperation(cm.opf)
	c:RegisterEffect(e6)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(cm.acop)

end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	if re:GetHandler()~=e:GetHandler() and e:GetHandler():GetFlagEffect(FLAG_ID_CHAINING)>0 then
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	if eg==nil then
	local eg=Group.CreateGroup()
	eg:AddCard(re:GetHandler())
	elseif eg~=nil then
	eg:AddCard(re:GetHandler())
end
		Duel.RaiseEvent(eg,EVENT_CUSTOM+m,e,0,0,0,0)		
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return  Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.spfilter(c,e,tp)
	return (c:IsRace(RACE_FIEND) or c:IsType(TYPE_FUSION)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.fit1(c,tp,re)
	return (c:IsRace(RACE_FIEND)or c:IsType(TYPE_FUSION)) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.fit1,1,nil,tp,re) 
end
function cm.tgf(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tg=re:GetTarget() 
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) 
	Duel.RegisterFlagEffect(e:GetHandler(),m,RESET_PHASE+PHASE_END,0,1)   end
end
function cm.opf(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(c,m)>0  then
	 local fop=re:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
   end
end