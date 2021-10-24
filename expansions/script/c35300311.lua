--伪装神父 虔诚信徒
local m=35300311
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--link summon
	aux.AddLinkProcedure(c,cm.matfilter,1)
	c:EnableReviveLimit()
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(0,LOCATION_MZONE)
	e0:SetValue(cm.matval)
	c:RegisterEffect(e0)
	--indes and reflect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(cm.spcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
	--accelerate synchro summon
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
--link summon
function cm.matfilter(c)
	return c:IsLinkRace(RACE_REPTILE) and c:IsAttack(0) and c:IsDefense(0)
end
--extra material
function cm.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(Card.IsControler,1,nil,1-tp)
end
--indes and reflect
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
--accelerate synchro summon
function cm.ovfilter1(c)
	return c:IsFaceup() and c:IsRace(RACE_REPTILE) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_SMATERIAL) 
end
function cm.filter(c,e,tp,mc)
	return (c:IsType(TYPE_SYNCHRO) and c:IsLevelBelow(7) and c:IsRace(RACE_FIEND+RACE_DRAGON+RACE_REPTILE) and c:IsAttackBelow(2300))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and aux.MustMaterialCheck(mc,tp,EFFECT_MUST_BE_SMATERIAL)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.ovfilter1,1-tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.SelectMatchingCard(tp,cm.ovfilter1,1-tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if #sg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 and not sg:GetFirst():IsImmuneToEffect(e) then
		   local tc1=g:GetFirst()
		   local tc2=sg:GetFirst()
		   local g1=Group.FromCards(c,tc2)
		   Duel.HintSelection(g1)
		   Duel.SendtoGrave(g1,REASON_EFFECT)
		   Duel.BreakEffect()
		   Duel.SpecialSummon(tc1,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) 
		   tc1:CompleteProcedure()
		end
	end
end