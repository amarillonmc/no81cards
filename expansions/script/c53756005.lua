if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53756005
local cm=_G["c"..m]
cm.name="愿闻的暮辞 羽由"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0xa530),LOCATION_MZONE)
	local e1,e1_1,e2,e3=SNNM.ActivatedAsSpellorTrap(c,0x20004)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetTarget(cm.acsptg)
	e1:SetOperation(cm.spop)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(cm.disop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_F)
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_SZONE)
	e6:SetLabel(1)
	e6:SetCondition(cm.spcon)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
	SNNM.ActivatedAsSpellorTrapCheck(c)
end
function cm.acsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CHAINING,true)
	if res and Duel.GetChainInfo(tev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	else
		e:SetLabel(0)
		e:SetCategory(0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local apply=true
	if not (Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE and rc:IsRelateToEffect(re) and rc:IsFaceup() and rc:IsSummonType(SUMMON_TYPE_SPECIAL)) then return end
	Duel.Hint(HINT_CARD,0,m)
	if Duel.CheckLPCost(rp,1000) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(rp,aux.Stringid(m,1)) then
		Duel.PayLPCost(rp,1000)
		if not c:IsImmuneToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			apply=false
			local e0=Effect.CreateEffect(c)
			e0:SetCode(EFFECT_CHANGE_TYPE)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e0:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			c:RegisterEffect(e0)
		end
	end
	if apply then
		Duel.NegateRelatedChain(rc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE_EFFECT)
		e1:SetValue(RESET_TURN_SET)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE and e:GetHandler():GetType()&0x20004==0x20004 and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 or not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_HAND)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
