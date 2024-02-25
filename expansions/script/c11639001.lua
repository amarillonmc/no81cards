local m=11639001
local cm=_G["c"..m]
cm.name="射弹枪手"
function cm.initial_effect(c)
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetRange(0xff)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(cm.fuslimit)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6)
	--search
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,0))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_COUNTER)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetTarget(cm.thtg)
	e7:SetOperation(cm.thop)
	c:RegisterEffect(e7)
	--counter
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,1))
	e8:SetCategory(CATEGORY_COUNTER)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetTarget(cm.cttg)
	e8:SetOperation(cm.ctop)
	c:RegisterEffect(e8)
	--shoot!
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(m,2))
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_MZONE)
	e9:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e9:SetCondition(cm.shcon)
	e9:SetCost(cm.shcost)
	e9:SetTarget(cm.shtg)
	e9:SetOperation(cm.shop)
	c:RegisterEffect(e9)
	--change!
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(m,3))
	e10:SetCategory(CATEGORY_TOGRAVE+CATEGORY_EQUIP)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_MZONE)
	e10:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e10:SetCountLimit(1)
	e10:SetTarget(cm.chtg)
	e10:SetOperation(cm.chop)
	c:RegisterEffect(e10)
end
function cm.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function cm.thfilter(c)
	return c:IsSetCard(0xc221) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and e:GetHandler():IsCanAddCounter(0x1164,3) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if e:GetHandler():IsCanAddCounter(0x1164,3) then
			Duel.BreakEffect()
			e:GetHandler():AddCounter(0x1164,3)
		end
	end
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x1164)<3 and e:GetHandler():IsCanAddCounter(0x1164,(3-e:GetHandler():GetCounter(0x1164))) end
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetCounter(0x1164)>=3 then return end
	while e:GetHandler():GetCounter(0x1164)<3 do
		e:GetHandler():AddCounter(0x1164,1)
	end
end
function cm.shcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x1164)>0 and Duel.GetFlagEffect(tp,11639001)<=1
end
function cm.shcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(11639001)<=1 end
	e:GetHandler():RegisterFlagEffect(11639001,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
end
function cm.shfilter(c)
	return c:IsSetCard(0xc221) and c:IsType(TYPE_EQUIP)
end
function cm.shtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.shfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.shfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.shfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function cm.shop(e,tp,eg,ep,ev,re,r,rp)
	return
end
function cm.chfilter(c,sc)
	return c:IsType(TYPE_EQUIP) and c:GetEquipTarget()==sc and c:IsSetCard(0xc221)
end
function cm.chqfilter(c,tp,sc)
	return c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckEquipTarget(sc) and c:IsSetCard(0xc221)
end
function cm.chnoqfilter(c,tp,sc,code)
	return c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckEquipTarget(sc) and not c:IsCode(code) and c:IsSetCard(0xc221) 
end
function cm.chnoqcheck(sg,g)
	local tc=sg:GetFirst()
	while tc do
		if g:IsExists(Card.IsCode,1,nil,tc:GetCode()) then return false end
		tc=sg:GetNext()
	end
	return true
end
function cm.chqcheck(g,sg)
	return sg:CheckSubGroup(cm.chnoqcheck,#g,#g,g)
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.chfilter,tp,LOCATION_ONFIELD,0,nil,c)
	local sg=Duel.GetMatchingGroup(cm.chqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp,c)
	if chk==0 then return g:CheckSubGroup(cm.chqcheck,1,#g,sg) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.chfilter,tp,LOCATION_ONFIELD,0,nil,c)
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.chqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp,c)
	if #g<1 then return end
	if not g:CheckSubGroup(cm.chqcheck,1,#g,sg) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,cm.chqcheck,false,1,#g,sg)
	local ct=#tg
	if Duel.SendtoGrave(tg,REASON_EFFECT)==ct and sg:CheckSubGroup(cm.chnoqcheck,ct,ct,tg) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local eqg=sg:SelectSubGroup(tp,cm.chnoqcheck,false,ct,ct,tg)
		local tc=eqg:GetFirst()
		while tc do
			Duel.Equip(tp,tc,c)
			tc=eqg:GetNext()
		end
	end
end