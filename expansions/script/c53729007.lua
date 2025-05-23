if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53729007
local cm=_G["c"..m]
cm.name="心化根绝域神 尼奥阿日阿"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5533))
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(cm.op)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetCondition(cm.spcon)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ADJUST)
	e7:SetRange(0x1ff)
	e7:SetOperation(cm.chkop)
	c:RegisterEffect(e7)
end
function cm.chkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)==0 then c:RegisterFlagEffect(m,0,0,0,0) end
	if c:GetFlagEffect(m+50)==0 then c:RegisterFlagEffect(m+50,0,0,0,0) end
	local g1=Duel.GetMatchingGroup(function(c)return c:GetOriginalAttribute() and c:IsType(TYPE_FUSION) and c:IsFaceup()end,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(function(c)return c:GetOriginalAttribute() and c:IsType(TYPE_FUSION) and c:IsFaceup()end,tp,0,LOCATION_MZONE,nil)
	for tc1 in aux.Next(g1) do
		local flag1=c:GetFlagEffectLabel(m)
		c:SetFlagEffectLabel(m,flag1|tc1:GetAttribute())
	end
	for tc2 in aux.Next(g2) do
		local flag2=c:GetFlagEffectLabel(m+50)
		c:SetFlagEffectLabel(m+50,flag2|tc2:GetAttribute())
	end
end
function cm.rfilter(c,tp,sc)
	return c:IsCode(53729005) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and (c:IsControler(tp) or c:IsFaceup())
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local att1=c:GetFlagEffectLabel(m)
	local att2=c:GetFlagEffectLabel(m+50)
	return Duel.CheckReleaseGroup(tp,cm.rfilter,1,nil,tp,c) and ((c:IsControler(c:GetOwner()) and att1 and att1&0x1f==0x1f) or (c:IsControler(1-c:GetOwner()) and att2 and att2&0x1f==0x1f))
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,cm.rfilter,1,1,nil,tp,c)
	Duel.Release(g,REASON_SPSUMMON)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)>0 then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp and re:IsActiveType(TYPE_MONSTER)end)
	e1:SetTarget(cm.metg)
	e1:SetOperation(cm.meop)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)end)
	e2:SetTarget(cm.setg)
	e2:SetOperation(cm.seop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5533))
	e3:SetLabelObject(e1)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetTargetRange(LOCATION_SZONE,0)
	e4:SetTarget(function(e,c)return c:IsSetCard(0x5533) and c.downside_code end)
	e4:SetLabelObject(e2)
	Duel.RegisterEffect(e4,tp)
	Duel.RegisterFlagEffect(tp,m,0,0,0)
end
function cm.metg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,Group.FromCards(e:GetHandler()),nil,1,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.meop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,1,nil,Group.FromCards(e:GetHandler()),nil,1,1):GetFirst()
	if tc then Duel.LinkSummon(tp,tc,nil) end
end
function cm.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetOriginalCode(),0x5533,c:GetOriginalType(),c:GetBaseAttack(),c:GetTextAttack(),c:GetTextDefense(),c:GetOriginalRace(),c:GetOriginalAttribute()) and c.downside_code end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.seop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	local tcode=c.downside_code
	Duel.Hint(HINT_CARD,0,c:GetOriginalCode()) 
	c:SetEntityCode(tcode,true)
	SNNM.ReplaceEffect(c,tcode,0,0)
	Duel.Hint(HINT_CARD,0,tcode)
	Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
end
