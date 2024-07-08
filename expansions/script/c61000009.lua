--霞烈之魔妖 火取魔
local s,id,o=GetID()
local o=o*10000
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	aux.AddXyzProcedure(c,nil,6,2,s.ovfilter,aux.Stringid(id,0),3,s.xyzop)
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
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE+CATEGORY_HANDES+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.drcost)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsDiscardable()
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x37c0)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,s.cfilter,2,2,REASON_COST+REASON_DISCARD)
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
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	if chk==0 then return ct>0 and c:CheckRemoveOverlayCard(tp,ct,REASON_COST) end
	c:RemoveOverlayCard(tp,ct,ct,REASON_COST)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function s.tgfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToGrave()
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		local g=Duel.GetOperatedGroup()
		local tc=g:GetFirst()
		if tc:IsRace(RACE_ZOMBIE) and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			if tg:GetCount()>0 then
				Duel.SendtoGrave(tg,REASON_EFFECT)
			end
		end
	end
end