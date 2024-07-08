--火取剑豪
local s,id,o=GetID()
local o=o*10000
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),4,2,s.ovfilter,aux.Stringid(id,0),3,s.xyzop)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(s.mttg)
	e1:SetOperation(s.mtop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.tgcost)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsDiscardable()
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x37c0)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,s.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function s.mtfilter(c,e)
	return c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(s.mtfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,c) end
end
function s.gcheck(g,tp)
	return g:FilterCount(Card.IsControler,nil,tp)<=1
		and g:FilterCount(Card.IsControler,nil,1-tp)<=1
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(s.mtfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=g:SelectSubGroup(tp,s.gcheck,false,1,2,tp)
	if sg:GetCount()>0 then
		Duel.Overlay(c,sg)
	end
end
function s.tgfilter(c,lv)
	return c:IsLevelBelow(lv) and c:IsRace(RACE_ZOMBIE) and c:IsAbleToGrave()
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	e:SetLabel(100)
	if chk==0 then return ct>0 and c:CheckRemoveOverlayCard(tp,ct,REASON_COST) and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil,ct) end
	c:RemoveOverlayCard(tp,ct,ct,REASON_COST)
	e:SetLabel(100,ct)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local el,lv=e:GetLabel()
	if chk==0 then return el==100 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local el,lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end