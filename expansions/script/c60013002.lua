Heidemarie=Heidemarie or {}
Heidemarie.loaded_metatable_list={}

Duel.LoadScript("c60010000.lua")

function Heidemarie.AnXi(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DISCARD)
	e1:SetTarget(Heidemarie.AnXitg)
	e1:SetOperation(Heidemarie.AnXiop)
	c:RegisterEffect(e1)
end
function Heidemarie.LianJie(c)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(Heidemarie.LianJieop)
	c:RegisterEffect(e1)
end

function Heidemarie.AnXitg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckActivateEffect(false,false,false)~=nil end
end
function Heidemarie.AnXiop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ce=e:GetHandler():GetActivateEffect()
	if ce then MTC.ActivateEffect(ce,tp,e) end
end
function Heidemarie.LianJieop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60013002,1))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end