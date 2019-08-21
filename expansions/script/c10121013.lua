--天使长 命运之伊瑟瑞尔
if not pcall(function() require("expansions/script/c10121001") end) then require("script/c10121001") end
local m=10121013
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsdio.AngelHandXyzEffect(c,true)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.matg)
	e2:SetOperation(cm.maop)
	c:RegisterEffect(e2)
	if cm.check==nil then
	   cm.check=true
	   --checkremove
	   local ge1=Effect.CreateEffect(c)
	   ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	   ge1:SetCode(EVENT_DETACH_MATERIAL)
	   ge1:SetOperation(cm.ctop)
	   Duel.RegisterEffect(ge1,0)
	end
end
function cm.matg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.GetFlagEffect(tp,m)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
end
function cm.maop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	local ct=Duel.GetFlagEffect(tp,m)
	local xyzct=math.min(hg:GetCount(),ct)
	local tbl={}
	for i=1,xyzct do
		tbl[i]=i
	end
	local ct2=Duel.AnnounceNumber(tp,table.unpack(tbl))
	local xyzg=Duel.GetDecktopGroup(1-tp,ct2)
	if not c:IsRelateToEffect(e) or not c:IsType(TYPE_XYZ) or hg:GetCount()<1 then return end 
	if xyzg:GetCount()>0 then
	   Duel.Overlay(c,xyzg)
	end
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	for i=1,eg:GetCount() do
		Duel.RegisterFlagEffect(rp,m,RESET_PHASE+PHASE_END,0,1)
	end
end

--[[if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10121013
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsdio.AngelHandXyzEffect(c)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.macon)
	e2:SetCost(cm.macost)
	e2:SetOperation(cm.maop)
	c:RegisterEffect(e2)
end
function cm.macost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.macon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=6 and e:GetHandler():IsType(TYPE_XYZ)
end
function cm.maop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsType(TYPE_XYZ) or hg:GetCount()<=5 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=hg:Select(1-tp,hg:GetCount()-5,hg:GetCount()-5,nil)
	if g:GetCount()>0 then
	   Duel.Overlay(c,g)
	end
end
--]]