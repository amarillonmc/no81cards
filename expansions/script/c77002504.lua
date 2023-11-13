--太虚七剑 染香剑
local m=77002504
local cm=_G["c"..m]
function cm.initial_effect(c)
	--summon with 1 tribute
	local e31=Effect.CreateEffect(c)
	e31:SetDescription(aux.Stringid(m,2))
	e31:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e31:SetType(EFFECT_TYPE_SINGLE)
	e31:SetCode(EFFECT_SUMMON_PROC)
	e31:SetCondition(cm.otcon)
	e31:SetOperation(cm.otop)
	e31:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e31)
	local e32=e31:Clone()
	e32:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e32)
	--Effect 1
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_IGNITION)
	e01:SetRange(LOCATION_HAND)
	e01:SetCondition(cm.excon)
	e01:SetCost(cm.excost)
	e01:SetTarget(cm.extg)
	e01:SetOperation(cm.exop)
	c:RegisterEffect(e01)   
	--Effect 2  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e2)
	--Effect 3
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3) 
end
--summon with 1 tribute
function cm.f1(c)
	return c:IsFaceup() and c:IsSetCard(0x3eef)
end
function cm.otcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(cm.f1,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(cm.f1,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
--Effect 1
function cm.excon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.f1,tp,LOCATION_MZONE,0,1,nil)
end
function cm.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0
		and Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) end
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(cm.estg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.estg(e,c)
	return c:IsSetCard(0x3eef)
end
--Effect 2
--Effect 3 
function cm.con(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.thfilter2(c)
	return c:IsSetCard(0x3eef) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.sum(c)
	return c:IsSummonable(true,nil) and c:IsSetCard(0x3eef)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tc)
			Duel.ShuffleHand(tp)
			local mg=Duel.GetMatchingGroup(cm.sum,tp,LOCATION_HAND,0,nil)
			if tc:IsSetCard(0x3eef) then
				mg:AddCard(tc)
			end
			if #mg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.BreakEffect() 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local tcc=mg:Select(tp,1,1,nil):GetFirst()
				Duel.Summon(tp,tcc,true,nil)
			end
		end
	end
end