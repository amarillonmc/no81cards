local m=15000348
local cm=_G["c"..m]
cm.name="破灭之轮 无上辐光"
function cm.initial_effect(c)
	c:EnableReviveLimit()
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
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	--Controler
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.contg)
	e3:SetOperation(cm.conop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,m)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.sprfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function cm.sprfilter1(c,tp,sc)
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and c:IsType(TYPE_LINK) and c:IsRace(RACE_INSECT) and Duel.IsExistingMatchingCard(cm.sprfilter2,tp,LOCATION_MZONE,0,1,c,tp,c,sc)
end
function cm.sprfilter2(c,tp,mc,sc)
	local sg=Group.FromCards(c,mc)
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and c:IsAttribute(ATTRIBUTE_FIRE) and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.sprfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,cm.sprfilter1,1,1,nil,tp,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,cm.sprfilter2,1,1,mc,tp,mc,c)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
	Debug.Message("挣碎容器外壳的感染，穿透骑士梦境的异念！神殿顶端的巨光啊！")
	Debug.Message("调谐吧！等级1，与我共振！破灭之轮 无上辐光！")
end
function cm.contg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tp=e:GetHandler():GetControler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.ctval(e,c)
	return e:GetHandlerPlayer()
end
function cm.conop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.Equip(tp,c,tc) then
		--Add Equip limit
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_SET_DEFENSE)
		e3:SetValue(0)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
		--disable
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_EQUIP)
		e4:SetCode(EFFECT_DISABLE)
		c:RegisterEffect(e4)
		--control
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_EQUIP)
		e5:SetCode(EFFECT_SET_CONTROL)
		e5:SetValue(cm.ctval)
		c:RegisterEffect(e5)
	end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) and e:GetHandler():GetEquipTarget() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetEquipTarget(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) and c:GetEquipTarget() then return end
	local tc=c:GetEquipTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end