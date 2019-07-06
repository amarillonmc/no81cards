--VOICEROID 茜
local m=33700784
local cm=_G["c"..m]
if not RSVoVal then
   RSVoVal=RSVoVal or {}
   rsvo=RSVoVal
--other link material bug repair
function Auxiliary.LCheckOtherMaterial(c,mg,lc)
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL)}
	if #le==0 then return true end
	for _,te in pairs(le) do
		local f=te:GetValue()
		if not f or f(te,lc,mg) then return true end
	end
	return false
end
function Auxiliary.LExtraFilter(c,f,lc)
	if c:IsLocation(LOCATION_ONFIELD) and not c:IsFaceup() then return false end
	return c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL) and (c:IsCanBeLinkMaterial(lc) or ((bit.band(c:GetOriginalType(),TYPE_SPELL)~=0 or bit.band(c:GetOriginalType(),TYPE_TRAP)~=0) and not c:IsType(TYPE_MONSTER))) and (not f or f(c))
end
function rsvo.LPLinkFunction(c)   
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE+RACE_MACHINE),2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(rsvo.linkcon)
	e1:SetOperation(rsvo.linkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
end
function rsvo.lmfilter(c,lc)
	local tp=lc:GetControler()
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsLinkRace(RACE_CYBERSE+RACE_MACHINE) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function rsvo.linkcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(rsvo.lmfilter,tp,LOCATION_MZONE,0,1,nil,c) and Duel.CheckLPCost(tp,1500)
end
function rsvo.linkop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,1500)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local mg=Duel.SelectMatchingCard(tp,rsvo.lmfilter,tp,LOCATION_MZONE,0,1,1,nil,c)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_LINK)
end
function rsvo.OneReplaceLinkFunction(c)  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(rsvo.linkcon2)
	e1:SetOperation(rsvo.linkop2)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
end
function rsvo.lmfilter2(c,lc,tp)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsSetCard(0x144c) and not c:IsCode(lc:GetCode()) and Duel.IsExistingMatchingCard(rsvo.lmfilter3,tp,LOCATION_MZONE,0,1,c,lc,c)
end
function rsvo.lmfilter3(c,lc,rc) 
	local tp=lc:GetControler()
	local g=Group.FromCards(c,rc)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsLinkRace(RACE_CYBERSE+RACE_MACHINE) and aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_LMATERIAL) and Duel.GetLocationCountFromEx(tp,tp,g)>0
end
function rsvo.linkcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(rsvo.lmfilter2,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function rsvo.linkop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local mg1=Duel.SelectMatchingCard(tp,rsvo.lmfilter2,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local mg2=Duel.SelectMatchingCard(tp,rsvo.lmfilter3,tp,LOCATION_MZONE,0,1,1,mg1:GetFirst(),c,mg1:GetFirst())
	mg1:Merge(mg2)
	c:SetMaterial(mg1)
	Duel.SendtoGrave(mg1,REASON_LINK)
end
function rsvo.YukaLinkFunction(c)  
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE) 
	c:EnableReviveLimit()  
	rsvo.OneReplaceLinkFunction(c) 
	aux.AddLinkProcedure(c,rsvo.lmatfilter,1,3,rsvo.lcheck)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_SELF_TOGRAVE)
	e1:SetCondition(rsvo.sdcon)
	c:RegisterEffect(e1)
end
function rsvo.lmatfilter(c)
	return c:IsLinkRace(RACE_CYBERSE+RACE_MACHINE) or c:IsCode(33700789)
end
function rsvo.lcheck(g,lc)
	return g:GetCount()==3 or (g:GetCount()==1 and g:IsExists(Card.IsCode,1,nil,33700789))
end
function rsvo.sdfilter(c)
	return c:IsFaceup() and c:IsCode(33700789)
end
function rsvo.sdcon(e)
	return Duel.IsExistingMatchingCard(rsvo.sdfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end

end
-------------------
if cm then
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.lfilter,2,2)
	--extra link
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTarget(cm.mattg)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetTargetRange(LOCATION_SZONE,0)
	e0:SetValue(cm.matval)
	c:RegisterEffect(e0)  
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)  
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function cm.thfilter(c,tp,setable)
	return c:IsType(TYPE_TRAP) and (c:IsAbleToHand() or (setable and c:IsSSetable())) and (c:IsControler(tp) or setable)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetHandler():GetMutualLinkedGroup()
	local setable=g:IsExists(Card.IsCode,1,nil,m+1) and true or false 
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.thfilter(chkc,tp,setable) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp,setable) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp,setable)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local g=e:GetHandler():GetMutualLinkedGroup()
	local setable=g:IsExists(Card.IsCode,1,nil,m+1) and true or false 
	local b1=tc:IsAbleToHand()
	local b2=e:GetHandler():IsRelateToEffect(e) and setable and tc:IsAbleToHand()
	if not b1 and not b2 then return end
	if b1 and (not b2 or not Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
	   Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else
		Duel.SSet(tp,tc)
	end
end
function cm.lfilter(c)
	return c:IsLinkRace(RACE_CYBERSE+RACE_MACHINE) or c:IsType(TYPE_TRAP)
end
function cm.matval(e,c,mg)
	return c:IsCode(m)
end
function cm.mattg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP)
end

---------------------
end