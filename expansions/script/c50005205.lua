--五行缺钱
local m=50005205
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.val)
	c:RegisterEffect(e3)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.negcon)
	e2:SetTarget(cm.negtg)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
end
function cm.efilter(e,te)
	local tp=e:GetHandlerPlayer()
	return te:GetOwnerPlayer()==1-tp
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_EXTRA,0,c,POS_FACEUP)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_EXTRA,c,POS_FACEUP)
	return g:GetCount()>=5 and g1:GetCount()>=5 and ft>0 
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_EXTRA,0,c,POS_FACEUP)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_EXTRA,c,POS_FACEUP)
	local rg=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	rg=g:Select(tp,5,5,nil)
	rg1=g1:Select(tp,5,5,nil)
	rg:Merge(rg1)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function cm.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,0,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_MONSTER)*300
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		local cat=e:GetCategory()
		if bit.band(re:GetHandler():GetOriginalType(),TYPE_MONSTER)~=0 then
			e:SetCategory(bit.bor(cat,CATEGORY_SPECIAL_SUMMON))
		else
			e:SetCategory(bit.band(cat,bit.bnot(CATEGORY_SPECIAL_SUMMON)))
		end
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not Duel.NegateActivation(ev) then return end
	if rc:IsRelateToEffect(re) and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)~=0 and not rc:IsLocation(LOCATION_HAND+LOCATION_DECK)
		and not rc:IsHasEffect(EFFECT_NECRO_VALLEY) then
		if rc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and (not rc:IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp,tp,nil,rc)>0)
			and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
			and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEUP)
		elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and rc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			Duel.BreakEffect()
			Duel.SSet(tp,rc)
		end
	end
end