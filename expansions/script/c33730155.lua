--[[
键★高潮 Little Busters!
K.E.Y Climax - Little Busters!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_KEYFRAGMENT_LOADED then
	GLITCHYLIB_KEYFRAGMENT_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
Duel.LoadScript("glitchylib_helper.lua")
function s.initial_effect(c)
	if not s.progressive_id then
		s.progressive_id=id
	else
		s.progressive_id=s.progressive_id+1
	end
	c:Activation()
	--[[Each time a FIRE "K.E.Y" monster(s) is Summoned (except during the Damage Step): You can pay LP equal to half the ATK of 1 of those monsters;
	add 1 FIRE "K.E.Y Fragments" monster with a lower ATK than the amount you paid from your Deck to your hand.]]
	aux.RegisterMergedDelayedEventGlitchy(c,s.progressive_id,{EVENT_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS,EVENT_FLIP_SUMMON_SUCCESS},s.cfilter,id,LOCATION_SZONE,nil,LOCATION_SZONE,nil,id+100,true)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0)
	e1:SetCategory(CATEGORIES_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CUSTOM+s.progressive_id)
	e1:SetRange(LOCATION_SZONE)
	e1:SetFunctions(s.thcon,aux.DummyCost,s.thtg,s.thop)
	c:RegisterEffect(e1)
	--[[If you would place a Sticker(s) on a card your opponent controls, while you control 3+ FIRE "K.E.Y" monsters, you can place that Sticker(s) on your opponent instead. (Your opponent gains the effects of the Stickers placed on them).]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_PLACE_STICKER_REPLACE)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetCondition(s.repcon)
	e2:SetOperation(s.replace)
	c:RegisterEffect(e2)
end

--E1
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(ARCHE_KEY) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return #eg>0
end
function s.egfilter(c)
	if c:HasFlagEffect(id+200) or not c:HasAttack() then return false end
	local val=math.floor(c:GetAttack()/2)
	return s.cfilter(c) and Duel.IsExists(false,s.thfilter,tp,LOCATION_DECK,0,1,c,val-1) and Duel.CheckLPCost(tp,val)
end
function s.thfilter(c,val)
	return c:IsSetCard(ARCHE_KEY_FRAGMENTS) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAttackBelow(val) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.egfilter,nil,tp)
	if chk==0 then
		return #g>0
	end
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		local lockg=g:Filter(Card.HasFlagEffectLabel,nil,id+100,tc:GetFlagEffectLabel(id+100))
		for lc in aux.Next(lockg) do
			lc:RegisterFlagEffect(id+200,RESET_EVENT|RESETS_STANDARD|RESET_CHAIN,0,1)
		end
		g=sg
	end
	Duel.HintSelection(g)
	local val=math.floor(g:GetFirst():GetAttack()/2)
	Duel.PayLPCost(tp,val)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTargetParam()
	if ct then
		local g=Duel.Select(HINTMSG_ATOHAND,false,tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,ct-1)
		if #g>0 then
			Duel.Search(g,tp)
		end
	end
end

--E2
function s.repcon(e)
	return Duel.GetMatchingGroupCount(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,3,nil)>=3
end
function s.replace(e,tc,sticker,ct,re,rp,r,chk)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	if chk==0 then
		return rp==tp and Duel.IsCanAddStickerOnPlayer(1-tp,sticker,ct,re,rp,r|REASON_REPLACE)
	end
	Duel.Hint(HINT_CARD,0,id)
	Duel.AddStickerOnPlayer(1-tp,sticker,ct,re,rp,r|REASON_REPLACE)
end