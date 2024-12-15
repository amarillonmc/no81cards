--[[绝体绝命810！←帮帮帮帮我啊！
BranD-810! HELP MEEEEEEEEE!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id,o=GetID()

local FLAG_DELAYED_EVENT	= id
local FLAG_SIMULT_CHECK		= id+100
local FLAG_SIMULT_EXCLUDE	= id+200

Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	if not s.progressive_id then
		s.progressive_id=id
	else
		s.progressive_id=s.progressive_id+1
	end
	c:Activation()
	--[[If a card(s) you control is destroyed by your opponent: Activate this effect, until the end of your next turn, cards you control with the same type(s) as the destroyed card(s)
	(Monster, Spell, Trap) cannot be destroyed.]]
	aux.RegisterMergedDelayedEventGlitchy(c,s.progressive_id,EVENT_DESTROYED,s.cfilter,FLAG_DELAYED_EVENT,LOCATION_FZONE,nil,LOCATION_FZONE,nil,FLAG_SIMULT_CHECK,true)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CUSTOM+s.progressive_id)
	e1:SetRange(LOCATION_FZONE)
	e1:SetFunctions(
		nil,
		nil,
		s.target,
		s.operation
	)
	c:RegisterEffect(e1)
	--[[During the End Phase: You can add 1 "BranD-810" card that was destroyed this turn from your GY to your hand.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE|PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:OPT()
	e2:SetFunctions(
		nil,
		nil,
		s.thtg,
		s.thop
	)
	c:RegisterEffect(e2)
	--[[If this card is sent from the field to the GY: You can Set a "BranD-810!" Field Spell, except "BranD-810! HELP MEEEEEEEEE!", from your Deck in your Field Zone, but it cannot be activated this
	turn.]]
	local e3=Effect.CreateEffect(c)
	e3:Desc(2,id)
	e3:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetFunctions(s.setcon,nil,s.settg,s.setop)
	c:RegisterEffect(e3)
end
--E1
function s.cfilter(c,_,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:IsReasonPlayer(1-tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local sg=aux.SelectSimultaneousEventGroup(eg,tp,FLAG_SIMULT_CHECK,1,e,FLAG_SIMULT_EXCLUDE)
	local types=0
	for tc in aux.Next(sg) do
		types=types|(tc:GetType()&(TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP))
	end
	Duel.SetTargetParam(types)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local types=Duel.GetTargetParam()
	if types==0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE)
	e1:SetLabel(types)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(s.indtg)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,2)
	Duel.RegisterEffect(e1,tp)
	for _,typ in aux.BitSplit(types) do
		if not Duel.PlayerHasFlagEffectLabel(id,typ) then
			Duel.RegisterHint(tp,id,PHASE_END|RESET_SELF_TURN,2,id,4+(typ>>1))
		end
	end
end
function s.indtg(e,c)
	return c:IsType(e:GetLabel())
end

--E2
function s.thfilter(c,tid)
	return c:IsReason(REASON_DESTROY) and c:GetTurnID()==tid
		and c:IsAbleToHand() and c:IsSetCard(ARCHE_BRAND_810)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExists(false,s.thfilter,tp,LOCATION_GRAVE,0,1,nil,Duel.GetTurnCount()) end	
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Select(HINTMSG_ATOHAND,false,tp,aux.Necro(s.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,Duel.GetTurnCount())
	if #g>0 then
		Duel.Search(g)
	end
end

--E3
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.setfilter(c)
	return c:IsSpell(TYPE_FIELD) and c:IsSetCard(ARCHE_BRAND_810) and not c:IsCode(id) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if sc and Duel.SSet(tp,sc,tp,false)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
		sc:RegisterEffect(e1)
	end
end