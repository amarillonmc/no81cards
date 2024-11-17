--[[幻之潮流↗绝体绝命810！
BranD-810!'s Fantasy Tide
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()

local FLAG_DELAYED_EVENT = id
local FLAG_SIMULT_CHECK = id+100
local FLAG_SIMULT_EXCLUDE = id+200
local FLAG_REDIRECTED = id+300

function s.initial_effect(c)
	if not s.progressive_id then
		s.progressive_id=id
	else
		s.progressive_id=s.progressive_id+1
	end
	c:EnableReviveLimit()
	--You can only control 1 face-up "BranD-810!'s Fantasy Tide".
	c:SetUniqueOnField(1,0,id)
	--[[If a "BranD-810!" monster(s) is sent from your hand or Deck to the GY (except during the Damage Step): You can Special Summon this card
	from your Extra Deck, and if you do, this card's ATK becomes equal to the total ATK of that sent monster(s).]]
	aux.RegisterMergedDelayedEventGlitchy(c,s.progressive_id,EVENT_TO_GRAVE,s.cfilter,FLAG_DELAYED_EVENT,LOCATION_EXTRA,nil,nil,s.RegisterTableAddress,FLAG_SIMULT_CHECK,nil,s.RegisterATKInTable)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CUSTOM+s.progressive_id)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetFunctions(
		nil,
		nil,
		s.sptg,
		s.spop
	)
	c:RegisterEffect(e1)
	--[[If a "BranD-810!" monster(s) would be sent to the GY, you can place it on the bottom of your Deck instead, and if you do, draw 1 card.]]
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
	if not s.MergedDelayedEventInfotable then
		s.MergedDelayedEventInfotable={}
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TURN_END)
		ge1:OPT()
		ge1:SetOperation(s.resetop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.resetop()
	aux.ClearTableRecursive(s.MergedDelayedEventInfotable)
end

--E1
function s.RegisterATKInTable(c)
	if not s.MergedDelayedEventInfotable[MERGED_ID] then
		s.MergedDelayedEventInfotable[MERGED_ID] = {}
	end
	s.MergedDelayedEventInfotable[MERGED_ID][c]=c:GetAttack()
end
function s.RegisterTableAddress()
	return MERGED_ID
end
function s.cfilter(c,_,tp)
	return c:IsMonster() and c:IsSetCard(ARCHE_BRAND_810) and c:IsPreviousLocation(LOCATION_HAND|LOCATION_DECK) and c:IsPreviousControler(tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	end
	Duel.SetCardOperationInfo(c,CATEGORY_SPECIAL_SUMMON)
	local sg=aux.SelectSimultaneousEventGroup(eg,tp,FLAG_SIMULT_CHECK,1,e,FLAG_SIMULT_EXCLUDE)
	local val=0
	for tc in aux.Next(sg) do
		if type(s.MergedDelayedEventInfotable[ev][tc])=="number" then
			val=val+s.MergedDelayedEventInfotable[ev][tc]
		end
	end
	Duel.SetTargetParam(val)
	Duel.SetCustomOperationInfo(0,CATEGORY_ATKCHANGE,c,1,tp,LOCATION_MZONE,{val})
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		local val=Duel.GetTargetParam()
		Duel.SpecialSummonATKDEF(e,c,0,tp,tp,false,false,POS_FACEUP,nil,val)
	end
end

--E2
function s.repfilter(c)
	return not c:IsLocation(LOCATION_SZONE|LOCATION_DECK) and c:GetDestination()==LOCATION_GRAVE and (c:IsMonster() or c:IsLocation(LOCATION_MZONE))
		and c:IsSetCard(ARCHE_BRAND_810) and c:IsAbleToDeck()
		and (not c:IsOnField() or c:IsFaceup())
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return r&(REASON_BATTLE|REASON_EFFECT)>0 and eg:IsExists(s.repfilter,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		local c=e:GetHandler()
		local g=eg:Filter(s.repfilter,nil)
		local ct=#g
		local fid=e:GetFieldID()
		e:SetLabel(fid)
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			g=g:Select(tp,1,ct,nil)
		end
		for tc in aux.Next(g) do
			tc:RegisterFlagEffect(FLAG_REDIRECTED,0,0,1,fid)
		end
		local seq=#g==1 and SEQ_DECKBOTTOM or SEQ_DECKTOP
		if Duel.SendtoDeck(g,nil,seq,REASON_EFFECT)>0 then
			local rg=Duel.GetGroupOperatedByThisEffect(e):Filter(Card.IsLocation,nil,LOCATION_DECK)
			if #rg>1 then
				local og=rg:Filter(Card.IsLocation,nil,LOCATION_DECK)
				local ct1=og:FilterCount(Card.IsControler,nil,tp)
				local ct2=og:FilterCount(Card.IsControler,nil,1-tp)
				if ct1>0 then
					if ct1>1 then
						Duel.SortDecktop(tp,tp,ct1)
					end
					for i=1,ct1 do
						local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
						Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
					end
				end
				if ct2>0 then
					if ct2>1 then
						Duel.SortDecktop(tp,1-tp,ct2)
					end
					for i=1,ct2 do
						local tc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
						Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
					end
				end
			end
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		return true
	else return false end
end
function s.repval(e,c)
	return c:HasFlagEffectLabel(FLAG_REDIRECTED,e:GetLabel())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		tc:ResetFlagEffect(FLAG_REDIRECTED)
	end
end