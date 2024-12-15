--[[
秘密结社337：柔·情·似·水
MYTH-337, M.E.L.L.O.W.
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	if not s.progressive_id then
		s.progressive_id=id
	else
		s.progressive_id=s.progressive_id+1
	end
	c:EnableReviveLimit()
	--[[When this card is Ritual Summoned: You can add to your hand, from either GY, 1 card that was there this turn.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetFunctions(aux.RitualSummonedCond,nil,s.thtg,s.thop)
	c:RegisterEffect(e1)
	--[[Each time a card(s) you control is destroyed: Gain 1200 LP for each.]]
	aux.RegisterMergedDelayedEventGlitchy(c,s.progressive_id,EVENT_DESTROYED,s.evfilter,id,LOCATION_MZONE,nil,LOCATION_MZONE,nil,id+100,true)
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_CUSTOM+s.progressive_id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetFunctions(nil,nil,s.rectg,s.recop)
	c:RegisterEffect(e2)
	--[[If this card is destroyed by your opponent: You can Special Summon 1 "Phil, Brain of MYTH-337" from your GY, but banish it when it leaves the field.]]
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
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,Duel.GetTurnCount()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.Necro(s.filter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,Duel.GetTurnCount())
	if #g>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--E2
function s.evfilter(c,_,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=aux.SelectSimultaneousEventGroup(eg,tp,id+100,1,e,id+200)
	local val=#g*1200
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

--E3
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.spfilter(c,e,tp)
	return c:IsCode(id-1) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
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