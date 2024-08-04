--[[
【日】【背景音台】音阶圆舞曲
【Ｏ】 Doremifa Rondo
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
if not TYPE_DOUBLESIDED then
	Duel.LoadScript("glitchylib_doublesided.lua")
end
if not TYPE_SOUNDSTAGE then
	Duel.LoadScript("glitchylib_soundstage.lua")
end
function s.initial_effect(c)
	aux.AddDoubleSidedProc(c,SIDE_OBVERSE,id+1,id)
	--When this card is activated: You can shuffle 7 "Anifriends" cards with different names from your GY into the Deck, and if you do, Transform this card.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK|CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetFunctions(nil,nil,s.target,s.activate)
	c:RegisterEffect(e1)
	aux.AddSoundStageProc(c,e1,id,3,0)
	--[[During the End Phase, the turn player declares a series of card names (players cannot check cards in the GY when this effect applies), and if all of those card names match the names of all cards whose effects were activated this turn, that player can add up to 2 of them from their GY to their hand, otherwise their opponent adds 2 cards from their GY to their hand.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE|PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:OPT()
	e2:SetOperation(s.declare)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAIN_ACTIVATING)
		e3:SetCondition(s.regcon)
		e3:SetOperation(s.regop)
		Duel.RegisterEffect(e3,0)
	end
end

local FLAG_TRACK_ACTIVATED_CODES		= id

local STRING_ASK_ON_ACTIVATION			= aux.Stringid(id,1)
local STRING_ASK_ANOTHER_NAME			= aux.Stringid(id,2)
local STRING_ASK_SUCCESSFUL				= aux.Stringid(id,3)

--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,7,tp,LOCATION_GRAVE)
end
function s.gcheck(g,e,tp,mg,c)
	local res=g:GetClassCount(Card.GetCode)==#g
	return res, not res
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or not c:IsFaceup() then return end
	local g=Duel.Group(aux.Necro(s.tdfilter),tp,LOCATION_GRAVE,0,nil)
	if aux.SelectUnselectGroup(g,e,tp,7,7,s.gcheck,0) and c:IsCanTransform(SIDE_REVERSE,e,tp,REASON_EFFECT) and Duel.SelectYesNo(tp,STRING_ASK_ON_ACTIVATION) then
		local tg=aux.SelectUnselectGroup(g,e,tp,7,7,s.gcheck,1,tp,HINTMSG_TODECK)
		if #tg==7 and Duel.ShuffleIntoDeck(tg)>0 and c:IsRelateToChain() and c:IsFaceup() and c:IsCanTransform(SIDE_REVERSE,e,tp,REASON_EFFECT) then
			Duel.Transform(c,SIDE_REVERSE,e,tp,REASON_EFFECT)
		end
	end
end

--E2
function s.thfilter(c,codes)
	return c:IsCode(table.unpack(codes)) and c:IsAbleToHand()
end
function s.declare(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetTurnPlayer()
	local DeclaredNames={}
	local UpperLimit=60
	for i=1,UpperLimit do
		if i==1 then
			if s.announce_filter then
				aux.ClearTable(s.announce_filter)
			else
				s.announce_filter={}
			end
		end
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_CODE)
		local code=i==1 and Duel.AnnounceCard(p) or Duel.AnnounceCard(p,table.unpack(s.announce_filter))
		table.insert(DeclaredNames,code)
		table.insert(s.announce_filter,code)
		table.insert(s.announce_filter,OPCODE_ISCODE)
		table.insert(s.announce_filter,OPCODE_NOT)
		if i>1 then
			table.insert(s.announce_filter,OPCODE_AND)
		end
		if i<UpperLimit and not Duel.SelectYesNo(p,STRING_ASK_ANOTHER_NAME) then
			break
		end
	end
	
	local ct=-1
	local fe=Duel.IsPlayerAffectedByEffect(p,EFFECT_FLAG_EFFECT|FLAG_TRACK_ACTIVATED_CODES)
	if fe then
		local actcodes={fe:GetLabel()}
		ct=#actcodes
		for _,code in ipairs(DeclaredNames) do
			if aux.FindInTable(actcodes,code) then
				ct=ct-1
			else
				break
			end
		end
	end
	if ct==0 and Duel.IsExists(false,aux.Necro(s.thfilter),p,LOCATION_GRAVE,0,1,nil,DeclaredNames) and Duel.SelectYesNo(p,STRING_ASK_SUCCESSFUL) then
		local g=Duel.Select(HINTMSG_ATOHAND,false,p,aux.Necro(s.thfilter),p,LOCATION_GRAVE,0,1,2,nil,DeclaredNames)
		if #g>0 then
			Duel.Search(g)
		end
	elseif ct~=0 then
		local g=Duel.Select(HINTMSG_ATOHAND,false,1-p,aux.Necro(Card.IsAbleToHand),1-p,LOCATION_GRAVE,0,1,2,nil)
		if #g>0 then
			Duel.Search(g)
		end
	end
end

--E3
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==ep
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local actcode1,actcode2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
	if not Duel.PlayerHasFlagEffect(ep,FLAG_TRACK_ACTIVATED_CODES) then
		local fe=Effect.GlobalEffect()
		fe:SetType(EFFECT_TYPE_FIELD)
		fe:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		fe:SetCode(EFFECT_FLAG_EFFECT|FLAG_TRACK_ACTIVATED_CODES)
		fe:SetTargetRange(1,0)
		if actcode2~=0 then
			fe:SetLabel(actcode1,actcode2)
		else
			fe:SetLabel(actcode1)
		end
		fe:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(fe,ep)
	else
		local fe=Duel.IsPlayerAffectedByEffect(ep,EFFECT_FLAG_EFFECT|FLAG_TRACK_ACTIVATED_CODES)
		local labels={fe:GetLabel()}
		if not aux.FindInTable(labels,actcode1) then
			fe:SetSpecificLabel(actcode1,#labels+1)
		end
		if actcode2~=0 and not aux.FindInTable(labels,actcode2) then
			fe:SetSpecificLabel(actcode2,#labels+2)
		end
	end
end