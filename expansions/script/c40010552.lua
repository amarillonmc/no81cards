--武装宝剑 魔剑伐楼利拿
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40010552,"Vairina")
local m=40010552
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
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.condition)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetCondition(cm.condition)
	e4:SetValue(1)
	c:RegisterEffect(e4)
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
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF 
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		--actlimit
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTargetRange(0,1)
		e3:SetValue(cm.aclimit)
		e3:SetCondition(cm.actcon)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	end
end
function cm.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
