if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53729003
local cm=_G["c"..m]
cm.name="心化大贤 祭心"
cm.upside_code=m
cm.downside_code=m+2
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local es=aux.AddLinkProcedure(c,cm.matfilter,1,1)
	es:SetValue(es:GetValue()|SUMMON_VALUE_SELF)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and c:GetOriginalCode()==53729003 end)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.matfilter(c)
	return cm.TripleLinkedZone(c:GetControler())&(1<<c:GetSequence())~=0 
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp,se)return c:IsCode(m) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK end)
	Duel.RegisterEffect(e1,tp)
	if not c:IsSummonType(SUMMON_VALUE_SELF) then return end
	local tcode=c.downside_code
	Duel.Hint(HINT_CARD,0,m)	
	c:SetEntityCode(tcode,true)
	SNNM.ReplaceEffect(c,tcode,0,0)
	Duel.Hint(HINT_CARD,0,m+2)
	Duel.RaiseEvent(c,EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsLevel(4) and c:IsRace(RACE_PYRO)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() and c:IsCanBeEffectTarget(e) and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,c)
	g:Merge(c)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then Duel.SendtoHand(g,nil,REASON_EFFECT) end
end
function cm.TripleLinkedZone(tp)
	local lg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local z3,z2,z1=0,0,0
	for tc in aux.Next(lg) do
		local zone=tc:GetLinkedZone(tp)&0x7f
		z3=z2&zone|z3
		z2=z1&zone|z2
		z1=z1~zone
	end
	return z3
end
