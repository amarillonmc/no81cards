--[[
脆弱的坚强
Resilient Fragility
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	c:Activation()
	--[[If this card is sent from the field to the GY: Send all monsters you control to the GY.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetFunctions(s.tgcon,nil,s.tgtg,s.tgop)
	c:RegisterEffect(e1)
	--[[During your opponent's turn, if a monster(s) you control would be destroyed, you can apply 1 of the following effects for each, instead.
	● Take damage equal to its ATK.
	● Shuffle it into your Deck.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.destg)
	e2:SetValue(s.repval)
	c:RegisterEffect(e2)
	--During your Standby Phase, if a monster(s) was shuffled into your Deck by this card's effect during the previous turn: You can gain LP equal to the total DEF those shuffled monsters had on field, and if you do, Special Summon those monsters (or monsters with the same name) from your Deck, then it becomes the End Phase of this turn.
	local e3=Effect.CreateEffect(c)
	e3:Desc(3,id)
	e3:SetCategory(CATEGORY_RECOVER|CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:OPT()
	e3:SetFunctions(
		aux.TurnPlayerCond(0),
		nil,
		s.sptg,
		s.spop
	)
	c:RegisterEffect(e3)
end

local FLAG_STILL_IN_DECK 	= id
local FLAG_WAS_SHUFFLED		= id+100

--E1
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.Group(Card.IsAbleToGrave,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,tp,LOCATION_MZONE)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(Card.IsAbleToGrave,tp,LOCATION_MZONE,0,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--E2
function s.desfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and not c:IsReason(REASON_REPLACE)
end
function s.repfilter(c,nodam)
	return (nodam or not c:IsAttackAbove(1)) and not c:IsAbleToDeck()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsTurnPlayer(1-tp) and eg:IsExists(s.desfilter,1,nil,tp) and not eg:IsExists(s.repfilter,1,nil,Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE)) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_CARD,tp,id)
		local ct=0
		local damchk=true
		local tg=Group.CreateGroup()
		local g=eg:Filter(s.desfilter,nil,tp)
		local ctmax=#g
		while ct<ctmax do
			ct=ct+1
			Duel.HintMessage(tp,HINTMSG_OPERATECARD)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			local b1=tc:IsAttackAbove(1)
			local b2=tc:IsAbleToDeck()
			local opt=aux.Option(tp,id,1,b1,b2)
			if opt==0 then
				if not damchk then damchk=true end
				Duel.Damage(tp,tc:GetAttack(),REASON_EFFECT,true)
			elseif opt==1 then
				tg:AddCard(tc)
			end
			g:RemoveCard(tc)
		end
		if damchk then Duel.RDComplete() end
		if #tg>0 then
			if Duel.SendtoDeck(tg,tp,SEQ_DECKSHUFFLE,REASON_EFFECT|REASON_REPLACE)>0 then
				local og=Duel.GetGroupOperatedByThisEffect(e):Filter(aux.PLChk,nil,tp,LOCATION_DECK)
				if #og>0 then
					local fid=e:GetHandler():GetFieldID()
					for oc in aux.Next(og) do
						oc:RegisterFlagEffect(FLAG_STILL_IN_DECK,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,2,fid)
						oc:RegisterFlagEffect(FLAG_WAS_SHUFFLED,RESET_PHASE|PHASE_END,0,2,fid)
					end
				end
			end
		end
		return true
	else return false end
end
function s.repval(e,c)
	return s.desfilter(c,e:GetHandlerPlayer())
end

--E3
function s.spfilter(c,e,tp,og)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and og:IsExists(Card.IsOriginalCode,1,nil,c:GetOriginalCode())
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local fid=e:GetHandler():GetFieldID()
	local og=Duel.Group(Card.HasFlagEffectLabel,tp,LOCATION_DECK,0,nil,FLAG_WAS_SHUFFLED,fid)
	local val=og:GetSum(Card.GetPreviousDefenseOnField)
	local codes={}
	for oc in aux.Next(og) do
		table.insert(codes,oc:GetOriginalCode())
	end
	local check=aux.CreateChecks(Card.IsOriginalCode,codes)
	local sg=Duel.Group(Card.HasFlagEffectLabel,tp,LOCATION_DECK,0,nil,FLAG_STILL_IN_DECK,fid)
	local g=Duel.Group(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp,sg)
	if chk==0 then
		return val>0 and Duel.GetMZoneCount(tp)>=#og and (#og<2 or not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT))
			and g:CheckSubGroupEach(check)
	end
	e:SetLabel(fid)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,#og,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local val=Duel.GetTargetParam()
	if val>0 and Duel.Recover(tp,val,REASON_EFFECT)>0 then
		local fid=e:GetLabel()
		local og=Duel.Group(Card.HasFlagEffectLabel,tp,LOCATION_DECK,0,nil,FLAG_WAS_SHUFFLED,fid)
		if Duel.GetMZoneCount(tp)>=#og and (#og<2 or not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)) then
			local codes={}
			for oc in aux.Next(og) do
				table.insert(codes,oc:GetOriginalCode())
			end
			local check=aux.CreateChecks(Card.IsOriginalCode,codes)
			local sg=Duel.Group(Card.HasFlagEffectLabel,tp,LOCATION_DECK,0,nil,FLAG_STILL_IN_DECK,fid)
			local g=Duel.Group(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp,sg)
			if g:CheckSubGroupEach(check) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local spg=g:SelectSubGroupEach(tp,check)
				if Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)>0 then
					Duel.BreakEffect()
					local p=Duel.GetTurnPlayer()
					Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE|PHASE_END,1)
					Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE|PHASE_END,1)
					Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE|PHASE_END,1)
					Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE|PHASE_END,1,1)
					Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE|PHASE_END,1)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_CANNOT_BP)
					e1:SetTargetRange(1,0)
					e1:SetReset(RESET_PHASE|PHASE_END)
					Duel.RegisterEffect(e1,p)
				end
			end
		end
	end
end