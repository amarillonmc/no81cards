--圣军之药剂师 兰
local m=11631030
local cm=_G["c"..m]
--strings
cm.yaojishi=true 
function cm.initial_effect(c)
	--synchro summon  
	aux.AddSynchroProcedure(c,cm.matfilter,aux.NonTuner(cm.matfilter2),1,1)  
	c:EnableReviveLimit()
	--show
	if not cm.summonwords then
		cm.summonwords=true
		local e114=Effect.CreateEffect(c)
		e114:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e114:SetCode(EVENT_SPSUMMON)
		e114:SetOperation(cm.show)
		Duel.RegisterEffect(e114,tp)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(cm.valcheck)
	c:RegisterEffect(e1)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCondition(cm.regcon)
	e6:SetOperation(cm.regop)
	c:RegisterEffect(e6)
	e6:SetLabelObject(e1)
	--add attack  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)  
	e2:SetCode(EVENT_CHAINING)  
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetOperation(aux.chainreg)  
	c:RegisterEffect(e2)  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)  
	e3:SetCode(EVENT_CHAIN_SOLVED)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetOperation(cm.atkop)  
	c:RegisterEffect(e3)  
	--activate from hand  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_QP_ACT_IN_NTPHAND)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetTarget(cm.actfilter)  
	e4:SetTargetRange(LOCATION_HAND,0)  
	c:RegisterEffect(e4)  
	local e5=e4:Clone()  
	e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)  
	c:RegisterEffect(e5) 
end

--material
function cm.matfilter(c)  
	return c:IsCode(11631007)
end  
function cm.matfilter2(c)
	return c.yaojishi
end

--show
function cm.showfilter(c)
	return c:IsOriginalCodeRule(m) and c:GetSummonLocation()==LOCATION_EXTRA
end
function cm.show(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(cm.showfilter,1,nil) then return end
	Debug.Message("神明虔诚的信徒啊，将天上乐园在此显现吧！")
	Debug.Message("同调召唤！等级7！圣军之药剂师 兰！")
end
--01
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	local att=0
	local tc=g:GetFirst()
	while tc do
		if not tc:IsType(TYPE_TUNER) then
			att=bit.bor(att,tc:GetAttribute())
		end
		tc=g:GetNext()
	end
	e:SetLabel(att)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
		and e:GetLabelObject():GetLabel()~=0
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	if bit.band(att,ATTRIBUTE_WATER)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.spcon)
		e1:SetTarget(cm.sptg)
		e1:SetOperation(cm.spop)  
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	end
	if bit.band(att,ATTRIBUTE_FIRE)~=0 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTargetRange(LOCATION_ONFIELD,0)
		e3:SetTarget(cm.etarget)
		e3:SetValue(1)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	end
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)==0
end

function cm.spfilter(c,e,tp)
	return c.yaojishi and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end
end
function cm.etarget(e,c)
	return (c.zhiyaoshu or c.yaojishi)  and c~=e:GetHandler()
end

--search/negate
function cm.cfilter1(c)
	return c.yaojishi and c:IsAttribute(ATTRIBUTE_WATER) and not c:IsType(TYPE_TUNER)
end
function cm.cfilter2(c)
	return c.yaojishi and c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsType(TYPE_TUNER)
end
function cm.matcheck1(c)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:GetMaterial():IsExists(cm.cfilter1,1,nil)
end
function cm.matcheck2(c)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:GetMaterial():IsExists(cm.cfilter2,1,nil)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end  
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and (cm.matcheck1(c) or Duel.IsChainNegatable(ev))
end
function cm.thfilter(c)
	return c:IsAbleToHand() and (c.tezhiyao or c.zhiyaoshu)
end
function cm.tgf(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return 
		(cm.matcheck1(c) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)) or 
		(cm.matcheck2(c) and Duel.IsChainNegatable(ev))
	end
	if cm.matcheck1(c) then  
		e:SetCategory(e:GetCategory()+CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	if cm.matcheck2(c) and Duel.IsChainNegatable(ev) then
		e:SetCategory(e:GetCategory()+CATEGORY_NEGATE)
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then  
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)  
		end  
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end

	if cm.matcheck1(c) then
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then  
			Duel.ConfirmCards(1-tp,g)  
			local tc=Duel.GetOperatedGroup():GetFirst()
			if tc and tc:IsLocation(LOCATION_HAND) and tc.tezhiyao then
				Duel.ShuffleHand(tp)
				local e1=Effect.CreateEffect(c) 
				e1:SetDescription(aux.Stringid(m,1))
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end   
	if cm.matcheck2(c) and Duel.IsChainNegatable(ev) then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
			Duel.SetLP(1-tp,Duel.GetLP(1-tp)-1000)
		end
	end  

end

--add attack
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp and re:GetHandler().tezhiyao and c:GetFlagEffect(1)>0 then  
		Duel.Recover(tp,1000,REASON_EFFECT)
	end  
end  

--act in hand
function cm.actfilter(e,c)
	return c.tezhiyao and c:IsPublic()
end
