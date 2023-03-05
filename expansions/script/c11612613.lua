--龙仪巧-猎户流星=ORI
local m=11612613
local cm=_G["c"..m]
function c11612613.initial_effect(c)
	c:EnableReviveLimit()
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	c:RegisterEffect(e0)
	--01
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,0)
	e1:SetTarget(cm.tgtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--02
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.descon)
	--e2:SetCost(cm.descost)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.matcon)
	e3:SetOperation(cm.matop)
	c:RegisterEffect(e3)
	e0:SetLabelObject(e3)
	--03
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCountLimit(1,m+1)
	e4:SetCondition(aux.bdocon)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
end
function cm.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
end
function cm.lvfilter(c,rc)
	return c:GetRitualLevel(rc)>0
end
function cm.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(cm.lvfilter,nil,c)
	if #fg>0 and fg:GetSum(Card.GetRitualLevel,c)<=2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
--01
function cm.tgtg(e,c)
	return c~=e:GetHandler()
end
--02
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0 
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local cg=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		cg:AddCard(tc)
		Duel.Destroy(cg,REASON_EFFECT)
	end
end
--function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
--  if chk==0 then return Duel.CheckReleaseGroupEx(tp,nil,1,e:GetHandler()) end
--  local g=Duel.SelectReleaseGroupEx(tp,nil,1,1,e:GetHandler())
--  Duel.Release(g,REASON_COST)
--end
--03
function cm.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp)  end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)  then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	local tc=g:GetFirst() 
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		if tc:CheckActivateEffect(true,true,true)~=nil and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(true,true,true)
			Duel.ClearTargetCard()
			tc:CreateEffectRelation(e)
			local tg=te:GetTarget()
			if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
			te:SetLabelObject(e:GetLabelObject())
			e:SetLabelObject(te)
			local te=e:GetLabelObject()
			if not te then return end
			if not te:GetHandler():IsRelateToEffect(e) then return end
			e:SetLabelObject(te:GetLabelObject())
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
		end
	end
end
