--涩域拼图 V 有点燥热的天火
function c79023005.initial_effect(c)
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c79023005.ttcon)
	e1:SetOperation(c79023005.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e2)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)   
	--t g 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(c79023005.tgtg)
	e4:SetOperation(c79023005.tgop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP)
	c:RegisterEffect(e5)  
end
function c79023005.ttcon(e,c,minc)
	if c==nil then return true end
	return Duel.GetMZoneCount(tp,nil,tp)>0
end
function c79023005.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(79023005,0))
	Duel.SelectOption(tp,aux.Stringid(79023005,1))
end
function c79023005.desfilter(c,g)
	return g:IsContains(c) and c:IsAbleToGrave()
end
function c79023005.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=e:GetHandler():GetColumnGroup()
	local g=Duel.GetMatchingGroup(c79023005.desfilter,tp,0,LOCATION_ONFIELD,nil,cg)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c79023005.thfil1(c)
	return c:IsAbleToHand() and c:IsSetCard(0xa9e1) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) 
end
function c79023005.thfil2(c)
	return c:IsAbleToHand() and c:IsSetCard(0xa9e1) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) 
end
function c79023005.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(c79023005.desfilter,tp,0,LOCATION_ONFIELD,nil,cg)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c79023005.thfil1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c79023005.thfil2,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79023005,2)) then 
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT,nil)
	local g1=Duel.SelectMatchingCard(tp,c79023005.thfil1,tp,LOCATION_DECK,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c79023005.thfil2,tp,LOCATION_DECK,0,1,1,nil)
	g1:Merge(g2)
	Duel.SendtoHand(g1,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
	end
	end
end









