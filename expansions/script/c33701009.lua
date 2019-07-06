--GA-04 亚玛丽欧·维拉蒂安 【PR】
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33701009
local cm=_G["c"..m]
function cm.initial_effect(c)
	rscf.SetSummonCondition(c)
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,aux.TRUE,40,40)  
	local e1=rsef.I(c,{m,0},{1,m,2},"sp",nil,LOCATION_EXTRA+LOCATION_GRAVE,nil,rscost.lpcost(true),cm.sptg,cm.spop)
	local e3=rsef.SV_ADD(c,"att",cm.attfilter)
	local e5=rsef.SV_INDESTRUCTABLE(c,"battle",1,cm.con(ATTRIBUTE_LIGHT))
	local e8=rsef.I(c,{m,2},1,"th","tg",LOCATION_MZONE,cm.con(ATTRIBUTE_WATER),nil,rstg.target({Card.IsAbleToHand,"th",LOCATION_ONFIELD,0,1,1,c}),cm.thop)
	local e9,e10=rsef.FV_UPDATE(c,"atk,def",1000,cm.atktg,{LOCATION_MZONE,0},cm.con(ATTRIBUTE_FIRE))
	local e11=rsef.FV_INDESTRUCTABLE(c,"effect",1,cm.atktg,{LOCATION_MZONE,0},cm.con(ATTRIBUTE_FIRE))
	local e12,e13=rsef.FV_UPDATE(c,"atk,def",-1000,nil,{0,LOCATION_MZONE },cm.con(ATTRIBUTE_WIND))
	local e14=rsef.FV_INDESTRUCTABLE(c,"battle",1,nil,{0,LOCATION_MZONE },cm.con(ATTRIBUTE_WIND))
	local e18=rsef.STO(c,EVENT_LEAVE_FIELD,{m,3},nil,"sp","de,dsp",cm.rcon,nil,cm.rtg,cm.rop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.sumlimit)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.discon)
	e4:SetTarget(cm.distg)
	e4:SetOperation(cm.disop)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BE_BATTLE_TARGET)
	e6:SetCondition(cm.con(ATTRIBUTE_DARK))
	e6:SetOperation(cm.naop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_DEFENSE_ATTACK)
	e7:SetValue(1)
	e7:SetCondition(cm.con(ATTRIBUTE_EARTH))
	c:RegisterEffect(e7)
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_FIELD)
	e15:SetCode(EFFECT_DIRECT_ATTACK)
	e15:SetRange(LOCATION_MZONE)
	e15:SetTargetRange(LOCATION_MZONE,0)
	e15:SetCondition(cm.con(ATTRIBUTE_DEVINE))
	c:RegisterEffect(e15)
	local e16=Effect.CreateEffect(c)
	e16:SetType(EFFECT_TYPE_FIELD)
	e16:SetCode(EFFECT_CHANGE_DAMAGE)
	e16:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e16:SetRange(LOCATION_MZONE)
	e16:SetTargetRange(0,1)
	e16:SetCondition(cm.con(ATTRIBUTE_DEVINE))
	e16:SetValue(cm.damval)
	c:RegisterEffect(e16)
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e17:SetCode(EVENT_LEAVE_FIELD_P)
	e17:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e17:SetOperation(cm.leaveop)
	c:RegisterEffect(e17)
	e18:SetLabelObject(e17)
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function cm.rfilter(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetLabelObject():GetLabelObject()
	if chk==0 then return og:IsExists(cm.rfilter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetTargetCard(og)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
end
function cm.rop(e,tp)
	local c=e:GetHandler()
	local og=rsgf.GetTargetGroup()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=og:FilterSelect(tp,cm.rfilter,1,1,nil):GetFirst()
	if tc and rssf.SpecialSummon(tc)>0 then
		local e1=rsef.SV_IMMUNE_EFFECT({c,tc},rsval.imoe,nil,rsreset.est)
		local e2=rsef.SV_INDESTRUCTABLE({c,tc},"battle",1,nil,rsreset.est)
	end
end
function cm.leaveop(e,tp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	local rg=g:Filter(Card.IsType,nil,TYPE_XYZ)
	if #rg>0 then
		rg:KeepAlive()
		e:SetLabelObject(rg)
	else
		e:SetLabelObject(nil)
	end
end
function cm.val(e,re,dam,r,rp,rc)
	return dam*2
end
function cm.mfilter(c,xyzc)
	return c:IsRace(RACE_PSYCHO)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.cfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(2)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then
		c:CompleteProcedure()
		local lp=rscost[e]
		if not lp or lp<1000 or not c:IsType(TYPE_XYZ) then return end
		local ct=math.floor(lp/1000)
		local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_DECK,0,nil)
		if #g<ct then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local xg=g:Select(tp,ct,ct,nil)
		Duel.Overlay(c,xg)
	end
end
function cm.attfilter(e)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	local att=0
	for tc in aux.Next(g) do
		att=att|tc:GetAttribute()
	end
	return att
end
function cm.con(att)
	return function(e)
		return e:GetHandler():IsAttribute(att)
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local loc,tg=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TARGET_CARDS)
	if not tg or not tg:IsContains(c) then return false end
	return Duel.IsChainDisablable(ev) and loc~=LOCATION_DECK and cm.con(ATTRIBUTE_DARK)(e)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateEffect(ev)
end
function cm.naop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function cm.thop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		local lp=2*Duel.GetLP(tp)
		Duel.SetLP(tp,lp)
	end
end
function cm.atktg(e,c)
	return c~=e:GetOwner()
end