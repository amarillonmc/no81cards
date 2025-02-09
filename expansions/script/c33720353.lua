--[[
光芒起源的动物女孩
Animal Girl's Beginnings
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--This card's name becomes "Anifriends Masked Booby" while on the field or in the GY.
	aux.EnableChangeCode(c,id+1,LOCATION_MZONE|LOCATION_GRAVE)
	--[[If you have no cards in your GY: You can discard this card; reveal your entire hand, and if you do, add, from your Deck to your hand, a number of "Anifriends" monsters with different names,
	equal to the number of "Anifriends" cards in your hand, then you can take 1000 damage for each card added to your hand this way. If you do not do that, these added card(s), and cards with the same
	name(s), cannot be used this turn.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORIES_SEARCH|CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetFunctions(s.condition,aux.DiscardSelfCost,s.target,s.operation)
	c:RegisterEffect(e1)
end
--E1
function s.condition(e,tp)
	return Duel.GetGYCount(tp)==0
end
function s.thfilter(c)
	return c:IsMonster() and c:IsSetCard(ARCHE_ANIFRIENDS) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local exc=e:IsCostChecked() and e:GetHandler() or nil
		if not Duel.IsExists(false,aux.NOT(Card.IsPublic),tp,LOCATION_HAND,0,1,exc) then return false end
		local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_HAND,0,exc,ARCHE_ANIFRIENDS)
		if ct==0 then return false end
		local g=Duel.Group(s.thfilter,tp,LOCATION_DECK,0,nil)
		return (ct==1 and #g>0) or xgl.SelectUnselectGroup(GLITCHY_LARGE_GROUP_THRESHOLD_STRICT,g,e,tp,ct,ct,xgl.dncheck,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local hand=Duel.GetHand(tp)
	if not hand:IsExists(aux.NOT(Card.IsPublic),1,nil) then return end
	Duel.ConfirmCards(1-tp,hand)
	local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_HAND,0,exc,ARCHE_ANIFRIENDS)
	if ct==0 then return end
	local g=Duel.Group(s.thfilter,tp,LOCATION_DECK,0,nil)
	Duel.HintMessage(tp,HINTMSG_ATOHAND)
	local tg=(ct==1 and g:Select(tp,1,1,nil)) or xgl.SelectUnselectGroup(GLITCHY_LARGE_GROUP_THRESHOLD_STRICT,g,e,tp,ct,ct,xgl.dncheck,1,tp,HINTMSG_ATOHAND)
	if #tg>0 and Duel.Search(tg)>0 then
		local damchk=false
		local og=Duel.GetGroupOperatedByThisEffect(e):Filter(aux.PLChk,nil,tp,LOCATION_HAND)
		if #og>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			if Duel.Damage(tp,#og*1000,REASON_EFFECT)>0 then
				damchk=true
			end
		end
		if not damchk then
			local c=e:GetHandler()
			local fid=c:GetFieldID()
			local alreadyInsertedCodes={}
			local groupCodes={}
			for tc in aux.Next(og) do
				tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1,fid)
				for _,code in ipairs({tc:GetCode()}) do
					if not alreadyInsertedCodes[code] then
						alreadyInsertedCodes[code]=true
						table.insert(groupCodes,code)
					end
				end
			end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE|EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_FORBIDDEN)
			e1:SetTargetRange(0xff,0xff)
			e1:SetTarget(s.bantg)
			e1:SetLabel(fid,table.unpack(groupCodes))
			e1:SetReset(RESET_PHASE|PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end	
end
function s.bantg(e,c)
	local label={e:GetLabel()}
	local fid=table.remove(label,1)
	return c:HasFlagEffectLabel(id,fid) or c:IsCode(table.unpack(label))
end