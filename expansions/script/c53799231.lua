local m=53799231
local cm=_G["c"..m]
cm.name="绝人之路"
if not require and Duel.LoadScript then
    function require(str)
        local name=str
        for word in string.gmatch(str,"%w+") do
            name=word
        end
        Duel.LoadScript(name..".lua")
        return true
    end
end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,function(re,tp,cid)return not (re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsLocation(LOCATION_HAND))end)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,m+500,RESET_PHASE+PHASE_END,0,1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0 and Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetTurnPlayer()==tp and not Duel.CheckPhaseActivity() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SSET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetCondition(function(e)return Duel.GetFlagEffect(e:GetHandlerPlayer(),m+500)~=0 end)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetCondition(aux.TRUE)
	e2:SetValue(function(e,re,tp)return re:GetHandler():IsType(TYPE_SPELL) and re:GetHandler():IsLocation(LOCATION_HAND)end)
	Duel.RegisterEffect(e2,tp)
end
function cm.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():IsLocation(LOCATION_HAND) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,1) and not Duel.IsExistingMatchingCard(Card.IsPublic,tp,LOCATION_HAND,0,1,nil)
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	SNNM.SetPublicGroup(e:GetHandler(),g,RESET_EVENT+RESETS_STANDARD,0)
	g:KeepAlive()
	e:SetLabelObject(g)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.filter(c)
	return cm.cfilter(c) and c:IsLocation(LOCATION_HAND) and c:IsPublic()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(cm.filter,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if #g==0 or ft<1 then return end
	local ct=math.min(2,#g,ft)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
	local sg=g:Select(1-tp,ct,ct,nil)
	local dct=Duel.SSet(tp,sg)
	if dct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,dct,REASON_EFFECT)
	end
end
