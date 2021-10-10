--伏魔影密忍军 百鬼佐拉·阿僧祗
local m=40009913
local cm=_G["c"..m]
cm.named_with_Covertforces=1
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,cm.ffilter,2,63,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_ONFIELD,0,Duel.SendtoGrave,REASON_COST)
	--change name
	aux.EnableChangeCode(c,40009509,LOCATION_MZONE+LOCATION_GRAVE)   
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)   
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.matcheck)
	c:RegisterEffect(e2) 
end
function cm.Covertforces(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Covertforces
end
function cm.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function cm.ffilter(c,fc)
	return cm.Covertforces(c) 
end
function cm.matcheck(e,c)
	local ct=c:GetMaterialCount()
	if ct==2 then
		--special summon
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,0))
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1,m)
		e2:SetTarget(cm.target)
		e2:SetOperation(cm.operation)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	end
	if ct==4 then
		--negate
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(m,2))
		e4:SetCategory(CATEGORY_NEGATE)
		e4:SetType(EFFECT_TYPE_QUICK_O)
		e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e4:SetCode(EVENT_CHAINING)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCountLimit(1)
		e4:SetCondition(cm.negcon)
		e4:SetTarget(cm.negtg)
		e4:SetOperation(cm.negop)
		c:RegisterEffect(e4)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	end
	if ct==6 then
		--to hand
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(m,4))
		e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e5:SetType(EFFECT_TYPE_IGNITION)
		e5:SetCountLimit(1)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCost(cm.spcost)
		e5:SetTarget(cm.sptg)
		e5:SetOperation(cm.spop)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		c:RegisterEffect(e5)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
	end
end
function cm.filter(c,e,tp)
	return cm.Covertforces(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function cm.costfilter1(c,e,tp)
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp)
end
function cm.costfilter2(c)
	return c:IsCode(m) and c:IsAbleToRemoveAsCost()
end
function cm.spfilter(c,e,tp)
	return cm.Covertforces(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(cm.costfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.costfilter2,tp,LOCATION_EXTRA,0,1,nil)
		else
			return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g1=Duel.SelectMatchingCard(tp,cm.costfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		local g2=Duel.SelectMatchingCard(tp,cm.costfilter2,tp,LOCATION_EXTRA,0,1,1,nil)
		Duel.SendtoGrave(g1,REASON_COST+REASON_DISCARD)
		Duel.Remove(g2,POS_FACEUP,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=nil
	if tg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=tg:Select(tp,ft,ft,nil)
	else
		g=tg
	end
	if g:GetCount()>0 then
		local fid=e:GetHandler():GetFieldID()
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(g)
		e1:SetCondition(cm.thcon)
		e1:SetOperation(cm.thop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.thfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.thfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.thfilter,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end