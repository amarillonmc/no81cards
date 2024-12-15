--[[
秘密结社337：功·夫·似·水
Jonathan, Fist of MYTH-337
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	if not s.progressive_id then
		s.progressive_id=id+200
	else
		s.progressive_id=s.progressive_id+1
	end
	c:EnableReviveLimit()
	--[[When this card is Ritual Summoned: You can place 1 card from your hand on the top of your Deck, and if you do, add the bottom card of your Deck to your hand.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORIES_SEARCH|CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetFunctions(aux.RitualSummonedCond,nil,s.thtg,s.thop)
	c:RegisterEffect(e1)
	--[[Each time a card(s) you control is destroyed by your opponent: All monsters you currently control gains 1000 ATK/DEF for each.]]
	aux.RegisterMergedDelayedEventGlitchy(c,s.progressive_id,EVENT_DESTROYED,s.evfilter,id,LOCATION_MZONE,nil,LOCATION_MZONE,nil,id+100,true)
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORIES_ATKDEF)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+s.progressive_id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetFunctions(nil,nil,s.rectg,s.recop)
	c:RegisterEffect(e2)
	--[[If this card is destroyed by your opponent: You can Special Summon 1 "Jonathan, Fist of MYTH-337" from your GY, but banish it when it leaves the field.]]
	local e3=Effect.CreateEffect(c)
	e3:Desc(2,id)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetFunctions(s.spcon,nil,s.sptg,s.spop)
	c:RegisterEffect(e3)
end
--E1
function s.filter(c,fid)
	return c:IsAbleToHand() and c:GetTurnID()==fid
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetDeck(tp):Filter(Card.IsSequence,nil,0):GetFirst()
	if chk==0 then return tc and tc:IsAbleToHand() and Duel.IsExists(false,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 and Duel.ShuffleIntoDeck(g,nil,nil,SEQ_DECKTOP)>0 then
		local tc=Duel.GetDeck(tp):Filter(Card.IsSequence,nil,0):GetFirst()
		if tc and tc:IsAbleToHand() then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end

--E2
function s.evfilter(c,_,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:IsReasonPlayer(1-tp)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=aux.SelectSimultaneousEventGroup(eg,tp,id+100,1,e,id+200)
	local val=#g*1000
	Duel.SetTargetParam(val)
	local g=Duel.Group(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	Duel.SetCustomOperationInfo(0,CATEGORIES_ATKDEF,g,#g,0,0,val)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=Duel.GetTargetParam()
	local g=Duel.Group(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		tc:UpdateATKDEF(val,val,true,{c,true})
	end
end

--E3
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.spfilter(c,e,tp)
	return c:IsCode(112312313) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummonRedirect(e,tc,0,tp,tp,false,true,POS_FACEUP)
	end
end