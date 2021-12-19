--顶峰超越之剑 崇高巴斯提昂
local m=40010111
local cm=_G["c"..m]
cm.named_with_KeterSanctuary=1
cm.named_with_Bastion=1
function cm.KeterSanctuary(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_KeterSanctuary
end

function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,m)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon1)
	e2:SetOperation(cm.sprop1)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCondition(cm.sprcon2)
	e3:SetOperation(cm.sprop2)
	c:RegisterEffect(e3) 
	--attribute
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_LEVEL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(cm.indtg)
	e4:SetTargetRange(LOCATION_MZONE+LOCATION_HAND,0)
	e4:SetValue(8)
	c:RegisterEffect(e4)  
	--immune effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(cm.etarget1)
	e5:SetValue(cm.efilter1)
	c:RegisterEffect(e5)
	--immune effect
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetCondition(cm.immcon2)
	e6:SetTarget(cm.etarget2)
	e6:SetValue(cm.efilter2)
	c:RegisterEffect(e6)
	--atk
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetCondition(cm.immcon2)
	e7:SetTarget(cm.atktg)
	e7:SetValue(2000)
	c:RegisterEffect(e7)
end
function cm.sprfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and c:IsRace(RACE_WARRIOR)
end
function cm.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and c:IsRace(RACE_WARRIOR) and g:IsExists(cm.sprfilter2,1,c,tp,c,sc,lv)
end
function cm.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:IsLevel(lv) and not c:IsType(TYPE_TUNER) and c:IsRace(RACE_WARRIOR)
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function cm.sprcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(cm.sprfilter1,1,nil,tp,g,c)
end
function cm.sprop1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,cm.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,cm.sprfilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function cm.sprcon2(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsCode,1,nil,40009559)
end
function cm.sprop2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,40009559)
	Duel.Release(g,REASON_COST)
end
function cm.indtg(e,c)
	return c:IsRace(RACE_WARRIOR) and c~=e:GetHandler()
end
function cm.etarget1(e,c)
	return c:IsRace(RACE_WARRIOR) 
end
function cm.efilter1(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_TRAP)
end
function cm.imfilter(c)
	return c:IsFaceup() and cm.KeterSanctuary(c)
end
function cm.immcon2(e)
	local ct=0
	local g=Duel.GetMatchingGroup(cm.imfilter,tp,LOCATION_MZONE,0,nil)
	for i,type in ipairs({TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK}) do
		if g:IsExists(Card.IsType,1,nil,type) then ct=ct+1 end
	end
	return ct>=3
end
function cm.etarget2(e,c)
	return c:IsRace(RACE_WARRIOR) 
end
function cm.efilter2(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_SPELL)
end
function cm.atktg(e,c)
	return cm.KeterSanctuary(c)
end

