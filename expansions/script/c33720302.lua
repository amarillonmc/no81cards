--[[埼玉清道夫→绝体绝命810！
Saitama, Specialist of BranD-810!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--(Quick Effect): You can discard this card; each player randomly chooses a card from their GY and shuffles it into the Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:HOPT()
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(aux.DiscardSelfCost)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
	--[[If this card is sent to the GY: Activate this effect; during the next End Phase, you can take a number of "BranD-810!" cards in your GY,
	up to the number of "BranD-810!" cards that were destroyed by your opponent this turn up until the point this effect resolves,
	and either add them to your hand or shuffle them into your Deck, and if you do, if cards were shuffled into your Deck by this effect,
	draw cards equal to half that amount (rounded up).]]
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND|CATEGORY_TODECK|CATEGORY_DRAW|CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:HOPT()
	e2:SetTarget(s.applytg)
	e2:SetOperation(s.applyop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end

local PFLAG_COUNT_DESTROYED_CARDS = id

function s.regcfilter(c,p)
	return c:IsSetCard(ARCHE_BRAND_810) and c:IsReasonPlayer(p)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local ct=eg:FilterCount(s.regcfilter,nil,p)
		if ct>0 then
			if not Duel.PlayerHasFlagEffect(p,PFLAG_COUNT_DESTROYED_CARDS) then
				Duel.RegisterFlagEffect(p,PFLAG_COUNT_DESTROYED_CARDS,RESET_PHASE|PHASE_END,0,1,0)
			end
			Duel.UpdateFlagEffectLabel(p,PFLAG_COUNT_DESTROYED_CARDS,ct)
		end
	end
end

--E1
function s.tdofilter(c,p)
	return not c:IsHasEffect(EFFECT_CANNOT_TO_DECK) and Duel.IsPlayerCanSendtoDeck(p,c)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExists(false,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExists(false,s.tdofilter,tp,0,LOCATION_GRAVE,1,nil,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,PLAYER_ALL,LOCATION_GRAVE)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.Group(aux.Necro(Card.IsAbleToDeck),tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.Group(aux.Necro(s.tdofilter),tp,0,LOCATION_GRAVE,nil,1-tp)
	if #g1*#g2==0 then return end
	for p in aux.TurnPlayers() do
		local g=p==tp and g1 or g2
		local tg=g:RandomSelect(p,1)
		Duel.HintSelection(tg)
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT,p)
	end
end

--E2
function s.applytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.applyop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.PlayerHasFlagEffect(1-tp,PFLAG_COUNT_DESTROYED_CARDS) and Duel.GetFlagEffectLabel(1-tp,PFLAG_COUNT_DESTROYED_CARDS) or 0
	if ct<=0 then return end
	local c=e:GetHandler()
	local rct=Duel.GetNextPhaseCount(PHASE_END)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE|PHASE_END)
	e1:OPT()
	e1:SetLabel(ct,rct,Duel.GetTurnCount())
	e1:SetCondition(s.endcon)
	e1:SetOperation(s.endop)
	e1:SetReset(RESET_PHASE|PHASE_END,rct)
	Duel.RegisterEffect(e1,tp)
end
function s.endcon(e,tp,eg,ep,ev,re,r,rp)
	local _,rct,tct=e:GetLabel()
	return rct==1 or Duel.GetTurnCount()>tct
end
function s.endop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(aux.Necro(Card.IsSetCard),tp,LOCATION_GRAVE,0,nil,ARCHE_BRAND_810)
	if #g==0 then return end
	local ct=e:GetLabel()
	local thg,tdg=g:Filter(Card.IsAbleToHand,nil),g:Filter(Card.IsAbleToDeck,nil)
	local b1=#thg>0
	local b2=#tdg>0 and Duel.IsPlayerCanDraw(tp,1)
	if not b1 and not b2 then return end
	Duel.Hint(HINT_CARD,tp,id)
	local opt=aux.Option(tp,nil,nil,{b1,STRING_ADD_TO_HAND},{b2,STRING_SEND_TO_DECK})
	if opt==0 then
		Duel.HintMessage(tp,HINTMSG_ATOHAND)
		local tg=thg:Select(tp,1,ct,nil)
		Duel.Search(tg)
	elseif opt==1 then
		local maxc=math.min(ct,Duel.GetDeckCount(tp))
		Duel.HintMessage(tp,HINTMSG_TODECK)
		local tg=tdg:Select(tp,1,maxc,nil)
		Duel.HintSelection(tg)
		local tdct=math.ceil(Duel.ShuffleIntoDeck(tg)/2)
		if tdct>0 then
			Duel.Draw(tp,tdct,REASON_EFFECT)
		end
	end
end