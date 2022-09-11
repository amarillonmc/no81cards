--现世通往冥界之门
local s,id,o=GetID()
Duel.LoadScript("c33201010.lua")
function s.initial_effect(c)
	aux.AddCodeList(c,33201009)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetLabel(0)
	e1:SetCost(s.cost)
	e1:SetTarget(MJ_VHisc.tg)
	e1:SetOperation(MJ_VHisc.op)
	c:RegisterEffect(e1)
	--MJspsm
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetLabel(1)
	e2:SetCost(s.cost)
	e2:SetTarget(MJ_VHisc.sptg)
	e2:SetOperation(MJ_VHisc.spop)
	c:RegisterEffect(e2)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(id,e:GetLabel()))
end