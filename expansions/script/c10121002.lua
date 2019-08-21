--大魔王 痛苦之王督瑞尔
if not pcall(function() require("expansions/script/c10121001") end) then require("script/c10121001") end
local m=10121002
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsdio.DMSpecialSummonEffect(c,m,true)
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCountLimit(1,m+100)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.xyzcon)
	e2:SetTarget(cm.xyztg)
	e2:SetOperation(cm.xyzop)
	c:RegisterEffect(e2)
	local e1=e2:Clone()
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e1)
end
function cm.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.cfilter(c,tp,e)
	return c:IsControler(1-tp) and not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler() and (not e or (c:IsRelateToEffect(e)))
end
function cm.filter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=eg:Filter(cm.cfilter,nil,tp)
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,tg) and tg:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,tg)
	for rc in aux.Next(eg) do
		rc:CreateEffectRelation(e)
	end
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	local tg=eg:Filter(cm.cfilter,nil,tp,e)
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) and tc:IsType(TYPE_XYZ) and tg:GetCount()>0 and tc:IsControler(tp) then
	   tg:AddCard(c)
	   Duel.Overlay(tc,tg)
	end
end
