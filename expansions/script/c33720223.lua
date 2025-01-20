--[[
晦空士耀跃雨
Sepialife Uproar
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[When a card or effect is activated: Look at your opponent's Deck, take 1 "Sepialife" card from it, and either add it to their hand (and keep it revealed)
	or send it to the GY, and if you do either, negate that effect. If you cannot do any, you take 3000 damage instead.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORIES_SEARCH|CATEGORY_TOGRAVE|CATEGORY_DISABLE|CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetFunctions(nil,nil,s.target,s.activate)
	c:RegisterEffect(e1)
	--During the End Phase, if you control no cards while this card is in your GY: You can Set it to your field.
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetFunctions(s.setcon,nil,s.settg,s.setop)
	c:RegisterEffect(e2)
end
--E1
function s.filter(c,tp)
	local ok=true
	local eset={c:IsHasEffect(EFFECT_CANNOT_TO_HAND)}
	for _,e in ipairs(eset) do
		if e:GetOwner()~=c then
			ok=false
			break
		end
	end
	if not ok then
		ok=true
		local eset={c:IsHasEffect(EFFECT_CANNOT_TO_GRAVE)}
		for _,e in ipairs(eset) do
			if e:GetOwner()~=c then
				ok=false
				break
			end
		end
	end
	return ok and (s.thfilter(c,tp) or s.tgfilter(c,tp))
end
function s.thfilter(c,tp)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED) and Duel.IsPlayerCanSendtoHand(1-tp,c)
end
function s.tgfilter(c,tp)
	return Duel.IsPlayerCanSendtoGrave(1-tp,c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetDeck(1-tp)
		return #g>0 and g:IsExists(s.filter,1,nil,tp)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,3000)
end
function s.opfilter(c,tp)
	return c:IsSetCard(ARCHE_SEPIALIFE) and (c:IsAbleToHand(1-tp) or c:IsAbleToGrave())
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local damchk=true
	local g=Duel.GetDeck(1-tp)
	if #g>0 then
		Duel.ConfirmCards(tp,g)
		Duel.HintMessage(tp,HINTMSG_OPERATECARD)
		local tg=g:FilterSelect(tp,s.opfilter,1,1,nil,tp)
		if #tg>0 then
			local tc=tg:GetFirst()
			if Duel.ToHandOrGrave(tc,tp,1-tp)>0 then
				if tc:IsLocation(LOCATION_GRAVE) then
					damchk=false
				elseif tc:IsLocation(LOCATION_HAND) then
					damchk=false
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetDescription(66)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
					e1:SetCode(EFFECT_PUBLIC)
					e1:SetReset(RESET_EVENT|RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			end
		end
	end
	if not damchk then
		Duel.NegateEffect(ev)
	else
		Duel.Damage(tp,3000,REASON_EFFECT)
	end
end

--E2
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:HasFlagEffect(id) and c:IsSSetable() end
	c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_CHAIN,0,1)
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
	end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsSSetable() then
		Duel.SSet(tp,c)
	end
end