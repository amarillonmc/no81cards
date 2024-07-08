--閃刀姫－アザレア
local m=91030026
local cm=c91030026
function c91030026.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c91030026.lcheck)
	c:EnableReviveLimit()
	--spsummon condition
	 local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(aux.linklimit)
	c:RegisterEffect(e0)
	--destroy
	 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.cpcost)
	e1:SetCountLimit(1,91030026)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m+100)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.eqtg)
	e2:SetOperation(cm.eqop)
	c:RegisterEffect(e2)
end
function cm.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function cm.cpfilter(c)
	  return  c:IsType(TYPE_QUICKPLAY) and c:IsSetCard(0x9d3) and c:CheckActivateEffect(true,true,false) and c:IsAbleToRemoveAsCost()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return  Duel.IsExistingMatchingCard(cm.cpfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
   local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function cm.tgfilter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c)
end
function cm.eqfilter(c,tp)
	return c:IsFaceup()  and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.tgfilter(chkc,tp) end
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		return ft>0 and Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ec=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.eqfilter),tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,tc,tp):GetFirst()
	if ec and Duel.Equip(tp,ec,tc)then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetLabelObject(tc)
		e1:SetValue(cm.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
		--
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_BOTH_BATTLE_DAMAGE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e2,true)
		--substitute
		local e3=Effect.CreateEffect(c)
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_BATTLE_DAMAGE)
		e3:SetRange(LOCATION_SZONE)
		e3:SetLabelObject(ec)
		e3:SetCountLimit(1)
		e3:SetCondition(cm.condition2)
		e3:SetTarget(cm.target2)
		e3:SetOperation(cm.activate2)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e3,true)
		local fid=e:GetHandler():GetFieldID()
		ec:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetLabel(fid)
		e4:SetLabelObject(ec)
		e4:SetCondition(cm.descon)
		e4:SetOperation(cm.desop)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
		local e5=Effect.CreateEffect(ec)
		e5:SetType(EFFECT_TYPE_EQUIP)
		e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		e5:SetValue(1)
		ec:RegisterEffect(e5,true)
	end
end
function cm.desrepval(e,re,r,rp)
	return r&(REASON_BATTLE|REASON_EFFECT)~=0
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(m)==e:GetLabel()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec  and ep==tp
end
function cm.filter(c,e,tp,dam)
	return c:IsAttackBelow(dam) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ev) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil,e,tp,ev)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ev)
	if g:GetCount()<1 then return end
	local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
	Duel.BreakEffect()
	if not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
			local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.LinkSummon(tp,sg:GetFirst(),nil)
			end 
	end
end

















function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x9d3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		if Duel.Destroy(g,REASON_EFFECT)>0  then
			if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end



