--明日的方舟·罗德岛
local m=29065510
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(1,1)
	e1:SetTarget(cm.stg)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e2)
	--Effect 2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_XYZ_LEVEL)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c29065510.lvtg)
	e3:SetValue(c29065510.lvval)
	c:RegisterEffect(e3)
	--local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(m,0))
	--e3:SetType(EFFECT_TYPE_FIELD)
	--e3:SetCode(EFFECT_SPSUMMON_PROC)
	--e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e3:SetRange(LOCATION_EXTRA)
	--e3:SetCountLimit(1,m)
	--e3:SetCondition(cm.xyzcon)
	--e3:SetTarget(cm.xyztg)
	--e3:SetOperation(cm.xyzop)
	--e3:SetValue(SUMMON_TYPE_XYZ)
	--local e4=Effect.CreateEffect(c)
	--e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	--e4:SetTargetRange(LOCATION_EXTRA,0)
	--e4:SetRange(LOCATION_FZONE)
	--e4:SetTarget(cm.eftg)
	--e4:SetLabelObject(e3)
	--c:RegisterEffect(e4)
	--Effect 3 
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(m,1))
	e12:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e12:SetCode(EVENT_PHASE+PHASE_END)
	e12:SetRange(LOCATION_FZONE)
	e12:SetCountLimit(1)
	e12:SetTarget(cm.tg)
	e12:SetOperation(cm.op)
	c:RegisterEffect(e12)
end
function c29065510.lvtg(e,c)
	return c:IsLevelAbove(1) and c:IsSetCard(0x87af)
end
function c29065510.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc:IsSetCard(0x87af) then return rc:GetRank()+lv*0x10000
	else return lv end
end
-------------------------------------------------
function cm.stf(c) 
	local b1=c:IsSetCard(0x87af)
	local b2=(_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)
	return b1 or b2
end
---------------------------------------------------Effect 1
function cm.stg(e,c) 
	local tp=e:GetHandlerPlayer()
	return cm.stf(c) and c:GetSummonPlayer()==tp
end
-----------------------------------------------------Effect 2
function cm.eftg(e,c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_XYZ)
end
function cm.xyzfilter(c,e)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_MONSTER) and c:IsCanBeXyzMaterial(e:GetHandler()) and not c:IsCode(e:GetHandler():GetCode())
end
function cm.cfilter(c)
	return c:IsDiscardable()
end
function cm.xyzcon(e,c,tp)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_MZONE,0,1,nil,e) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil)
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local g=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_MZONE,0,nil,e)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		Duel.DiscardHand(tp,cm.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
		local xg=g:Select(tp,1,1,nil)
		xg:KeepAlive()
		e:SetLabelObject(xg)
	return true
	else return false end
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=e:GetLabelObject()
	local mg2=mg:GetFirst():GetOverlayGroup()
	if mg2:GetCount()~=0 then
	   Duel.Overlay(c,mg2)
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	mg:DeleteGroup()
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
--------------------------------------------------------Effect 3 
function cm.df(c)
	return cm.stf(c) and c:IsAbleToDeck()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.df,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.df),tp,LOCATION_GRAVE,0,1,99,nil)
	local ct=#g
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	if ct<3 then return false end
	local dt=math.floor(ct/3) 
	Duel.BreakEffect()
	Duel.Draw(tp,dt,REASON_EFFECT)
end