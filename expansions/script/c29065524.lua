--追猎命运
local m=29065524
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return cm.Ark_Knight_check(c) or c:IsType(TYPE_XYZ)
end
function cm.check(c)
	return cm.Ark_Knight_check(c) and c:IsFaceup()
end
function cm.condition(e,tp,eg,ep,ev,r,rp)
	return ep~=tp and Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_MZONE,0,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return not (cm.Ark_Knight_check(c) or c:IsType(TYPE_XYZ))
end
function cm.ffilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c,e,tp)
end
function cm.spfilter(c,fc,e,tp)
	return aux.IsMaterialListCode(fc,c:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.A_check(c)
	return c:IsFaceup() and c:IsCode(29065500)
end
function cm.C_check(c)
	return c:IsFaceup() and c:IsCode(29065505)
end
function cm.A_add_check(c)
	return c:IsAbleToHand() and c:IsCode(29065500)
end
function cm.C_add_check(c)
	return c:IsAbleToHand() and c:IsCode(29065505)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(cm.etarget)
	e1:SetValue(cm.efilter)
	e1:SetReset(RESET_PHASE+PHASE_MAIN1)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)==1 then
		local a=Duel.IsExistingMatchingCard(cm.A_check,tp,LOCATION_MZONE,0,1,nil)  local a1=Duel.IsExistingMatchingCard(cm.C_add_check,tp,LOCATION_DECK,0,1,nil)
		local b=Duel.IsExistingMatchingCard(cm.C_check,tp,LOCATION_MZONE,0,1,nil) local b1=Duel.IsExistingMatchingCard(cm.A_add_check,tp,LOCATION_DECK,0,1,nil)
		if ((a and not b and a1) or (not a and b and b1)) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			local sg=Group.CreateGroup()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			if a then
				tg=Duel.SelectMatchingCard(tp,cm.C_add_check,tp,LOCATION_DECK,0,1,1,nil)
			else
				tg=Duel.SelectMatchingCard(tp,cm.A_add_check,tp,LOCATION_DECK,0,1,1,nil)
			end
			Duel.SendtoHand(tg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() 
end
function cm.etarget(e,c)
	return cm.Ark_Knight_check(c) and c:IsFaceup()
end
function cm.Ark_Knight_check(c)
	local code1,code2=c:GetCode()
	local subtr=nil
	local subtr2=nil
	local ccodem1=nil
	local ccodem2=nil
	if code1 then
		if not _G["c"..code1] then _G["c"..code1]={}
			setmetatable(_G["c"..code1],Card)
			_G["c"..code1].__index=_G["c"..code1]
		end
		ccodem1=_G["c"..code1]   
	end
	if code2 then
		if not _G["c"..code2] then _G["c"..code2]={}
			setmetatable(_G["c"..code2],Card)
			_G["c"..code2].__index=_G["c"..code2]
		end
		ccodem2=_G["c"..code2]   
	end
	return c:IsSetCard(0x87af) or (ccodem1 and ccodem1.named_with_Arknight) or (ccodem2 and ccodem2.named_with_Arknight)
end
