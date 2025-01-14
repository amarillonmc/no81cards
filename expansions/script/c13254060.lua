--飞球的灵气世界
local m=13254060
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e2:SetCountLimit(1,TAMA_THEME_CODE+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(cm.recon)
	e2:SetOperation(cm.reop)
	c:RegisterEffect(e2)
	--[[
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e2:SetRange(LOCATION_HAND+LOCATION_DECK)
	e2:SetCountLimit(1,TAMA_THEME_CODE)
	e2:SetCondition(cm.recon)
	e2:SetOperation(cm.reop)
	c:RegisterEffect(e2)
	]]
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(cm.drtg)
	e3:SetOperation(cm.drop)
	c:RegisterEffect(e3)
	elements={{"theme_effect",e2},{"tama_elements",{{TAMA_ELEMENT_MANA,1}}}}
	cm[c]=elements
	
end
function cm.cfilter(c)
	return #(tama.tamas_getElements(c))~=0
end
--[[
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==1 and Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,nil)>=Duel.GetFieldGroupCount(tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0)*7/10
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,1-tp,m)
		Duel.Remove(c,POS_FACEUP,REASON_RULE)
		if c:GetPreviousLocation()==LOCATION_HAND then
			Duel.Draw(tp,1,REASON_RULE)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_HAND_LIMIT)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(3)
		Duel.RegisterEffect(e1,tp)
	end
end
]]
function cm.recon(e,tp)
	return not e:GetHandler():IsForbidden() and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,1-tp,m)
	Duel.Remove(c,POS_FACEDOWN,REASON_RULE)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.DiscardDeck(tp,5,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(TAMA_THEME_CODE)
	e1:SetTargetRange(1,0)
	e1:SetValue(m)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.disop)
	Duel.RegisterEffect(e2,tp)
	--[[
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,0)
	e2:SetValue(cm.aclimit)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_HAND_LIMIT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetTargetRange(1,0)
	e3:SetValue(3)
	Duel.RegisterEffect(e3,tp)
	]]
end
function cm.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,5) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.ConfirmDecktop(tp,5)
		local g=Duel.GetDecktopGroup(tp,5)
		local sg=g:Filter(cm.cfilter,nil)
		if sg:GetCount()<=0 then return end
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
	end
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct=2
	if tama.isTheme(tp,m) then ct=3 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct-ht)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct=2
	if ht<ct then
		Duel.Draw(tp,ct-ht,REASON_EFFECT)
	end
	if tama.isTheme(tp,m) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
