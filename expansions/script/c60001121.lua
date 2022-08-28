--圣兽装骑·蜂-天行骑士
local m=60001121
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.AddSynchroMixProcedure(c,cm.matfilter1,nil,nil,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(cm.indtg)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	--activate cost  
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(cm.accon)
	e4:SetCost(cm.accost)
	e4:SetOperation(cm.acop)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCondition(cm.spcon1)
	e3:SetTarget(cm.sptg1)
	e3:SetOperation(cm.spop1)
	c:RegisterEffect(e3)
	local e27=Effect.CreateEffect(c)
	e27:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e27:SetProperty(EFFECT_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	e27:SetCode(EVENT_ADJUST)
	e27:SetOperation(cm.gravecheckop)
	Duel.RegisterEffect(e27,tp)
end

function cm.gravecheckop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)~=0 then
		e:GetHandler():RegisterFlagEffect(0,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60001111,0))
	end
end

function cm.matfilter1(c)
	return (c:IsSynchroType(TYPE_TUNER) or (c:IsSynchroType(TYPE_MONSTER) and c:IsSetCard(0x62e))) and c:IsSynchroType(TYPE_SYNCHRO)
end

function cm.indtg(e,c)
	return c:IsSetCard(0x62e)
end

function cm.efilter(e,te,ev)
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end

function cm.consfilter(c)
	return c:IsSetCard(0x62e) and c:IsSummonLocation(LOCATION_EXTRA)
end

function cm.accon(e)  
	cm[0]=false  
	return true  
end 
 
function cm.acfilter(c)  
	return not (c:IsAttack(0) and c:IsDefense(0)) and c:IsFaceup() 
end 

function cm.accost(e,te,tp)  
	return Duel.IsExistingMatchingCard(cm.acfilter,tp,LOCATION_MZONE,0,1,nil)  
end  

function cm.acop(e,tp,eg,ep,ev,re,r,rp)  
	if cm[0] then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	local g=Duel.SelectMatchingCard(tp,cm.acfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc then
			Duel.HintSelection(g)
			local oatk=tc:GetAttack()
			local odef=tc:GetDefense()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-1000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			if (oatk~=0 and tc:GetAttack()==0) or (odef~=0 and tc:GetDefense()==0) then
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end
	end
	cm[0]=true 
end

function cm.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end

function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.consfilter,tp,LOCATION_MZONE,0,1,nil) and rp==1-tp and
	(e:GetHandler():IsLocation(LOCATION_MZONE) or Duel.GetFlagEffect(tp,m)==0) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end

function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (c:IsLocation(LOCATION_MZONE) or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))) end
	c:ResetFlagEffect(m)
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.RegisterFlagEffect(tp,m,0,0,1)
		c:RegisterFlagEffect(m,0,0,1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

function cm.eqfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x662e) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end

function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT) and 
	c:IsRelateToEffect(e) and c:GetFlagEffect(m)~=0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and 
	Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local gg=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.HintSelection(g)
		Duel.HintSelection(gg)
		local tc=g:GetFirst()
		local sc=gg:GetFirst()
		if not Duel.Equip(tp,sc,tc) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(cm.eqlimit)
		sc:RegisterEffect(e1)
	end
end

function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end