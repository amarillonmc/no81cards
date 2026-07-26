--万土归尘
local s,id,o=GetID()
local CodeList=1202000	--引力术卡号
function s.initial_effect(c)
	aux.AddCodeList(c,CodeList)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.rsdtg)
	e2:SetOperation(s.rsdop)
	c:RegisterEffect(e2)
	
end
function s.rmfilter(c,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsType(TYPE_RITUAL) and (c:IsControler(tp) or c:IsFaceup())
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.rmfilter,1,nil,tp) end
	local rg=Duel.SelectReleaseGroup(tp,s.rmfilter,1,1,nil,tp)
	Duel.Release(rg,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) and
	 Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	local g2=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if not g1 or g1:GetCount()==0 or not g2 or g2:GetCount()==0 then return end
	local nums=math.min(g1:GetCount(),g2:GetCount(),5)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg1=g1:Select(tp,1,nums,nil)
	if tg1 and tg1:GetCount()>0 then
		Duel.SendtoDeck(tg1,nil,2,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local tg2=g2:Select(tp,tg1:GetCount(),tg1:GetCount(),nil)
		Duel.Release(tg2,REASON_EFFECT)
	end
end


function s.refilter(c)
	return (c:IsSetCard(0x9240) or c:IsCode(CodeList) or aux.IsCodeListed(c,CodeList))
		and c:IsAbleToHand()
end
function s.rsdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.refilter),tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
end
function s.rsdop(e,tp)
	if not Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.refilter),tp,LOCATION_ONFIELD,0,1,e:GetHandler()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.refilter),tp,LOCATION_ONFIELD,0,1,5,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(id,3))
	local sg=g:Select(1-tp,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	g:Sub(sg)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end