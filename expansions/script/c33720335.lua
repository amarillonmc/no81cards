--[[
待机
Standby
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--If you control no cards, you can activate this card from your hand.
	c:TrapCanBeActivatedFromHand(s.handactcon,aux.Stringid(id,0))
	--[[If your opponent adds exactly 1 card from their Deck to their hand (except by drawing it): Add 1 card with the same name from your Deck to your hand.]]
	aux.RegisterMergedDelayedEventGlitchy(c,id,EVENT_TO_HAND,s.cfilter,id)
	local e1=Effect.CreateEffect(c)
	e1:Desc(1,id)
	e1:SetCategory(CATEGORIES_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetFunctions(
		nil,
		nil,
		s.target,
		s.operation
	)
	c:RegisterEffect(e1)
	--[[During the End Phase of the turn this card is activated, if a card(s) with the same name as the card your opponent added to their hand (when this card was activated) was sent to their GY this
	turn: You can add this card from your GY to your hand.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(2,id)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE|PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:OPT()
	e2:SetFunctions(
		s.thcon,
		nil,
		s.thtg,
		s.thop
	)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local g=eg:Filter(Card.IsControler,nil,p)
		for tc in aux.Next(g) do
			local codes={tc:GetCode()}
			for _,code in ipairs(codes) do
				Duel.RegisterFlagEffect(p,id,RESET_PHASE|PHASE_END,0,1,code)
			end
		end
	end
end

function s.handactcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end

--E1
function s.cfilter(c,_,tp,eg)
	return #eg==1 and c:IsControler(1-tp) and c:IsPreviousControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function s.thfilter(c,g)
	return c:IsAbleToHand() and g:IsExists(Card.IsCode,1,c,c:GetCode())
end
function s.thfilter2(c,...)
	return c:IsAbleToHand() and c:IsCode(...)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return #eg>0 and Duel.IsExists(false,s.thfilter,tp,LOCATION_DECK,0,1,nil,eg)
	end
	e:SetLabel(0)
	for tc in aux.Next(eg) do
		local codes={tc:GetCode()}
		for _,code in ipairs(codes) do
			e:SetSpecificLabel(code,0)
			Duel.RegisterFlagEffect(1-tp,id+100,RESET_PHASE|PHASE_END,EFFECT_FLAG_OATH,1,code)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Select(HINTMSG_ATOHAND,false,tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if #g>0 then
		Duel.Search(g)
	end
end

--E2
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.PlayerHasFlagEffect(1-tp,id) or not Duel.PlayerHasFlagEffect(1-tp,id+100) then return false end
	for _,code in ipairs({Duel.GetFlagEffectLabel(1-tp,id)}) do
		local fe=Duel.GetFlagEffectWithSpecificLabel(1-tp,id+100,code)
		if fe then
			return true
		end
	end
	return false
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end