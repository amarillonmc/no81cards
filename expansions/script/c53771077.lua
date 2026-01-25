--反击
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function c53771077.initial_effect(c)
	SNNM.Sarcoveil_Sort(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,53771077+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c53771077.condition)
	e1:SetTarget(c53771077.target)
	e1:SetOperation(c53771077.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c53771077.tdtg)
	e2:SetOperation(c53771077.tdop)
	c:RegisterEffect(e2)
end
function c53771077.chkfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c53771077.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return (not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or g==nil or not g:IsExists(c53771077.chkfilter,1,nil,tp)) and rp~=tp
end
function c53771077.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c53771077.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	local sg=Group.CreateGroup()
	sg:KeepAlive()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,0)
		e1:SetLabelObject(sg)
		e1:SetTarget(function(e,c)
			return c==tc
		end)
		e1:SetValue(c53771077.efilter1(tc,re))
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetLabelObject(sg)
	e2:SetValue(c53771077.efilter2(re))
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function c53771077.efilter1(tc,re)
	return function(e,te)
		if te~=re then return false end
		e:GetLabelObject():AddCard(tc)
		return false
	end
end
function c53771077.efilter2(re)
	return function(e,te)
		if te~=re then return false end
		local g=e:GetLabelObject()
		if #g>0 then
			local le={Duel.IsPlayerAffectedByEffect(tp,53771077)}
			for _,v in pairs(le) do
				v:GetLabelObject():Reset()
				v:Reset()
			end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_ADJUST)
			e1:SetLabelObject(g)
			e1:SetOperation(c53771077.imcop)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(53771077)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTargetRange(1,0)
			e2:SetLabelObject(e1)
			Duel.RegisterEffect(e2,tp)
		end
		return true
	end
end
function c53771077.imcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,53771077)
	local g=e:GetLabelObject()
	Duel.ConfirmCards(1-tp,g)
	local p=g:IsExists(Card.IsSetCard,1,nil,0xa53b) and tp or 1-tp
	local e1=Effect.CreateEffect(e:GetOwner())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetOperation(c53771077.disop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,p)
	e:Reset()
end
function c53771077.disop(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp and Duel.SelectYesNo(tp,aux.Stringid(53771077,2)) then
		Duel.Hint(HINT_CARD,0,53771077)
		Duel.NegateEffect(ev)
		e:Reset()
	end
end
function c53771077.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c53771077.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
