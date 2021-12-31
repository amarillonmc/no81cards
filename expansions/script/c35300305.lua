--伪装美人 致命诱惑
local m=35300305
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--link summon
	aux.AddLinkProcedure(c,cm.matfilter,1)
	c:EnableReviveLimit()
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(cm.matval)
	c:RegisterEffect(e1)
	--indes and reflect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetCondition(cm.spcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,0))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,m)
	e7:SetTarget(cm.eqtg)
	e7:SetOperation(cm.eqop)
	c:RegisterEffect(e7)  
end
function cm.matfilter(c)
	return c:IsLinkRace(RACE_REPTILE) and c:IsAttack(0) and c:IsDefense(0)
end
function cm.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(Card.IsControler,1,nil,1-tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end

function cm.ovfilter1(c)
	return aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) 
end
function cm.filter(c,e,tp,mc)
	return c:IsType(TYPE_XYZ) and c:IsRankBelow(4) and c:IsRace(RACE_FIEND+RACE_DRAGON+RACE_WARRIOR) and c:IsAttack(0) and c:IsDefense(0)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and aux.MustMaterialCheck(mc,tp,EFFECT_MUST_BE_XMATERIAL)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.ovfilter1,1-tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.SelectMatchingCard(tp,cm.ovfilter1,1-tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if #sg>0 and not sg:GetFirst():IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
		   local tc1=g:GetFirst()
		   if sg:GetFirst():IsOnField() then
			  if not (sg:GetFirst():IsOnField() and c:IsOnField()) then return end
			  sg:AddCard(c)
			  tc1:SetMaterial(sg)
			  Duel.SpecialSummon(tc1,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) 
			  Duel.Overlay(tc1,sg)
			  tc1:CompleteProcedure()
		   end
		end
	end
end