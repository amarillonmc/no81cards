--[[
水晶魔法大妖精 吉贝尔
Gebil, The Crystal Sorcery
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[(Quick Effect): You can send this card from your hand to the GY; apply the following effect, also, each time your opponent Special Summons a monster(s) this turn,
	immediately banish the top card of your Deck, but if it was banished by this effect, its effects cannot be activated this turn.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetRelevantTimings()
	e1:HOPT()
	e1:SetFunctions(nil,aux.ToGraveSelfCost,aux.DummyCost,s.operation)
	c:RegisterEffect(e1)
end
--E1
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:Desc(2,id)
	e1:SetCategory(CATEGORY_TOHAND|CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE|PHASE_END)
	e1:OPT()
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	aux.RegisterMaxxCEffect(c,id,tp,0,EVENT_SPSUMMON_SUCCESS,s.rmcon,s.rmopOUT,s.rmopIN,nil,RESET_PHASE|PHASE_END)
end
function s.thfilter(c)
	return c:HasFlagEffect(id+100) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.Group(s.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if #g>0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,LOCATION_REMOVED)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,LOCATION_REMOVED)
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(s.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if #g==0 then return end
	Duel.HintMessage(tp,HINTMSG_ATOHAND)
	local tg=g:Select(tp,1,#g,nil)
	if #tg>0 and Duel.Search(tg,nil,tp)>0 then
		local ct=Duel.GetOperatedGroup():FilterCount(aux.PLChk,nil,tp,LOCATION_HAND)
		if ct>0 then
			Duel.Damage(tp,ct*200,REASON_EFFECT)
		end
	end
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function s.rmopOUT(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	local g=Duel.GetDecktopGroup(tp,1)
	if g and #g>0 then
		local tc=g:GetFirst()
		Duel.DisableShuffleCheck()
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and aux.BecauseOfThisEffect(e)(tc) then
			tc:RegisterFlagEffect(id+100,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:Desc(1,id)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
function s.rmopIN(e,tp,eg,ep,ev,re,r,rp,n)
	Duel.Hint(HINT_CARD,tp,id)
	local ct=Duel.GetFlagEffect(tp,id)
	local g=Duel.GetDecktopGroup(tp,ct)
	if g and #g>=ct then
		Duel.DisableShuffleCheck()
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
			local c=e:GetHandler()
			local og=Duel.GetGroupOperatedByThisEffect(e)
			for tc in aux.Next(g) do
				tc:RegisterFlagEffect(id+100,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
				local e1=Effect.CreateEffect(c)
				e1:Desc(1,id)
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
				tc:RegisterEffect(e1)
			end
		end
	end
end