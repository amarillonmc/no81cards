--[[
亡命骗徒 『第一幕』
==【Desperado Trickster - "1st Act"】==
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--When this card is activated: Take 2 "Desperado Trickster" monsters with different names from your Deck, and Special Summon 1 of them to your field and the other to your opponent's field.
	local e0=Effect.CreateEffect(c)
	e0:Desc(0)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_DECKDES)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetFunctions(nil,nil,s.target,s.activate)
	c:RegisterEffect(e0)
	--[[If a "Desperado Heart" monster(s) is destroyed: You can place 1 "Desperado Heart" card (with a different name from the cards that have already been returned
	to the Deck by this effect of "Desperado Trickster - "1st Act"") from your GY on the bottom of your Deck, and if you do, Set 1 "Desperado Heart" card from your Deck to your field.]]
	local FZChk=aux.AddThisCardInFZoneAlreadyCheck(c)
	local e1=Effect.CreateEffect(c)
	e1:Desc(2)
	e1:SetCategory(CATEGORY_TODECK|CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetLabelObject(FZChk)
	e1:SetCondition(s.ctcon)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	if not s.NameTable then
		s.NameTable={}
	end
end
--E1
function s.spfilter(c,e,tp)
	return c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp))
end
function s.spcheck(c,e,tp,sg)
	local tc=sg:GetFirst()
	if tc==c then
		tc=sg:GetNext()
	end
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function s.gcheck(g,e,tp)
	if #g<2 or g:GetClassCount(Card.GetCode)~=#g then return false end
	local a,b=g:GetFirst(),g:GetNext()
	for i=1,2 do
		if a:IsCanBeSpecialSummoned(e,0,tp,false,false) and b:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) then
			return true
		end
		if i==1 then
			a,b=b,a
		end
	end
	return false
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.Group(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and Duel.GetMZoneCount(tp,nil)>0 and Duel.GetMZoneCount(1-tp,nil,tp)>0 and aux.SelectUnselectGroup(g,e,tp,2,2,s.gcheck,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or Duel.GetMZoneCount(tp,nil)<=0 or Duel.GetMZoneCount(1-tp,nil,tp)<=0 then return end
	local g=Duel.Group(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local sg=aux.SelectUnselectGroup(g,e,tp,2,2,s.gcheck,1,tp,HINTMSG_SPSUMMON,false,false,false)
	if #sg==2 then
		Duel.HintMessage(tp,aux.Stringid(id,1))
		local tc=sg:FilterSelect(tp,s.spcheck,1,1,nil,e,tp,sg):GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			sg:RemoveCard(tc)
		end
		Duel.SpecialSummonStep(sg:GetFirst(),0,tp,1-tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end

--E2
function s.cfilter(c)
	if c:IsPreviousLocation(LOCATION_MZONE) then
		return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(ARCHE_DESPERADO_TRICKSTER)
	else
		return c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and not c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsMonster()
	end
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(aux.AlreadyInRangeFilter(e,s.cfilter),1,nil)
end
function s.tdfilter(c)
	local codes={c:GetCode()}
	for _,code in ipairs(codes) do
		if s.NameTable[code] then
			return false
		end
	end
	return c:IsSetCard(ARCHE_DESPERADO_HEART) and c:IsAbleToDeck()
end
function s.setfilter(c,e,tp,ft)
	if c:IsMonster() then
		return c:IsSetCard(ARCHE_DESPERADO_HEART) and ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	else
		return c:IsSetCard(ARCHE_DESPERADO_HEART) and c:IsSSetable()
	end
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExists(false,s.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExists(false,s.setfilter,tp,LOCATION_DECK,0,1,nil,e,tp,Duel.GetMZoneCount(tp)) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.Select(HINTMSG_TODECK,false,tp,aux.Necro(s.tdfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #tg>0 then
		Duel.HintSelection(tg)
		if Duel.ShuffleIntoDeck(tg,nil,nil,SEQ_DECKBOTTOM)>0 then
			local sc=tg:GetFirst()
			if aux.BecauseOfThisEffect(e)(sc) then
				local codes={sc:GetCode()}
				for _,code in ipairs(codes) do
					s.NameTable[code]=true
				end
			end
			local tc=Duel.Select(HINTMSG_SET,false,tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,Duel.GetMZoneCount(tp)):GetFirst()
			if not tc then return end
			if tc:IsMonster() then
				if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
					Duel.ConfirmCards(1-tp,Group.FromCards(tc))
				end
			else
				Duel.SSet(tp,tc)
			end
		end
	end
end