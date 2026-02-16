if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro Summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(0xff)
	e1:SetOperation(s.adjustop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	SNNM.ActivatedAsSpellorTrapCheck(c)
	--Effect 2: Shuffle and Draw
	--Ref: 神碑の泉 & 貪欲な壺 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1) -- "1回合1次"
	e3:SetCondition(s.drcon)
	e3:SetTarget(s.drtg)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)
end

function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		s.globle_check=true
		local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(Card.IsType,0,0xff,0xff,nil,TYPE_MONSTER)
		for tc in aux.Next(g) do
			local e1,e1_1,e2,e3=SNNM.ActivatedAsSpellorTrap(tc,0x10002,LOCATION_HAND)
			e1:SetDescription(aux.Stringid(id,0))
			e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_CHAIN)
			e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				return Duel.IsPlayerAffectedByEffect(tp,id)
			end)
			e1:SetCost(s.actcost)
			e1:SetTarget(s.acttg)
			e1:SetOperation(s.actop)
		end
	end
	e:Reset()
end

function s.granttg(e,c)
	return c:IsType(TYPE_MONSTER)
end

function s.cfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToGraveAsCost()
end

function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) and (Duel.GetTurnPlayer()==tp or c:IsHasEffect(EFFECT_QP_ACT_IN_NTPHAND)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	--Ref: 神碑の泉 
	return re:IsActiveType(TYPE_SPELL) and re:IsActiveType(TYPE_QUICKPLAY) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

function s.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	--Ref: 貪欲な壺 
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	--Ref: 貪欲な壺 
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end