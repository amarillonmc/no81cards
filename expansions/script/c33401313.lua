--五河士道 刻刻帝
local m=33401313
local cm=_G["c"..m]
function cm.initial_effect(c)
	 c:EnableReviveLimit()
	 c:EnableCounterPermit(0x34f)
--fusion material
	 aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xc342),cm.fa,true)
--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.hspcon)
	e0:SetOperation(cm.hspop)
	c:RegisterEffect(e0)
   --set counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.addct)
	e2:SetOperation(cm.addc)
	c:RegisterEffect(e2)
 --copy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,m)
	e6:SetTarget(cm.cptg)
	e6:SetOperation(cm.cpop)
	c:RegisterEffect(e6)
 --to hand from grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,m+10000)
	e4:SetTarget(cm.adtg)
	e4:SetOperation(cm.adop)
	c:RegisterEffect(e4)
end
function cm.fa(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FAIRY)
end

function cm.hspfilter(c,tp,sc)
	return c:IsSetCard(0xc342) 
		and c:IsControler(tp)  and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL) and Duel.CheckReleaseGroup(c:GetControler(),cm.hspfilter2,1,c,c:GetControler(),sc,tc)
end
function cm.hspfilter2(c,tp,sc,tc)
	local g=Group.CreateGroup()
	g:AddCard(tc)
	g:AddCard(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FAIRY)
		and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL) 
end
function cm.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),cm.hspfilter,1,nil,c:GetControler(),c)
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,cm.hspfilter,1,1,nil,tp,c)
	local tc1=g1:GetFirst()
	local g2=Duel.SelectReleaseGroup(tp,cm.hspfilter2,1,1,tc1,tp,c,tc1)
	g2:Merge(g1)
	c:SetMaterial(g2)
	Duel.Release(g2,REASON_COST)
end

function cm.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x34f,4)
end
function cm.addct(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,4,0,0x34f)
end
function cm.addc(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x34f,4)
	end
end

function cm.cpfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x341) and c:IsRace(RACE_FAIRY)
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.cpfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.cpfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,cm.cpfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,e:GetHandler())
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsOnField() or c:IsFacedown() then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		c:RegisterFlagEffect(33401301,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end

function cm.thfilter3(c)
	return c:IsSetCard(0x3340) or c:IsSetCard(0x3341) and c:IsAbleToHand()  
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter3,tp,LOCATION_GRAVE,0,1,nil)   
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)   
	local g1=Duel.GetMatchingGroup(cm.thfilter3,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter3,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end   
end