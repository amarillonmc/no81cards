--未完成的极意
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000065)
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	local e3,e4,e5=rsef.FV_LIMIT_PLAYER(c,"sum,sp,fp",nil,nil,{1,0})
	local e6=rsef.SC(c,EVENT_TO_GRAVE)
	e6:SetOperation(cm.spop)
	local e7=rsef.STO(c,EVENT_LEAVE_FIELD,{m,1},nil,"se,th,ga","de,dsp",cm.thcon,nil,rsop.target(cm.thfilter,"th",rsloc.dg),cm.thop)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		--disable
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		--target
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(1)
		c:RegisterEffect(e2)
		--Equip limit
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_EQUIP_LIMIT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(cm.eqlimit)
		e3:SetLabelObject(tc)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
		--immue
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_EQUIP)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetValue(cm.efilter)
		c:RegisterEffect(e4)
		--release
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_EQUIP)
		e5:SetCode(EFFECT_UNRELEASABLE_SUM)
		e5:SetValue(1)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e5)
		local e6=e5:Clone()
		e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		c:RegisterEffect(e6)
	else
		c:CancelToGrave(false)
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner() and te:GetOwner()~=e:GetOwner():GetEquipTarget()
end
function cm.spop(e,tp)
	--ec:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA) and ec:IsFaceup()
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	if c and c:IsReason(REASON_LOST_TARGET) and ec and rscf.spfilter2()(ec,e,tp) and rsop.SelectYesNo(tp,{m,0}) then
		Duel.Hint(HINT_CARD,0,m)
		rssf.SpecialSummon(ec,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.thcon(e,tp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.thfilter(c)
	return c:IsCode(m+1,m+2,m+3) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter),tp,rsloc.dg,0,nil)
	if #g<=0 then return end
	local tg=g:SelectSubGroup(tp,aux.dncheck,false,1,3)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end