local m=53796014
local cm=_G["c"..m]
cm.name="败根"
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
	local e1=SNNM.recst(c,0)
	local e2=SNNM.renft(c,aux.Stringid(m,0),CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE,EFFECT_TYPE_TRIGGER_F,0,EVENT_DESTROYED,LOCATION_SZONE,0,cm.con,0,cm.tg,cm.op)
end
function cm.cfilter(c)
	local p=c:GetPreviousControler()
	return c:IsPreviousLocation(LOCATION_MZONE) and rp~=p and c:GetPreviousRaceOnField()>0
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(cm.cfilter,nil)
	local r=0
	for tc in aux.Next(g) do r=r|tc:GetPreviousRaceOnField() end
	e:SetLabel(r)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local r=e:GetLabel()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or r==0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetLabel(r)
	e1:SetTarget(function(e,c)return c:IsRace(e:GetLabel())end)
	e1:SetValue(-800)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
