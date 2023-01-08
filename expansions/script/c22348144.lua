--恶 魔 之 链
local m=22348144
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22348144+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22348144.cost)
	e1:SetTarget(c22348144.target)
	e1:SetOperation(c22348144.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c22348144.desop)
	c:RegisterEffect(e2)
	--apply effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348142,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,22349144)
	e3:SetTarget(c22348144.efftg)
	e3:SetOperation(c22348144.effop)
	c:RegisterEffect(e3)
	
end
function c22348144.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))  
end  
function c22348144.filter1(c,e,tp)
	local lv=2*c:GetLevel()
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_FIEND)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22348144.filter2,tp,LOCATION_GRAVE,0,1,nil,tp,lv)
end
function c22348144.filter2(c,tp,lv)
	local rg=Duel.GetMatchingGroup(c22348144.filter3,tp,LOCATION_GRAVE,0,nil)
	return lv>0 and rg:CheckWithSumEqual(Card.GetLevel,lv,1,99)
end
function c22348144.filter3(c)
	return c:GetLevel()>0 and c:IsAbleToRemove() and c:IsSetCard(0x705)
end
function c22348144.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348144.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
function c22348144.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c22348144.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c22348144.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local lv=2*g1:GetFirst():GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.GetMatchingGroup(c22348144.filter3,tp,LOCATION_GRAVE,0,nil,tp,lv)
		local g2=rg:SelectWithSumEqual(tp,Card.GetLevel,lv,1,99)
		if Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)~=0 then
		local tc=g1:GetFirst()
		if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		e:GetHandler():SetCardTarget(tc)
		end
		end
	end
end
function c22348144.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c22348144.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x705) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove())
	then return false end
	local te=c.onfield_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c22348144.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348144.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_MZONE)
end
function c22348144.effop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c22348144.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local te=tc.onfield_effect
	local op=te:GetOperation()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and op then op(e,tp,eg,ep,ev,re,r,rp) end
end













