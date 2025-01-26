--海爬兽宝宝 小海龟

local s,id,o=GetID()
local zd=0x5224

function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--ToDeckAndDraw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	
	--RemoveOp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.e2con)
	e2:SetCost(s.e2cost)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)

end

--e1
--ToDeckAndDraw

function s.e1todfilter(c)
	return c:IsSetCard(zd) and c:IsAbleToDeck() and ( c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end

function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.e1todfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,5,nil) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,5,0,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_GRAVE)
end

function s.e1op(e,tp,eg,ep,ev,re,r,rp)  
	if not (Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.e1todfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,5,nil)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.e1todfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,5,5,nil)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--e2
--RemoveOp

function s.e2confilter(c)
	return c:IsSetCard(zd) and c:IsType(TYPE_FUSION) and c:IsFaceup()
end

function s.e2con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.e2confilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

function s.e2tudfilter(c,tp)
	return 
end

function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bl1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil)
	local bl2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil)
	if chk==0 then return bl1 or bl2 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_DECK+LOCATION_EXTRA)
end

function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	local bl1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil)
	local bl2=Duel.IsExistingMatchingCard(s.e2confilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil)
	if not (bl1 or bl2) then return end
	local op=0
	if (bl1 and bl2) then
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	elseif bl2 then
		op=1
	end
	
	if op==0 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil,tp)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	else
		local tg=Duel.GetMatchingGroup(s.e2confilter,tp,LOCATION_MZONE,0,nil)
		local g=Duel.GetDecktopGroup(1-tp,tg:GetCount())
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
