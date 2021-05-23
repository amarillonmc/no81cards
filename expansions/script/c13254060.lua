--飞球的灵气世界
local m=13254060
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e2:SetRange(LOCATION_HAND+LOCATION_DECK)
	e2:SetCountLimit(1,TAMA_THEME_CODE)
	e2:SetCondition(cm.recon)
	e2:SetOperation(cm.reop)
	c:RegisterEffect(e2)
	
end
function cm.cfilter(c)
	return #(tama.tamas_getElements(c))~=0
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==1 and Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,nil)>=Duel.GetFieldGroupCount(tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0)*7/5
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,1-tp,m)
		Duel.Remove(c,POS_FACEDOWN,REASON_RULE)
		if c:GetPreviousLocation()==LOCATION_HAND then
			Duel.Draw(tp,1,REASON_RULE)
		end
		Duel.DiscardDeck(tp,5,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(cm.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
