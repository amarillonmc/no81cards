--[[
动物朋友饲育员 菜菜
Nana, Anifriends' Caretaker
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:EnableReviveLimit()
	--2 "Anifriends" Spells/Traps with different names
	aux.AddFusionProcFunRep(c,s.fusfilter,2,true)
	--Contact Fusion
	aux.AddContactFusionProcedureGlitchy(c,aux.Stringid(id,0),false,0,Card.IsAbleToRemoveAsCost,LOCATION_ONFIELD|LOCATION_GRAVE,0,{s.contactcon,Duel.Remove},POS_FACEUP,REASON_COST):HOPT()
	--[[(Quick Effect): You can target 1 "Anifriends" monster you control; add 1 "Anifriends" monster with an equal or lower ATK than that target from your Deck to your hand]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(1,id)
	e1:SetCategory(CATEGORIES_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:HOPT()
	e1:SetRelevantTimings()
	e1:SetFunctions(nil,nil,s.thtg,s.thop)
	c:RegisterEffect(e1)
end
function s.fusfilter(c,fc,sub,mg,sg)
	if not (c:IsFusionSetCard(ARCHE_ANIFRIENDS) and c:IsFusionType(TYPE_ST)) then return false end
	return not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())
end
function s.contactcon(e,fc,tp,mg)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or not Duel.IsExists(false,s.excfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.excfilter(c)
	return c:IsFacedown() or not c:IsSetCard(ARCHE_ANIFRIENDS)
end

--E1
function s.tgfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(ARCHE_ANIFRIENDS) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttack())
end
function s.thfilter(c,atk)
	return c:IsSetCard(ARCHE_ANIFRIENDS) and c:IsMonster() and c:IsAttackBelow(atk) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToChain() and tc:IsFaceup() and tc:IsSetCard(ARCHE_ANIFRIENDS) and tc:IsControler(tp)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetAttack())
	if #g>0 then
		Duel.Search(g)
	end
end