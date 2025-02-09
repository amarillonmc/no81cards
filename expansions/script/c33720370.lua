--[[
永远的花丸
Always Hanamaru
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[Place 1 monster you control on the bottom of the Deck, and if you do, take a monster with a different name, but the same Attribute, Type, ATK and DEF from your Deck, and banish it. If an
	"Anifriends" monster was returned to the Deck by this card's effect, you can add that banished card to your hand during the End Phase of this turn. If the monster you take from your Deck is an
	"Anifriends" monster, you can Special Summon it instead, and if you do, it is unaffected by other card effects this turn.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_TODECK|CATEGORY_REMOVE|CATEGORY_TOHAND|CATEGORY_SPECIAL_SUMMON|CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRelevantTimings()
	e1:SetFunctions(nil,nil,s.target,s.activate)
	c:RegisterEffect(e1)
end
--E1
function s.filter(c,e,tp)
	return c:IsAbleToDeck() and c:HasDefense()
		and Duel.IsExists(false,s.rmfilter,tp,LOCATION_DECK,0,1,c,e,tp,c,c:GetAttribute(),c:GetRace(),c:GetAttack(),c:GetDefense(),c:GetCode())
end
function s.rmfilter(c,e,tp,c0,attr,race,atk,def,...)
	return c:IsMonster() and not c:IsCode(...) and c:IsAttributeRace(attr,race) and c:IsStats(atk,def)
		and (c:IsAbleToRemove() or (c:IsSetCard(ARCHE_ANIFRIENDS) and Duel.GetMZoneCount(tp,c0)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExists(false,s.filter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.Select(HINTMSG_TODECK,false,tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	if tc then
		if tc:IsFacedown() then
			Duel.ConfirmCards(1-tp,tc)
		end
		if Duel.ShuffleIntoDeck(tc,nil,nil,SEQ_DECKBOTTOM)>0 then
			local isAnifriends=tc:IsSetCard(ARCHE_ANIFRIENDS)
			local attr,race,atk,def,codes=tc:GetAttribute(),tc:GetRace(),tc:GetAttack(),tc:GetDefense(),{tc:GetCode()}
			local rc=Duel.Select(HINTMSG_REMOVE,false,tp,s.rmfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,nil,attr,race,atk,def,table.unpack(codes)):GetFirst()
			if rc then
				local c=e:GetHandler()
				local b1=rc:IsAbleToRemove()
				local b2=rc:IsSetCard(ARCHE_ANIFRIENDS) and Duel.GetMZoneCount(tp)>0 and rc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				local opt=aux.Option(tp,nil,nil,{b1,STRING_BANISH},{b2,STRING_SPECIAL_SUMMON})
				if opt==0 then
					if Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0 and rc:IsLocation(LOCATION_REMOVED) and isAnifriends then
						local eid=e:GetFieldID()
						rc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD_PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,eid)
						local e1=Effect.CreateEffect(c)
						e1:Desc(1,id)
						e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
						e1:SetCode(EVENT_PHASE|PHASE_END)
						e1:OPT()
						e1:SetLabel(eid)
						e1:SetLabelObject(rc)
						e1:SetCondition(s.thcon)
						e1:SetOperation(s.thop)
						e1:SetReset(RESET_PHASE|PHASE_END)
						Duel.RegisterEffect(e1,tp)
					end
				elseif opt==1 then
					if Duel.SpecialSummonStep(rc,0,tp,tp,false,false,POS_FACEUP) then
						local e1=Effect.CreateEffect(c)
						e1:SetDescription(STRING_UNAFFECTED_OTHER)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE|EFFECT_FLAG_CLIENT_HINT)
						e1:SetRange(LOCATION_MZONE)
						e1:SetCode(EFFECT_IMMUNE_EFFECT)
						e1:SetValue(s.efilter)
						e1:SetReset(RESET_EVENT|RESETS_STANDARD_PHASE_END)
						rc:RegisterEffect(e1,true)
					end
					Duel.SpecialSummonComplete()
				end
			end
		end
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local eid=e:GetLabel()
	local rc=e:GetLabelObject()
	if not (rc and rc:HasFlagEffectLabel(id,eid)) then
		e:Reset()
		return false
	end
	return rc:IsAbleToHand()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	Duel.Hint(HINT_CARD,tp,rc:GetOriginalCode())
	if Duel.SelectYesNo(tp,STRING_ASK_TO_HAND) then
		Duel.Search(rc)
	end
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetHandler()
end