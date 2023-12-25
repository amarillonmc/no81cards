--幻影八芒星
cm={}
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_DISABLE)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e11:SetType(EFFECT_TYPE_ACTIVATE)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e11:SetCountLimit(1,m)
	e11:SetTarget(cm.target)
	e11:SetOperation(cm.tgop)
	c:RegisterEffect(e11)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_TARGET)
	e13:SetCode(EFFECT_UPDATE_DEFENSE)
	e13:SetValue(function(e,c) 
	return -c:GetDefense() end)
	e13:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e13)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_TARGET)
	e12:SetCode(EFFECT_UPDATE_ATTACK) 
	e12:SetValue(function(e,c)   
	return c:GetDefense() end)
	e12:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e12)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+10000000)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	e:SetLabel(g:GetFirst():GetDefense())
	cm[0]=g:GetFirst():GetDefense()
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc) 
		if (tc:IsSetCard(0x10db) or tc:IsSetCard(0x2073)) and tc:IsType(TYPE_XYZ) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetLabelObject(c)
			e1:SetCondition(cm.ngcon)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetLabelObject(c)
			e2:SetCondition(cm.ngcon)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end
function cm.ngcon(e)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	return tc and tc:IsLocation(LOCATION_ONFIELD)
end 
function cm.spellfilter(c,e,tp)
	return c:IsSetCard(0xdb) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE) and Duel.IsExistingMatchingCard(cm.spellfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(cm.spellfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	if tc then
		local lv=Duel.AnnounceLevel(tp,3,4)
		tc:AddMonsterAttribute(TYPE_NORMAL,ATTRIBUTE_DARK,RACE_WARRIOR,lv,0,0) 
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)  
	end
end