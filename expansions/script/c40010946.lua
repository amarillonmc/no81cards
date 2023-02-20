--龙树之落胤 不安定
local m=40010946
local cm=_G["c"..m]
cm.named_with_DragonTree=1
function cm.DragonTree(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_DragonTree) or c:IsCode(40010936)
end
function cm.CaLaMity(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_CaLaMity
end
function cm.initial_effect(c)
	--Effect 1
	local e02=Effect.CreateEffect(c)  
	e02:SetDescription(aux.Stringid(m,3))
	e02:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e02:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e02:SetType(EFFECT_TYPE_IGNITION)
	e02:SetRange(LOCATION_HAND)
	e02:SetCountLimit(1,m+m)
	e02:SetTarget(cm.thtg)
	e02:SetOperation(cm.thop)
	c:RegisterEffect(e02)  
	--Effect 2  
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetOperation(cm.dreop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
--Effect 1
function cm.thfilter(c)
	local b1=cm.DragonTree(c) and c:IsType(TYPE_MONSTER)
	local b2=cm.CaLaMity(c)
	return (b1 or b2) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	local spsum=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) and spsum end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 or not tc:IsRelateToEffect(e) then return false end
	Duel.BreakEffect()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end  
--Effect 2
function cm.cf(c)
	return c:IsFaceup() and c:IsCode(40010932)
end
function cm.sp(c,e,tp,code)
	return not c:IsCode(code) and cm.DragonTree(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.dreop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.CreateToken(tp,40010932)
	if tc==nil then return false end
	local te=tc:GetActivateEffect()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(cm.sp,tp,LOCATION_HAND,0,nil,e,tp,m)
	local cgt=Duel.GetMatchingGroupCount(cm.cf,tp,LOCATION_ONFIELD,0,nil)
	local extg=cgt>0 and ft>0 and #g>0
	local actchk=te:IsActivatable(tp,true,true)
	if not actchk then
		if extg then
			cm.exop(e,tp)
		else
			return 
		end
	else
		if extg and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			cm.exop(e,tp)
		else
			cm.actop(e,tp,tc)
		end
	end
end
function cm.exop(e,tp)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(cm.sp,tp,LOCATION_HAND,0,nil,e,tp,m)
	if ft==0 or #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	if #sg==0 then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
function cm.actop(e,tp,tc)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,2))
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end