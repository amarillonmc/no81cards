local m=53753011
local cm=_G["c"..m]
cm.name="神诞的异铜"
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
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.drcon)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetTarget(cm.tgtg)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
end
cm.has_text_type=TYPE_DUAL
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local le={e:GetHandler():IsHasEffect(m)}
	local res=true
	for _,v in pairs(le) do if v:GetLabelObject()==tc then if tc:GetFlagEffect(m)>0 then res=false else v:Reset() end end end
	return res and tc:IsSummonPlayer(tp) and tc:IsFaceup() and tc:IsType(TYPE_DUAL) and SNNM.DualState(tc)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.GetFlagEffect(tp,m)<1 end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
	local tc=eg:GetFirst()
	tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(m)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.tgfilter(c)
	return c:IsType(TYPE_DUAL) and c:IsLevel(4) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,nil)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_REMOVED,0,nil,TYPE_DUAL)
	local opt=0
	if #g1>0 and #g2>0 then opt=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))+1 elseif #g1>0 then opt=1 elseif #g2>0 then opt=2 end
	if opt==0 then return end
	cm["op"..opt](tp)
	if not (#g1>0 and #g2>0) then return end
	if Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.BreakEffect()
		if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then cm["op"..(3-opt)](tp) end
	end
end
function cm.op1(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 then return false end
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function cm.op2(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_REMOVED,0,1,1,nil,TYPE_DUAL)
	if #g==0 then return false end
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
end
