--飞球梦工厂
local m=13254073
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.drcon1)
	e3:SetOperation(cm.drop1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--sp_summon effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(cm.regcon)
	e5:SetOperation(cm.regop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetCode(EVENT_CHAIN_SOLVED)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(cm.drcon2)
	e7:SetOperation(cm.drop2)
	c:RegisterEffect(e7)

	--indes
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e8:SetRange(LOCATION_SZONE)
	e8:SetTargetRange(LOCATION_ONFIELD,0)
	e8:SetTarget(cm.indtg)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e9)
	
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,5)
end
function cm.cfilter(c)
	return #(tama.tamas_getElements(c))~=0
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardDeck(tp,5,REASON_EFFECT)>0 then
		if Duel.GetOperatedGroup():IsExists(cm.cfilter,1,nil) then
			Duel.Draw(tp,1,REASON_EFFECT)
		elseif Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then 
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD) 
			--activate limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(cm.actlimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.actlimit(e,re,rp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_GRAVE)
end
function cm.filter(c)
	return c:IsSummonLocation(LOCATION_HAND+LOCATION_DECK) and c:IsSetCard(0x5356)
end
function cm.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil)
		and (not re or (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS)))
end
function cm.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil)
		and re and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,m)
	Duel.ResetFlagEffect(tp,m)
	Duel.DiscardDeck(tp,n*2,REASON_EFFECT)
end
function cm.indtg(e,c)
	return c:IsSetCard(0x5356)
end
