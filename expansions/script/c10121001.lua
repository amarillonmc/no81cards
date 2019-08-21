--大魔王 折磨女王安达利尔
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10121001
local cm=_G["c"..m]
if not rsv.Diablo then
   rsv.Diablo={}
   rsdio=rsv.Diablo
function rsdio.AngelHandXyzEffect(sc,bool)
	local e1=Effect.CreateEffect(sc)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(10121011)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	sc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(sc)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCode(10121011)
	sc:RegisterEffect(e2)
	if not bool then
	   local e3=Effect.CreateEffect(sc)
	   e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	   e3:SetType(EFFECT_TYPE_SINGLE)
	   e3:SetRange(LOCATION_DECK)
	   e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	   sc:RegisterEffect(e3)
	end
	return e1
end
function rsdio.DMSpecialSummonEffect(sc,mcode,bool)
	local e1=Effect.CreateEffect(sc)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC) 
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,mcode)
	e1:SetCondition(function(e,c)
	   if c==nil then return true end
	   if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	   return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.CheckRemoveOverlayCard(c:GetControler(),1,0,2,REASON_COST)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,c)
	   Duel.RemoveOverlayCard(tp,1,0,2,2,REASON_COST)
	end)
	sc:RegisterEffect(e1)
	if not bool then 
	   local e2=Effect.CreateEffect(sc)
	   e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	   e2:SetType(EFFECT_TYPE_SINGLE)
	   e2:SetRange(LOCATION_DECK)
	   e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	   sc:RegisterEffect(e2)
	end
	return e1
end
function rsdio.XyzEffect(sc,ct)
	local minct=math.ceil(ct/2)
	rscf.AddXyzProcedureLevelFree_Special(sc,aux.TRUE,rsdio.gfilter(ct),minct,99)
	rscf.SetExtraXyzMaterial(sc,rsdio.materialfilter,LOCATION_HAND,LOCATION_MZONE,rsdio.matop)
end
function rsdio.gfilter(ct)
	return function(g,xyzc,tp,ogbase)
		if g:FilterCount(rsdio.bookcheck,nil,tp)>1 then return false end
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) and not 
			g:IsExists(Card.IsHasEffect,1,nil,10121011) and #ogbase==0 then return false
		end
		if not g:IsExists(Card.IsHasEffect,1,nil,10121003) then 
			if g:IsExists(rsdio.bookcheck,1,nil,tp) then
				local tc=g:Filter(rsdio.bookcheck,nil,tp):GetFirst()
				if g:FilterCount(Card.IsXyzLevel,tc,xyzc,10)~=#g-1 then return false end
			else
				if g:FilterCount(Card.IsXyzLevel,nil,xyzc,10)~=#g then return false end
			end
		end
		if not g:IsExists(Card.IsHasEffect,1,nil,10121003) and #g<ct then return false end
		return true
	end
end
function rsdio.bookcheck(c,tp)
	return c:IsHasEffect(10121010) and c:IsControler(1-tp) and Duel.GetFlagEffect(tp,10121010)<=0
end
function rsdio.materialfilter(c,xyzc)
	local tp=xyzc:GetControler()
	return ((c:IsHasEffect(10121011) or Duel.IsPlayerAffectedByEffect(tp,10121011)) and c:IsControler(tp)) or rsdio.bookcheck(c,tp) and c:IsType(TYPE_MONSTER)
end
function rsdio.matop(e,tp,mat)
	if mat:IsExists(rsdio.bookcheck,1,nil,tp) then
		Duel.RegisterFlagEffect(tp,10121010,rsreset.pend,0,1)
	end
end
-------
end
if cm then
function cm.initial_effect(c)
	rsdio.DMSpecialSummonEffect(c,m)
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(cm.xyzcost)
	e2:SetCondition(cm.xyzcon)
	e2:SetTarget(cm.xyztg)
	e2:SetOperation(cm.xyzop)
	c:RegisterEffect(e2)
end
function cm.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) 
end
function cm.filter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if Duel.NegateActivation(ev) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) and tc:IsType(TYPE_XYZ) and tc:IsControler(tp) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,rc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
-----
end
