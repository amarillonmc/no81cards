--武装闪辉 梵弓伐楼利拿
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40010926,"Vairina")
local m=40010926
local cm=_G["c"..m]
function cm.PrayerDragon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_PrayerDragon
end
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,40009577,cm.matfilter,1,true,true)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	e2:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e2)  
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.thtg1)
	e3:SetOperation(cm.thop1)
	c:RegisterEffect(e3)  
end
function cm.matfilter(c)
	return cm.PrayerDragon(c)
end
function cm.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA 
end
function cm.sprfilter1(c,sc)
	return c:IsCanBeXyzMaterial(sc)
end
function cm.cfilter1(c)
	return c:IsCode(40009577)
end
function cm.cfilter2(c)
	return cm.PrayerDragon(c)
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCountFromEx(tp,tp,nil,c)~=0
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	--local ag1=Duel.GetOverlayGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local ag1=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	local ag2=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	--local mg1=ag1:FilterSelect(tp,cm.sprfilter1,1,2,nil,c)
	ag1:Merge(ag2)
	local cg=ag1:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-c:GetControler(),cg)
	end
	c:SetMaterial(ag1)
	local tc=ag1:GetFirst()
	while tc do
		if not tc:IsImmuneToEffect(e) and not tc:IsType(TYPE_TOKEN) then
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
		Duel.Overlay(c,Group.FromCards(tc))
		end
		tc=ag1:GetNext()
	end
end
function cm.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thfilter(c,g)
	return c:IsAbleToHand() and g:IsContains(c)
end
function cm.thop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local cg=tc:GetColumnGroup()
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,0,LOCATION_ONFIELD,nil,cg)
	if tc:IsRelateToEffect(e) then
		if not e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
			end
		end
	end
end